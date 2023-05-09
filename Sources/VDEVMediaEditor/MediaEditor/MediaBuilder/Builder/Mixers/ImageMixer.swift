//
//  ImageMixer.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import UIKit
import Photos

final class ImageMixer {
    @Injected private var resultSettings: VDEVMediaEditorResultSettings
    
    private let renderSize: CGSize
    private let progressObserver: ProgressObserver?
    
    init(renderSize: CGSize, progressObserver: ProgressObserver? = nil) {
        self.renderSize = renderSize
        self.progressObserver = progressObserver
    }
    
    func combineAndStore(assets: [CombinerAsset],
                         alsoSaveToPhotos: Bool) throws -> (image: CIImage, cover: URL, uri: URL) {
        var image = try combine(assets: assets)
        
        if resultSettings.needAutoEnhance {
            image = image.autoEnhance()
        }
        
        let imageURL = try FilteringProcessor.shared.generateAndSave(ciImage: image, withJPGQuality: 1)
        
        if alsoSaveToPhotos {
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imageURL)
            })
        }
        
        return (image, imageURL, imageURL)
    }
    
    private func combine(assets: [CombinerAsset]) throws -> CIImage {
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
