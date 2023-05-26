//
//  VideoMediaBuilderViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import SwiftUI

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
        
        let sizeModel = CanvasNativeSizeMaker.make(from: resolution, size: size)
        
        let assetBuilder = CombinerAssetBuilder(layers: layers,
                                                scaleFactor: sizeModel.finalScale,
                                                bgColor: backgrondColor.uiColor,
                                                canvasNativeSize: sizeModel.finalCanvasSize,
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
                                                             scaleFactor: sizeModel.finalScale,
                                                             canvasNativeSize: sizeModel.finalCanvasSize,
                                                             progressObserver: progressObserver)
                
                result.featuresUsageData = .init(from: layers)
                
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

// MARK: - Helper
struct CanvasNativeSizeMaker {
    struct SizeMakerResult {
        let finalScale: CGFloat
        let finalCanvasSize: CGSize
    }
    
    static func make(from resolution: MediaResolution, size: CGSize) -> SizeMakerResult {
        let scale = makeScale(from: resolution, width: size.width)
        let size = makeSize(from: scale, size: size)
        return .init(finalScale: scale, finalCanvasSize: size)
    }
    
    private static func makeScale(from resolution: MediaResolution, width: CGFloat) -> CGFloat {
        return resolution.getScale(for: width)
    }
    
    private static func makeSize(from scale: CGFloat, size: CGSize) -> CGSize {
        let width = (size.width * scale).rounded(.down)
        let height = (size.height * scale).rounded(.down)
        return .init(width: width, height: height)
    }
}

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

