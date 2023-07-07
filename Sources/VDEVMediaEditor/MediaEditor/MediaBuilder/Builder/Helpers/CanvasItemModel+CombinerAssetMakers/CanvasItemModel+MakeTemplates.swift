//
//  CanvasItemModel+MakeTemplates.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.03.2023.
//

import Foundation
import Photos
import AVKit
import PhotosUI

extension CanvasItemModel {
    
    func makeTemplateAsset(
        scaleFactor: CGFloat,
        layerIndex: Int,
        progressObserver: ProgressObserver? = nil
    ) async -> [CombinerAsset]? {
        
        Log.d("Begin to make template asset")
        
        guard self.type == .template else { return nil }
        
        let item: CanvasTemplateModel = CanvasItemModel.toType(model: self)
        
        Log.d("Begin to make inner template items")
        
        progressObserver?.setMessage(value: "Подготовка шаблона...")
        
        let result = await item.layerItems.makeCombinerInputFromTemplate(
            item: item,
            scaleFactor: scaleFactor,
            startIndex: layerIndex,
            progressObserver: progressObserver)
        
        if result.isEmpty {
            return nil
        }
        
        return result
    }
}

extension Array where Element == CanvasItemModel {
    func makeCombinerInputFromTemplate(
        item: CanvasTemplateModel,
        scaleFactor: CGFloat,
        startIndex: Int,
        progressObserver: ProgressObserver? = nil
    ) async -> [CombinerAsset] {
        Log.d("Begin to make template items")
        
        var images = [CombinerAsset]()
        var editedLabels = [CombinerAsset]()
        var labels = [CombinerAsset]()
        var placeHolders = [CombinerAsset]()
        
        var zIndex = startIndex
        for i in 0..<self.count {
            
            let element = self[i]
            
            if let placeholderAsset = await element.makePlaceholderAsset(
                scaleFactor: scaleFactor,
                layerIndex: zIndex,
                progressObserver: progressObserver
            ) {
                progressObserver?.addProgress()
                placeHolders.append(placeholderAsset)
                zIndex += 1
            }
            
            if let imageAsset = await element.makeTemplateImageAsset(
                scaleFactor: scaleFactor,
                layerIndex: zIndex,
                progressObserver: progressObserver
            ) {
                progressObserver?.addProgress()
                images.append(imageAsset)
                zIndex += 1
            }
            
            if let editedLabelsAsset = await element.makeTemplateEditedLabelAsset(
                scaleFactor: scaleFactor,
                layerIndex: zIndex,
                progressObserver: progressObserver
            ) {
                progressObserver?.addProgress()
                editedLabels.append(editedLabelsAsset)
                zIndex += 1
            }
            
            if let labelsAsset = await element.makeTemplateLabelAsset(
                scaleFactor: scaleFactor,
                layerIndex: zIndex,
                progressObserver: progressObserver
            ) {
                progressObserver?.addProgress()
                labels.append(labelsAsset)
                zIndex += 1
            }
        }
        
        Log.d("Templates placeholders asset [count: \(placeHolders.count)]")
        Log.d("Templates images asset [count: \(images.count)]")
        Log.d("Templates edited Labels asset [count: \(editedLabels.count)]")
        Log.d("Templates labels asset [count: \(labels.count)]")
        
        let res = placeHolders + images + editedLabels + labels
        
        Log.d("Template assets [count: \(res.count)]")
        
        return res
    }
}

// MARK: - Templates (Images, Labels, Button with select image and video)
extension CanvasItemModel {
    
    func makeTemplateLabelAsset(scaleFactor: CGFloat,
                                layerIndex i: Int,
                                progressObserver: ProgressObserver? = nil) async -> CombinerAsset? {
        
        guard self.type == .text else {
            return nil
        }
        
        progressObserver?.setMessage(value: "Подготовка текста в шаблоне...")
        
        let item: CanvasTextModel = CanvasItemModel.toType(model: self)
        
        var ciImage = TextView.makeLabelImage(
            naturalContainerWidth: item.bounds.width * scaleFactor,
            scale: scaleFactor,
            text: item.text,
            textAlignment: item.textAlignment,
            textStyle: item.textStyle,
            fontSize: item.fontSize,
            textColor: item.color,
            needTextBG: item.needTextBG
        )
        
        let size = item.bounds.size  * scaleFactor
        
        if ciImage.extent.height > size.height {
            ciImage = ciImage
                .resized(to: size, withContentMode: .scaleAspectFit)
        } else {
            let contentMode = UIView.ContentMode(verticalAlignment: item.alignment, horizontalAlignment: item.textAlignment)
            
            ciImage = ciImage
                .resized(to: size, withContentMode: contentMode)
        }
        
        return CombinerAsset(
            body: .image(.init(ciImage: ciImage)),
            transform: Transform(
                zIndex: Double(i),
                offset: item.offset * scaleFactor,
                scale: item.scale,
                degrees: item.rotation.degrees,
                blendingMode: item.blendingMode
            )
        )
    }
    
