//
//  ImageMixer.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import UIKit
import Photos

struct ImageMixer {
    static func combineAndStore(
        renderSize: CGSize,
        progressObserver: ProgressObserver? = nil,
        assets: [CombinerAsset],
        needAutoEnhance: Bool,
        alsoSaveToPhotos: Bool
    ) throws -> CombinerOutput {
        var image = try combine(renderSize: renderSize,
                                progressObserver: progressObserver,
                                assets: assets)
        
        if needAutoEnhance {
            image = image.autoEnhance()
        }
        
        let imageURL = try FilteringProcessor().generateAndSave(ciImage: image, withJPGQuality: 1)
        
        if alsoSaveToPhotos {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageURL)
            })
        }
        
        return .init(cover: imageURL,
                     url: imageURL,
                     aspect: renderSize.aspect)
    }
    
    private static func combine(
        renderSize: CGSize,
        progressObserver: ProgressObserver? = nil,
        assets: [CombinerAsset]
    ) throws -> CIImage {
        progressObserver?.addProgress(title: "Подготовка изображения для генерации...") // for BG
        var sorted = assets.sorted(by: { $0.transform.zIndex < $1.transform.zIndex })
        var resultImage = sorted.removeFirst().body.imageBody!.ciImage
        
        for asset in sorted where asset.body.imageBody != nil {
            autoreleasepool {
                resultImage = asset.body.imageBody!.ciImage
                    .composited(with: resultImage,
                                canvasSize: renderSize,
                                transform: asset.transform)
            }
            progressObserver?.addProgress(title: "Генерация изображения...")
        }
            
        resultImage = resultImage.cropped(to: CGRect(origin: .zero, size: renderSize))
        
        return resultImage
    }
}
