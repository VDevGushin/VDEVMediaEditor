//
//  VideoMediaBuilderViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import SwiftUI

extension MediaBuilder {
    enum State {
        case idle
        case inProgress(String)
        case success(CombinerOutput)
        case error(Error)
    }
    
    enum MediaBuilderError: Error {
        case selfIsNil
    }
}

final class MediaBuilder: NSObject, ObservableObject {
    @Published private(set) var state: State = .idle
    
    private let combiner = AssetCombiner()
    
    deinit { Log.d("❌ Deinit: ResultBuilderViewModel") }
    
    func makeMediaItem(layers: [CanvasItemModel],
                       size: CGSize,
                       backgrondColor: Color,
                       resolution: MediaResolution = .fullHD) {
        
        let progressObserver = ProgressObserver(total: layers.getTotalCount(),
                                                factor: 0.5) { [weak self] in
            self?.state = .inProgress($0)
        }
        
        Log.d("Get scale from media resolution: \(resolution.toString)")
        let scale = resolution.getScale(for: size.width)
        
        let assetBuilder = CombinerAssetBuilder(layers: layers,
                                                canvasSize: size,
                                                scaleFactor: scale,
                                                bgColor: backgrondColor.uiColor,
                                                progressObserver: progressObserver)
        
        Log.d("Begin construct media")
        
        state = .inProgress("Инициализация генерации...")
        
        Task(priority: .high) { [weak self] in
            guard let self = self else {
                return  await self?.set(MediaBuilderError.selfIsNil)
            }
            
            Log.d("Make combine assets from layers [count: \(layers.count)]")
            
            let combinerAsset = await assetBuilder.execute()
            
            Log.d("Render media item from combine assets [count: \(combinerAsset.count)]")
            
            do  {
                var result = try await self.combiner.combine(combinerAsset,
                                                        canvasSize: size,
                                                        scaleFactor: scale,
                                                        progressObserver: progressObserver)
                
                result.featuresUsageData = await .init(usedMasks: layers.hasMasks,
                                                       usedTextures: layers.hasTextures,
                                                       usedFilters: layers.hasColorFilters,
                                                       usedTemplates: layers.hasTemplates,
                                                       usedVideo: layers.hasVideos,
                                                       usedVideoSound: false,
                                                       usedMusic: false,
                                                       usedStickers: layers.hasStickers)
                
                await self.set(result)
            } catch {
                await self.set(error)
            }
        }
    }
    
    @MainActor
    func set(_ combinerOutput: CombinerOutput) async {
        Log.i("Result URL \(combinerOutput.url)")
        state = .success(combinerOutput)
    }
    
    @MainActor
    func set(_ error: Error) async {
        Log.e(error)
        state = .error(error)
    }
}

// MARK: - Helpers
fileprivate extension Array where Element == CanvasItemModel {
    @MainActor var hasMasks: Bool {
        if contains(where: { $0.masks != nil }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasMasks {
                    result = true
                    break
                }
            }
            
            if let canvasPlaceholderModel = item as? CanvasPlaceholderModel {
                if let videoModel = canvasPlaceholderModel.videoModel  {
                    if videoModel.masks != nil {
                        result = true
                        break
                    }
                }
                
                if let imageModel = canvasPlaceholderModel.imageModel  {
                    if imageModel.masks != nil {
                        result = true
                        break
                    }
                }
            }
        }
        
        return result
    }
    
    @MainActor var hasTextures: Bool {
        if contains(where: { $0.textures != nil }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasTextures {
                    result = true
                    break
                }
            }
            
            if let canvasPlaceholderModel = item as? CanvasPlaceholderModel {
                if let videoModel = canvasPlaceholderModel.videoModel  {
                    if videoModel.textures != nil {
                        result = true
                        break
                    }
                }
                
                if let imageModel = canvasPlaceholderModel.imageModel  {
                    if imageModel.textures != nil {
                        result = true
                        break
                    }
                }
            }
        }
        
        return result
    }
    
    @MainActor var hasColorFilters: Bool {
        if contains(where: { $0.colorFilter != nil }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasColorFilters {
                    result = true
                    break
                }
            }
            
            if let canvasPlaceholderModel = item as? CanvasPlaceholderModel {
                if let videoModel = canvasPlaceholderModel.videoModel  {
                    if videoModel.colorFilter != nil {
                        result = true
                        break
                    }
                }
                
                if let imageModel = canvasPlaceholderModel.imageModel  {
                    if imageModel.colorFilter != nil {
                        result = true
                        break
                    }
                }
            }
        }
        
        return result
    }
    
    @MainActor var hasVideos: Bool {
        if contains(where: { $0.type == .video }) {
            return true
        }

        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasVideos {
                    result = true
                    break
                }
            }
            
            if let canvasPlaceholderModel = item as? CanvasPlaceholderModel {
                if canvasPlaceholderModel.videoModel != nil {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
    
    @MainActor var hasTemplates: Bool {
        if contains(where: { $0.type == .template }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasTemplates {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
    
    @MainActor var hasStickers: Bool {
        if contains(where: { $0.type == .sticker }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasStickers {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
}
