////
////  ImageAssetCombiner.swift
////  MediaEditor
////
////  Created by Vladislav Gushin on 24.03.2023.
////
//
//import UIKit
//
//final class ImageAssetCombiner {
//    private let layers: [CanvasItemModel]
//    private let canvasSize: CGSize
//    private let scaleFactor: CGFloat
//    private let canvasNativeSize: CGSize
//    private let bgColor: UIColor
//    
//    init(layers: [CanvasItemModel], canvasSize: CGSize, scaleFactor: CGFloat, backgroundColor: UIColor) {
//        self.layers = layers
//        self.canvasSize = canvasSize
//        self.scaleFactor = scaleFactor
//        self.bgColor = backgroundColor
//        self.canvasNativeSize = canvasSize * scaleFactor
//    }
//    
//    func execute() async throws -> CombinerOutput {
//        let canvasNativeSize = canvasSize * scaleFactor
//        
//        var bufferImage: CIImage = CIImage(color: .clear)
//        
//        let bgImage = CIImage(color: CIColor(color: bgColor))
//            .cropped(to: CGRect(origin: .zero, size: canvasNativeSize))
//        
//        let bg = CombinerAsset(
//            body: .init(ciImage: bgImage),
//            transform: Transform(zIndex: 0.0,
//                                 offset: .zero,
//                                 scale: 1,
//                                 degrees: 0,
//                                 blendingMode: .sourceOver)
//        )
//        
//        bufferImage = combine(asset: bg, bufferImage: bufferImage)
//        
//        var zIndex = 1
//        
//        for i in 0..<layers.count {
//            let element = layers[i]
//            zIndex += i
//            
//            if let templateAsset = await makeTemplateAsset(element: element,
//                              scaleFactor: scaleFactor,
//                              layerIndex: zIndex) {
//                bufferImage = combine(asset: templateAsset, bufferImage: bufferImage)
//            }
//            
//            if let imageAsset = await element.makeImageAsset(
//                canvasNativeSize: canvasNativeSize,
//                scaleFactor: scaleFactor,
//                layerIndex: zIndex
//            ) {
//                bufferImage = combine(asset: imageAsset, bufferImage: bufferImage)
//            }
//        
//            
//            if let labelsAsset = await element.makeLabelAsset(
//                canvasNativeSize: canvasNativeSize,
//                scaleFactor: scaleFactor,
//                layerIndex: zIndex
//            ) {
//                bufferImage = combine(asset: labelsAsset, bufferImage: bufferImage)
//            }
//        }
//        
//        let resultURL = try FilteringProcessor.shared.generateAndSave(ciImage: bufferImage, withJPGQuality: 1)
//        
//        return CombinerOutput(cover: resultURL, url: resultURL)
//    }
//}
//
//// MARK: - Make templates with images/videos/placeholders[image,video]
//private extension ImageAssetCombiner {
//    func makeTemplateAsset(element: CanvasItemModel,
//                           scaleFactor: CGFloat,
//                           layerIndex: Int) async -> CombinerAsset? {
//        
//        guard element.type == .template else { return nil }
//        
//        let item: CanvasTemplateModel = CanvasItemModel.toType(model: element)
//        
//        let layers = item.layerItems
//        var zIndex = layerIndex
//        
//        var bufferImage: CIImage = CIImage(color: .clear)
//        
//        for i in 0..<layers.count {
//            let element = layers[i]
//            zIndex += i
//            
//            if let placeholderAsset = await element.makePlaceholderAsset(
//                scaleFactor: scaleFactor,
//                layerIndex: zIndex
//            ) {
//                bufferImage = combine(asset: placeholderAsset, bufferImage: bufferImage)
//            }
//            
//            if let imageAsset = await element.makeTemplateImageAsset(
//                scaleFactor: scaleFactor,
//                layerIndex: zIndex
//            ) {
//                bufferImage = combine(asset: imageAsset, bufferImage: bufferImage)
//            }
//            
//            if let labelsAsset = await element.makeTemplateLabelAsset(
//                scaleFactor: scaleFactor,
//                layerIndex: zIndex
//            ) {
//                bufferImage = combine(asset: labelsAsset, bufferImage: bufferImage)
//            }
//        }
//        
//        return CombinerAsset(
//            body: .init(ciImage: bufferImage),
//            transform: Transform(zIndex: Double(layerIndex),
//                                 offset: .zero,
//                                 scale: 1,
//                                 degrees: 0,
//                                 blendingMode: .sourceOver)
//        )
//    }
//}
//
//// MARK: Combine CIImage
//private extension ImageAssetCombiner {
//    func combine(asset: CombinerAsset, bufferImage: CIImage) -> CIImage {
//        var resultImage: CIImage = bufferImage
//        
//        if let newCIImage = asset.body.imageBody?.ciImage {
//            autoreleasepool {
//                resultImage = newCIImage
//                    .composited(with: resultImage,
//                                canvasSize: canvasNativeSize,
//                                transform: asset.transform)
//            }
//        }
//        
//        return resultImage.cropped(to: CGRect(origin: .zero, size: canvasNativeSize))
//    }
//}
