//
//  ImageMixerPng.swift
//  
//
//  Created by Vladislav Gushin on 30.04.2023.
//

import Foundation
import UIKit
import Photos

final class ImageMixerPng {
    private let renderSize: CGSize
    private let progressObserver: ProgressObserver?
    
    init(renderSize: CGSize, progressObserver: ProgressObserver? = nil) {
        self.renderSize = renderSize
        self.progressObserver = progressObserver
    }
    
    func combineAndStore(assets: [CombinerAsset], alsoSaveToPhotos: Bool) throws -> (image: CIImage, cover: URL, uri: URL) {
        let image = try combine(assets: assets)
        
        let imageURL = try FilteringProcessor().generateAndSavePNGImage(ciImage: image)
        
        if alsoSaveToPhotos {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageURL)
            })
        }
        
        return (image, imageURL, imageURL)
    }
    
    private func combine(assets: [CombinerAsset]) throws -> CIImage {
        var sorted = assets.sorted(by: { $0.transform.zIndex < $1.transform.zIndex })
        var resultImage = sorted.removeFirst().body.imageBody!.ciImage
        
        for asset in sorted where asset.body.imageBody != nil {
            autoreleasepool {
                resultImage = asset.body.imageBody!.ciImage
                    .composited(with: resultImage,
                                canvasSize: renderSize,
                                transform: asset.transform)
            }
        }
            
        resultImage = resultImage.cropped(to: CGRect(origin: .zero, size: renderSize))
        return resultImage
    }
}
