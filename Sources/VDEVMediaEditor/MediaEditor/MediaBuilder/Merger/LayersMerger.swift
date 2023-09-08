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
    @Published var state: State = .idle
    
    private lazy var builder: MediaBuilder = .init()
    
    func merge(layers: [CanvasItemModel], on editorSize: CGSize) {
        makeMediaItem(layers: layers,
                      size: editorSize,
                      resolution: .fullHD)
    }
}

private extension LayersMerger {
    func makeMediaItem(layers: [CanvasItemModel],
                       size: CGSize,
                       resolution: MediaResolution) {
        
        let sizeModel = CanvasNativeSizeMaker.make(from: resolution, size: size)
        
        let assetBuilder = CombinerAssetBuilder(layers: layers,
                                                scaleFactor: sizeModel.finalScale,
                                                canvasNativeSize: sizeModel.finalCanvasSize,
                                                bgColor: .clear,
                                                progressObserver: nil)
        
        
        state = .inProgress("")
        
        Task(priority: .high) { [weak self] in
            guard let self = self else { return }
            
            let combiner = AssetCombiner()
            
            let combinerAsset = await assetBuilder.execute()
            
            do  {
                let result = try await combiner.combineForMerge(combinerAsset,
                                                                scaleFactor: sizeModel.finalScale,
                                                                canvasNativeSize: sizeModel.finalCanvasSize)
                
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
//            guard let image = image.cropAlpha() else {
//                return .idle
//            }
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
}
