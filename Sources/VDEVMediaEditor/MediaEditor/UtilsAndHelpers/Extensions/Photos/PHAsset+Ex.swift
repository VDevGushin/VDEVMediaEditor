//
//  PHAsset+Ex.swift
//  
//
//  Created by Vladislav Gushin on 01.05.2023.
//

import Photos
import PhotosUI
import SwiftUI

enum PHAssetError: Error {
    case noURL
}

extension PHAsset {
    
    func getImage() -> UIImage? {
        var phImage: UIImage?
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        PHImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { image, _ in
            phImage = image
        }
        
        return phImage
    }
    
    func getURL() async throws -> URL {
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                 true
            }
        
            return try await withCheckedThrowingContinuation { c in
                self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                    let url = contentEditingInput?.fullSizeImageURL as URL?
                    guard let url = url else {
                        c.resume(throwing: PHAssetError.noURL)
                        return
                    }
                    
                    c.resume(returning: url)
                })
            }
        }
        
        if mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            
            return try await withCheckedThrowingContinuation { c in
                PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                    if let urlAsset = asset as? AVURLAsset {
                        let localVideoUrl: URL = urlAsset.url as URL
                        c.resume(returning: localVideoUrl)
                    } else {
                        c.resume(throwing: PHAssetError.noURL)
                    }
                })
            }
        }
        
        throw PHAssetError.noURL
    }
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
