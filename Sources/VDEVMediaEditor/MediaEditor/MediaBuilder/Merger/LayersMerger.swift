//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 29.04.2023.
//

import Foundation
import Combine
import UIKit

extension LayersMerger {
    enum State {
        case idle
        case inProgress(String)
        case successImage(CanvasImageModel)
        case successVideo(CanvasVideoModel)
        case error(Error)
    }
}

// Мержит все - кроме видосиков и шаблонов

final class LayersMerger: ObservableObject {
    @Injected private var strings: VDEVMediaEditorStrings
    @Injected private var resolution: ResolutionService
    
    @Published var state: State = .idle
    
    private lazy var builder: MediaBuilder = .init()
    
    func merge(layers: [CanvasItemModel], on editorSize: CGSize) {
        makeMediaItem(layers: layers,
                      size: editorSize,
                      resolution: resolution.resolution.value)
    }
}

private extension LayersMerger {
    
    func makeMediaItem(layers: [CanvasItemModel],
                       size: CGSize,
                       resolution: MediaResolution) {

        let scale = CanvasNativeSizeMaker.makeScale(from: resolution, width: size.width)
        let canvasNativeSize: CGSize = CanvasNativeSizeMaker.makeSize(from: scale, size: size)
        
        
        let assetBuilder = CombinerAssetBuilder(layers: layers,
                                                canvasSize: size,
                                                scaleFactor: scale,
                                                bgColor: .clear,
                                                canvasNativeSize: canvasNativeSize,
                                                progressObserver: nil)
        
        
        state = .inProgress("")
        
        Task(priority: .high) { [weak self] in
            guard let self = self else { return }
            
            let combiner = AssetCombiner()
            
            let combinerAsset = await assetBuilder.execute()
            
            do  {
                let result = try await combiner.combineForMerge(combinerAsset,
                                                                canvasSize: size,
                                                                scaleFactor: scale,
                                                                canvasNativeSize: canvasNativeSize)
                
                let model = await self.proccess(result)
                await self.set(model)
            } catch {
                await self.set(error)
            }
        }
    }
    
    private func proccess(_ model: CombinerOutput) async -> State {
        if model.url.absoluteString.lowercased().hasSuffix("mov") {
            let item = CanvasVideoModel(videoURL: model.url, thumbnail: nil, asset: nil)
            return .successVideo(item)
        } else {
            guard let image = await AssetExtractionUtil.image(fromURL: model.url) else {
                return .idle
            }
            
            guard let image = image.cropAlpha() else {
                return .idle
            }
            let item = CanvasImageModel(image: image, asset: nil)
            return .successImage(item)
        }
    }
    
    
    @MainActor
    func set(_ state: State) async { self.state = state }
    
    @MainActor
    func set(_ error: Error) async {
        Log.e(error)
        state = .error(error)
    }
    
    func getSize(layers: [CanvasItemModel]) -> CGSize {
        var resultMinX: CGFloat = .nan
        var resultMaxX: CGFloat = .nan
        var resultMinY: CGFloat = .nan
        var resultMaxY: CGFloat = .nan
        
        for item in layers {
            let minX = item.offset.width - item.frameFetchedSize.width / 2
            
            if resultMinX.isNaN || resultMinX >= minX {
                resultMinX = minX
            }
            
            let maxX = item.offset.width + item.frameFetchedSize.width / 2
            
            if resultMaxX.isNaN || resultMaxX <= maxX {
                resultMaxX = maxX
            }
            
            let minY = item.offset.height - item.frameFetchedSize.width / 2
            
            if resultMinY.isNaN || resultMinY >= minY {
                resultMinY = minY
            }
            
            let maxY = item.offset.height + item.frameFetchedSize.width / 2
            
            if resultMaxY.isNaN || resultMaxY <= maxY {
                resultMaxY = maxY
            }
        }
        
        return .init(width: resultMaxX - resultMinX, height: resultMaxY - resultMinY)
    }
}