    func makeTemplateEditedLabelAsset(scaleFactor: CGFloat,
                                      layerIndex i: Int,
                                      progressObserver: ProgressObserver? = nil) async -> CombinerAsset? {
        
        guard self.type == .textForTemplate else {
            return nil
        }
        
        progressObserver?.setMessage(value: "Подготовка текста в шаблоне...")
        
        let boxItem: CanvasTextForTemplateItemModel = CanvasItemModel.toType(model: self)
        let item: CanvasTextModel = boxItem.text
        
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
        
        
        return CombinerAsset(
            body: .image(.init(ciImage: ciImage)),
            transform: Transform(
                zIndex: Double(i),
                offset: item.offset * scaleFactor,
                scale: item.scale,
                degrees: item.rotation.degrees,
                blendingMode: item.blendingMode
            )
        )
    }
    
    func makeTemplateImageAsset(scaleFactor: CGFloat,
                                layerIndex i: Int,
                                progressObserver: ProgressObserver? = nil) async -> CombinerAsset? {
        
        var ciImage: CIImage
        
        Log.d("Begin to make image asset")
        
        switch self.type {
            
        case .image:
            progressObserver?.setMessage(value: "Подготовка изображения в шаблоне...")
            
            let item: CanvasImageModel = CanvasItemModel.toType(model: self)
            
            guard let processedCIImage = item.image.rotatedCIImage else {
                Log.e("Can't get ci image")
                return nil
            }
            
            ciImage = processedCIImage
            
        default:
            return nil
        }
        
        ciImage = ciImage
            .frame(bounds.size * scaleFactor, contentMode: .scaleAspectFit)
            .cropped(to: CGRect(origin: .zero, size: bounds.size * scaleFactor))
        
        
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
    
    func makePlaceholderAsset(
        scaleFactor: CGFloat,
        layerIndex i: Int,
        progressObserver: ProgressObserver? = nil
    ) async -> CombinerAsset? {
        
        Log.d("Begin to make placeholder asset")
        
        guard self.type == .placeholder else {
            return nil
        }
        
        let item: CanvasPlaceholderModel = CanvasItemModel.toType(model: self)
        
        let halpScale: CGFloat = 0.05
        
        if let imageModel: CanvasImagePlaceholderModel = item.imageModel {
            progressObserver?.setMessage(value: "Подготовка картинки из плейсхолдера...")
            // формирование картинки из плейсхолдера
            return await makePlaceHolderImageAsset(item: item,
                                                   imageModel: imageModel,
                                                   scaleFactor: scaleFactor,
                                                   layerIndex: i,
                                                   halpScale: halpScale)
        }
        
        if let videoItem: CanvasVideoPlaceholderModel = item.videoModel {
            progressObserver?.setMessage(value: "Подготовка видео из плейсхолдера...")
            // формирование видосика из плейсхолдера
            return await makePlaceHolderVideoAsset(item: item,
                                                   videoItem: videoItem,
                                                   scaleFactor: scaleFactor,
                                                   layerIndex: i,
                                                   halpScale: halpScale)
        }
        
        Log.d("Can't make placeholder asset")
        
        return nil
    }
}

// MARK: - Placeholders
fileprivate extension CanvasItemModel {
    // MARK: - Placeholder Image
    func makePlaceHolderImageAsset(
        item: CanvasPlaceholderModel,
        imageModel: CanvasImagePlaceholderModel,
        scaleFactor: CGFloat,
        layerIndex i: Int,
        halpScale: CGFloat
    ) async -> CombinerAsset? {
        
        var ciImage: CIImage
        
        let canvasImage = imageModel.image
        
        let originalFilteredImage = await imageModel.getFilteredOriginal()
        
        let processedImage = originalFilteredImage ?? canvasImage
        
        guard let processedCIImage = processedImage.rotatedCIImage else {
            Log.e("Can't get ciImage")
            return nil
        }
        
        ciImage = processedCIImage
        
        // Размер самого контейнера для хранения плейсхолдера картинки
        let containerSize = item.bounds.size * scaleFactor
        
        // Реальный размер картинки, который храниться в плейсхолдере
        // Начало: Центр плейсхолдера = сентр картинки
        let imageSize = imageModel.imageSize * scaleFactor
        
        // Расчитываем размер картинки, которая вписывается в контейнер
        let size = imageSize.aspectFill(minimumSize: containerSize)
        
        let trasform = Transform(zIndex: Double(i + 1),
                                 offset: imageModel.offset * scaleFactor,
                                 scale: imageModel.scale + halpScale,
                                 degrees: imageModel.rotation.degrees,
                                 blendingMode: imageModel.blendingMode)
        
        // Реальная картинка в контейнере(плейсхолдер)
        ciImage = ciImage.resized(to: size, withContentMode: .scaleAspectFill)
        //.frame(size, contentMode: .scaleAspectFill)
        
        // Контейнер для хранения плейсхолдера
        let container = CIImage(color: .clear)
            .frame(containerSize, contentMode: .scaleAspectFill)
        
        // Вписываем с трансофрмами плейсхолдер в контейнер
        ciImage = ciImage
            .composited(with: container, canvasSize: containerSize, transform: trasform)
            .cropped(to: .init(origin: .zero, size: containerSize))
        
        // ресайзим маску под нужный размер
        // пытаемся применить маску на всем контейнере (контейнер теперь просто картинка)
        if let resizeMask = imageModel.maskImageFromTemplate?.resized(to: containerSize),
           let maskCG = resizeMask.cgImage {
            ciImage = ciImage.createMask(maskCG: maskCG, for: containerSize)
        }
        
        
        Log.d("End to make placeholder asset")
        
        return CombinerAsset(
            body: .init(ciImage: ciImage),
            transform: Transform(
                zIndex: Double(i),
                offset: item.offset * scaleFactor,
                scale: 1,
                degrees: .zero,
                blendingMode: item.blendingMode
            )
        )
    }
    
    // MARK: - Placeholder video
    func makePlaceHolderVideoAsset(
        item: CanvasPlaceholderModel,
        videoItem: CanvasVideoPlaceholderModel,
        scaleFactor: CGFloat,
        layerIndex i: Int,
        halpScale: CGFloat
    ) async -> CombinerAsset? {
        
        let canvasURL = videoItem.videoURL
        let originalURL = await videoItem.getOriginal()
        var processedUrl = originalURL ?? canvasURL
        
        let asset = AVAsset(url: processedUrl)
        
        guard let originalAssetSize = await asset.getSize() else {
            Log.e("Can't detect original asset size")
            return nil
        }
        
        let containerSize = (item.bounds.size * scaleFactor).rounded(.up)
        let videoSize = (originalAssetSize * scaleFactor).rounded(.up)
        
        // Вписываем видео
        let size = videoSize.aspectFill(minimumSize: containerSize)
        
        // Применяем трансформацию элемент
        let trasform = Transform(zIndex: Double(i + 1),
                                 offset: videoItem.offset * scaleFactor,
                                 scale: videoItem.scale + halpScale,
                                 degrees: videoItem.rotation.degrees,
                                 blendingMode: videoItem.blendingMode)
        
        // Ресайзим маску под нужный размер
        // пытаемся применить маску на всем контейнере (контейнер теперь просто картинка)
        var maskCGImage: CGImage?
        
        if let resizeMask = videoItem.maskImageFromTemplate?.resized(to: containerSize.rounded(.up)),
           let maskCG = resizeMask.cgImage {
            maskCGImage = maskCG
        }
        
        guard let filteredURL = try? await FilteringProcessor.shared.processAndExport(
            asset: asset,
            containerSize: containerSize,
            videoSize: size,
            filterChain: videoItem.filterChain,
            exportQuality: .HEVCHighestWithAlpha,
            trasform: trasform,
            mask: maskCGImage
        ) else {
            return nil
        }
        
        processedUrl = filteredURL
        
        Log.d("End to make placeholder asset")
        
        return CombinerAsset(
            body: .init(asset: AVAsset(url: processedUrl),
                        preferredVolume: videoItem.volume,
                        cycleMode: .loopToLongestVideo),
            
            transform: Transform(
                zIndex: Double(i),
                offset: item.offset * scaleFactor,
                scale: 1,
                degrees: .zero,
                blendingMode: item.blendingMode
            )
        )
    }
}
