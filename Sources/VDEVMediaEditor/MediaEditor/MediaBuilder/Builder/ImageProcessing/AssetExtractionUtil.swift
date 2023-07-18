//
//  AssetExtractionUtil.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import UIKit
import Photos
import Kingfisher

struct AssetExtractionUtil {
    static func image(fromUrl url: URL, storeCache: Bool = true) -> CIImage? {
        return SessionCache<CIImage>.data(from: url, storeCache: storeCache, extractor: {
            if let fetchResult = fetchResult(forUrl: url) {
                guard let asset = fetchResult.firstObject else { return nil }
                let semaphore = DispatchSemaphore(value: 0)
                var ciImage: CIImage? = nil
                DispatchQueue.global(qos: .utility).async {
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { (data, dataUTI, orientation, info) in
                        if let safeData = data {
                            ciImage = CIImage(data: safeData, options: [.applyOrientationProperty: true])
                        }
                        semaphore.signal()
                    }
                }
                _ = semaphore.wait(timeout: .now() + 60)
                return ciImage
            } else {
                
                let semaphore = DispatchSemaphore(value: 0)
                
                var ciImage: CIImage? = nil
                
                loadFromURL(from: url) { image in
                    ciImage = image != nil ? CIImage(image: image!,
                                                     options: [.applyOrientationProperty: true]) : nil
                    semaphore.signal()
                }
                
                _ = semaphore.wait(timeout: .now() + 60)
                
                return ciImage
            }
        }())
    }
    
    static func image(fromURL url: URL) async -> UIImage? {
        if let fetchResult = fetchResult(forUrl: url) {
            guard let asset = fetchResult.firstObject,
                  asset.mediaType == .image else {
                return nil
            }
            return await withCheckedContinuation { c in
                PHImageManager.default().requestImageDataAndOrientation(for: asset, options: nil) { (data, dataUTI, orientation, info) in
                    guard let safeData = data,
                          let ciImage = CIImage(data: safeData, options: [.applyOrientationProperty: true]) else {
                        c.resume(returning: nil)
                        return
                    }
                    c.resume(returning: UIImage(ciImage: ciImage))
                }
            }
        } else {
            return await Task<UIImage?, Never>.detached(priority: .utility) {
                guard let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data) else {
                    return nil
                }
                return image
            }.value
        }
    }
    
    static func video(fromURL url: URL) async -> AVAsset? {
        guard let fetchResult = fetchResult(forUrl: url) else {
            return AVAsset(url: url)
        }
        
        guard let asset = fetchResult.firstObject,
              asset.mediaType == .video else {
            return nil
        }
        
        return await withCheckedContinuation { c in
            PHImageManager().requestAVAsset(forVideo: asset, options: nil) { (avAsset, _, _) in
                guard let avAsset = avAsset else {
                    c.resume(returning: nil)
                    return
                }
                c.resume(returning: avAsset)
            }
        }
    }
}

private extension AssetExtractionUtil {
    static func fetchResult(forUrl url: URL) -> PHFetchResult<PHAsset>? {
        if url.scheme?.hasPrefix("assets-library") ?? false {
            if #available(iOS 12, *) {
                return nil
            } else {
                return PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
            }
        } else if url.scheme?.hasPrefix("ph") ?? false {
            var identifier = url.absoluteString
            // remove "ph://"
            identifier.removeFirst(5)
            return PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        } else {
            return nil
        }
    }
    
    static func loadFromURL(from url: URL,
                            completion: @escaping (UIImage?) -> Void) {
        Task {
            guard let cacheResult = try? await ImageCache.default.retrieveImage(
                downloadAndStoreIfNeededFrom: url,
                forKey: url.absoluteString,
                options: []
            ) else {
                return completion(nil)
            }
            
            completion(cacheResult.image)
        }
    }
}
