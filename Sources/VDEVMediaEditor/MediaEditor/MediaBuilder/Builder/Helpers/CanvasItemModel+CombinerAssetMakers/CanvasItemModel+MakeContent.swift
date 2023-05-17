//
//  CanvasItemModel+MakeContent.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.03.2023.
//

import Foundation
import Photos
import AVKit

extension CanvasItemModel {
    func makeImageAsset(canvasNativeSize: CGSize,
                        scaleFactor: CGFloat,
                        layerIndex i: Int,
                        progressObserver: ProgressObserver? = nil) async -> CombinerAsset? {

        Log.d("Begin to make image asset")
        
        var ciImage: CIImage

        switch self.type {

        case .image:
            Log.d("Item is simple image")
            
            progressObserver?.setMessage(value: "Подготовка изображения...")
            
            let item: CanvasImageModel = CanvasItemModel.toType(model: self)
            
            let canvasImage = item.image
            let filteredImageFromOriginal = await item.getFilteredOriginal()
            
            let imageForPrecessed = filteredImageFromOriginal ?? canvasImage
            
            guard let processedCIImage = imageForPrecessed.rotatedCIImage else {
                Log.e("Can't get ciImage")
                return nil
            }
            
            ciImage = processedCIImage

        case .sticker:
            Log.d("Item is sticker")
            
            progressObserver?.setMessage(value: "Подготовка стикера...")
            
            let item: CanvasStickerModel = CanvasItemModel.toType(model: self)
            guard let processedCIImage = item.image.rotatedCIImage else {
                Log.e("Can't get ciImage")
                return nil
            }
            ciImage = processedCIImage

        case .drawing:
            Log.d("Item is drawing")
            
            progressObserver?.setMessage(value: "Подготовка рисунка...")
            
            let item: CanvasDrawModel = CanvasItemModel.toType(model: self)
            
            guard let processedCIImage = item.image.rotatedCIImage else {
                Log.e("Can't get ciImage")
                return nil
            }
            
            ciImage = processedCIImage

        default:
            return nil
        }

        ciImage = ciImage
            .frame(frameFetchedSize * scaleFactor, contentMode: .scaleAspectFill)
            .cropped(to: CGRect(origin: .zero, size: frameFetchedSize * scaleFactor))

        Log.d("End to make image asset")
        
        return CombinerAsset(
            body: .init(ciImage: ciImage),
            transform: Transform(
                zIndex: Double(i),
                offset: offset * scaleFactor,
                scale: scale,
                degrees: rotation.degrees,
                blendingMode: blendingMode
            )
        )
    }
    
    func makeAudioAsset(canvasNativeSize: CGSize,
                        scaleFactor: CGFloat,
                        layerIndex i: Int,
                        progressObserver: ProgressObserver? = nil) async -> CombinerAsset? {
        guard self.type == .audio else { return nil }
        
        Log.d("Begin to make audio asset")
        
        progressObserver?.setMessage(value: "Подготовка аудио...")
        
        let item: CanvasAudioModel = CanvasItemModel.toType(model: self)
        
        let asset = AVAsset(url: item.audioURL)
        
        return CombinerAsset(
            body: .init(asset: asset,
                        preferredVolume: item.volume,
                        cycleMode: .loopToLongestVideo),
            transform: Transform(
                zIndex: Double(i),
                offset: offset * scaleFactor,
                scale: scale,
                degrees: rotation.degrees,
                blendingMode: blendingMode
            )
        )
    }

    func makeVideoAsset(canvasNativeSize: CGSize,
                        scaleFactor: CGFloat,
                        layerIndex i: Int,
                        progressObserver: ProgressObserver? = nil) async -> CombinerAsset? {

        guard self.type == .video else { return nil }
        
        Log.d("Begin to make video asset")
        
        progressObserver?.setMessage(value: "Подготовка видео...")
        
        let item: CanvasVideoModel = CanvasItemModel.toType(model: self)
        
        let canvasURL = item.videoURL
        let originalURL = await item.getOriginal()
        
        var processedUrl = originalURL ?? canvasURL
        
        let asset = AVAsset(url: processedUrl)

        guard let originalAssetSize = await asset.getSize() else {
            Log.e("Can't detect original asset size")
            return nil
        }

        let targetAssetSize = frameFetchedSize * scaleFactor

        let needResize = targetAssetSize != originalAssetSize

        if !filterChain.isEmpty || needResize {
            
            progressObserver?.setMessage(value: "Применение фильтров и изменение размера...")
            
            Log.d("Apply filters to video [filters count: \(filterChain.count)]")
            
            guard let filteredURL = try? await FilteringProcessor.shared.processAndExport(
                asset: asset,
                filterChain: filterChain,
                resize: (targetAssetSize, .scaleAspectFill),
                exportQuality: .HEVCHighestWithAlpha) else {
                Log.e("Error to apply filters to video")
                return nil
            }
            
            processedUrl = filteredURL
        }

        Log.d("End to make video asset")
        
        return CombinerAsset(
            body: .init(asset: AVAsset(url: processedUrl),
                        preferredVolume: item.volume,
                        cycleMode: .loopToLongestVideo),

            transform: Transform(
                zIndex: Double(i),
                offset: offset * scaleFactor,
                scale: scale,
                degrees: rotation.degrees,
                blendingMode: blendingMode
            )
        )
    }

    func makeLabelAsset(canvasNativeSize: CGSize,
                        scaleFactor: CGFloat,
                        layerIndex i: Int,
                        progressObserver: ProgressObserver? = nil) async -> CombinerAsset? {

        guard self.type == .text else { return nil }
        
        progressObserver?.setMessage(value: "Подготовка текста...")

        Log.d("Begin to make label asset")
        
        let item: CanvasTextModel = CanvasItemModel.toType(model: self)

        var ciImage = TextView.makeLabelImage(
            naturalContainerWidth: frameFetchedSize.width * scaleFactor,
            scale: scaleFactor,
            text: item.text,
            textAlignment: item.textAlignment,
            textStyle: item.textStyle,
            fontSize: item.fontSize,
            textColor: item.color,
            needTextBG: item.needTextBG
        )

        let size = frameFetchedSize * scaleFactor

        if ciImage.extent.height > size.height {
            ciImage = ciImage
                .resized(to: size, withContentMode: .scaleAspectFit)
        } else {
            
            let contentMode = UIView.ContentMode(verticalAlignment: item.alignment, horizontalAlignment: item.textAlignment)
            
            ciImage = ciImage
                .resized(to: size, withContentMode: contentMode)
        }

        Log.d("End to make label asset")
        
        return CombinerAsset(
            body: .image(.init(ciImage: ciImage)),
            transform: Transform(
                zIndex: Double(i),
                offset: offset * scaleFactor,
                scale: scale,
                degrees: rotation.degrees,
                blendingMode: blendingMode
            )
        )
    }
}

