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
    
    private var mainTask: (Task<()?, Never>)?
    
    deinit { Log.d("❌ Deinit: ResultBuilderViewModel") }
    
    func makeMediaItem(layers: [CanvasItemModel],
                       size: CGSize,
                       backgrondColor: Color,
                       resolution: MediaResolution = .fullHD) {
        
//        let progressObserver = ProgressObserver(total: layers.getTotalCount(),
//                                                factor: 0.5) { [weak self] in
//            self?.state = .inProgress($0)
//        }
        
        Log.d("Get scale from media resolution: \(resolution.toString)")
        
        let sizeModel = CanvasNativeSizeMaker.make(from: resolution, size: size)
        
        let assetBuilder = CombinerAssetBuilder(layers: layers,
                                                scaleFactor: sizeModel.finalScale,
                                                canvasNativeSize: sizeModel.finalCanvasSize,
                                                bgColor: backgrondColor.uiColor,
                                                progressObserver: nil)
        
        Log.d("Begin construct media")
        
        state = .inProgress("Инициализация генерации...")
        
        mainTask = Task(priority: .high) { [weak self] in
            guard let self = self else {
                return  await self?.set(MediaBuilderError.selfIsNil)
            }
            Log.d("Make combine assets from layers [count: \(layers.count)]")
            if Task.isCancelled {
                return
            }
            let combinerAsset = await assetBuilder.execute()
            if Task.isCancelled {
                return
            }
            Log.d("Render media item from combine assets [count: \(combinerAsset.count)]")
            do  {
                var result = try await self.combiner.combine(combinerAsset,
                                                             scaleFactor: sizeModel.finalScale,
                                                             canvasNativeSize: sizeModel.finalCanvasSize,
                                                             progressObserver: nil)
                if Task.isCancelled {
                    return
                }
                result.featuresUsageData = .init(from: layers)
                if Task.isCancelled {
                    return
                }
                await self.set(result)
            } catch {
                if Task.isCancelled {
                    return
                }
                await self.set(error)
            }
        }
    }
    
    @MainActor
    func set(_ combinerOutput: CombinerOutput) async {
        defer {
            mainTask?.cancel()
            mainTask = nil
        }
        Log.i("Result URL \(combinerOutput.url)")
        state = .success(combinerOutput)
    }
    
    @MainActor
    func set(_ error: Error) async {
        defer {
            mainTask?.cancel()
            mainTask = nil
        }
        Log.e(error)
        state = .error(error)
    }
    
    func cancel() {
        guard state.isInProgress else { return }
        Log.d("Cancle build")
        mainTask?.cancel()
        mainTask = nil
        state = .idle
    }
}

// MARK: - Helper
struct CanvasNativeSizeMaker {
    struct SizeMakerResult {
        let finalScale: CGFloat
        let finalCanvasSize: CGSize
    }
    
    static func make(from resolution: MediaResolution, size: CGSize) -> SizeMakerResult {
        let scale = resolution.getScale(for: size.width)
        let size = makeSize(from: scale, size: size)
        return .init(finalScale: scale, finalCanvasSize: size)
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
        
        var isInProgress: Bool {
            switch self {
            case .inProgress: return true
            default: return false
            }
        }
    }
    
    enum MediaBuilderError: Error {
        case selfIsNil
    }
}

