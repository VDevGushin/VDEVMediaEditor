//
//  CombinerAssetBuilder.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.03.2023.
//

import UIKit
import Foundation

final class CombinerAssetBuilder {
    private let layers: [CanvasItemModel]
    private let scaleFactor: CGFloat
    private let bgColor: UIColor
    private let progressObserver: ProgressObserver?
    private let canvasNativeSize: CGSize

    init(layers: [CanvasItemModel],
         scaleFactor: CGFloat,
         bgColor: UIColor,
         canvasNativeSize: CGSize,
         progressObserver: ProgressObserver?) {
        self.layers = layers
        self.scaleFactor = scaleFactor
        self.bgColor = bgColor
        self.progressObserver = progressObserver
        self.canvasNativeSize = canvasNativeSize
    }
    
    func execute() async -> [CombinerAsset]  {
        let bgImage = CIImage(color: CIColor(color: bgColor))
            .cropped(to: CGRect(origin: .zero, size: canvasNativeSize))
        
        let bg = CombinerAsset(
            body: .init(ciImage: bgImage),
            transform: Transform(zIndex: 0.1,
                                 offset: .zero,
                                 scale: 1,
                                 degrees: 0,
                                 blendingMode: .sourceOver)
        )
        
        progressObserver?.addProgress()
        
        var templates = [CombinerAsset]()
        var images = [CombinerAsset]()
        var videos = [CombinerAsset]()
        var labels = [CombinerAsset]()
        var audios = [CombinerAsset]()
        
        var zIndex = 1
        for i in 0..<layers.count {
            let element = layers[i]
            zIndex += i
            
            if let templatesAsset = await element.makeTemplateAsset(
                scaleFactor: scaleFactor,
                layerIndex: zIndex,
                progressObserver: progressObserver) {
                
                templates.append(contentsOf: templatesAsset)
                zIndex += templates.count
                progressObserver?.addProgress()
            }
            
            if let imageAsset = await element.makeImageAsset(
                canvasNativeSize: canvasNativeSize,
                scaleFactor: scaleFactor,
                layerIndex: zIndex,
                progressObserver: progressObserver
            ) {
                images.append(imageAsset)
                progressObserver?.addProgress()
            }

            if let videoAsset = await element.makeVideoAsset(
                canvasNativeSize: canvasNativeSize,
                scaleFactor: scaleFactor,
                layerIndex: zIndex,
                progressObserver: progressObserver
            ) {
                videos.append(videoAsset)
                progressObserver?.addProgress()
            }
            
            if let audioAsset = await element.makeAudioAsset(
                canvasNativeSize: canvasNativeSize,
                scaleFactor: scaleFactor,
                layerIndex: zIndex,
                progressObserver: progressObserver
            ) {
                audios.append(audioAsset)
                progressObserver?.addProgress()
            }

            if let labelsAsset = await element.makeLabelAsset(
                canvasNativeSize: canvasNativeSize,
                scaleFactor: scaleFactor,
                layerIndex: zIndex,
                progressObserver: progressObserver
            ) {
                labels.append(labelsAsset)
                progressObserver?.addProgress()
            }
        }
        
        Log.d("bg combine asset [count: 1]")
        Log.d("Templates combine asset [count: \(templates.count)]")
        Log.d("Images combine asset [count: \(images.count)]")
        Log.d("Videos combine asset [count: \(videos.count)]")
        Log.d("Labels combine asset [count: \(labels.count)]")
        Log.d("Audio combine asset [count: \(audios.count)]")

        let res = [bg] + templates + images + videos + labels + audios
        
        Log.d("Combine assets [count: \(res.count)]")
        
        return res
    }
}
