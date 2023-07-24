//
//  CanvasApplayerModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 11.02.2023.
//

import UIKit
import Combine
import AVFoundation

struct CanvasApplayerOutput {
    let value: ValutType

    init(value: ValutType) { self.value = value }

    static func videoAdjustmentOutput(asset: AVVideoComposition) -> CanvasApplayerOutput {
        .init(value: .video(asset))
    }

    static func imageAdjustmentOutput(image: UIImage) -> CanvasApplayerOutput {
        .init(value: .image(image))
    }

    static func empty() -> CanvasApplayerOutput {
        .init(value: .empty)
    }

    static var cancel: CanvasApplayerOutput {
        .init(value: .cancel)
    }

    enum ValutType {
        case image(UIImage)
        case video(AVVideoComposition)
        case empty
        case cancel
    }
}

struct CanvasApplayer {
    func applyFilters(for url: URL,
                      baseFilters: [EditorFilter],
                      adjustmentSettings: AdjustmentSettings?,
                      colorFilter: EditorFilter?,
                      textures: EditorFilter?,
                      masks: EditorFilter?) -> AnyPublisher<CanvasApplayerOutput, Never> {

        Future<CanvasApplayerOutput, Never> { seal in
            DispatchQueue.global(qos: .userInitiated).async {
                let baseFiltersFDs = baseFilters.flatMap { $0.steps.makeFilterDescriptors() }
                let adjustSettingsFDs = adjustmentSettings?.makeFilterDescriptors() ?? []
                let colorFD = colorFilter?.steps.makeFilterDescriptors() ?? []
                let texturesFD = textures?.steps.makeFilterDescriptors() ?? []
                let masksFD = masks?.steps.makeFilterDescriptors() ?? []

                let filterChain = baseFiltersFDs + adjustSettingsFDs + colorFD + texturesFD + masksFD

                guard !filterChain.isEmpty else {
                    seal(.success(.empty()))
                    return
                }


                let avAsset = AVAsset(url: url)

                let videoComposition = FilteringProcessor().makeAVVideoComposition(for: avAsset, filterChain: filterChain)

                seal(.success(.videoAdjustmentOutput(asset: videoComposition)))
            }
        }.eraseToAnyPublisher()
    }

    func applyFilters(for image: UIImage,
                      baseFilters: [EditorFilter],
                      adjustmentSettings: AdjustmentSettings?,
                      colorFilter: EditorFilter?,
                      textures: EditorFilter?,
                      masks: EditorFilter?) -> AnyPublisher<CanvasApplayerOutput, Never> {

        Future<CanvasApplayerOutput, Never> { seal in
            DispatchQueue.global(qos: .userInitiated).async {

                let baseFiltersFDs = baseFilters.flatMap { $0.steps.makeFilterDescriptors() }
                let adjustSettingsFDs = adjustmentSettings?.makeFilterDescriptors() ?? []
                let colorFD = colorFilter?.steps.makeFilterDescriptors() ?? []
                let texturesFD = textures?.steps.makeFilterDescriptors() ?? []
                let masksFD = masks?.steps.makeFilterDescriptors() ?? []

                let filterChain = baseFiltersFDs + adjustSettingsFDs + colorFD + texturesFD + masksFD

                guard !filterChain.isEmpty else {
                    seal(.success(.empty()))
                    return
                }

                guard let updatedImage = FilteringProcessor().process(image: image,
                                                                           filteringChain: filterChain),
                      let cgImage = FilteringProcessor().createCGImage(from: updatedImage) else {
                    seal(.success(.empty()))
                    return
                }

                let image = UIImage(cgImage: cgImage)

                seal(.success(.imageAdjustmentOutput(image: image)))
            }
        }.eraseToAnyPublisher()
    }

}

extension CanvasApplayer {
    func applyFilters(for image: UIImage, filterChain: [FilterDescriptor]) async -> CanvasApplayerOutput {

        guard !filterChain.isEmpty else {
            return .imageAdjustmentOutput(image: image)
        }

        if Task.isCancelled { return .cancel }

        var result = CanvasApplayerOutput.empty()

        if  let updatedImage = FilteringProcessor().process(image: image,
                                                                 filteringChain: filterChain),
            let cgImage = FilteringProcessor().createCGImage(from: updatedImage) {

            result = .imageAdjustmentOutput(image: UIImage(cgImage: cgImage))
        }
        return result
    }


    func applyFilters(for url: URL, filters: [EditorFilter]) async -> CanvasApplayerOutput {
        let filterChain = filters.flatMap { $0.steps.makeFilterDescriptors() }

        guard !filterChain.isEmpty else { return .empty() }

        if Task.isCancelled { return .cancel }

        let avAsset = AVAsset(url: url)

        var result = CanvasApplayerOutput.empty()

        let videoComposition = FilteringProcessor().makeAVVideoComposition(for: avAsset, filterChain: filterChain)

        result = .videoAdjustmentOutput(asset: videoComposition)
        
        return result
    }

    func applyFilters(for image: UIImage, filters: [EditorFilter]) async -> CanvasApplayerOutput {
        let filterChain = filters.flatMap { $0.steps.makeFilterDescriptors() }

        guard !filterChain.isEmpty else {
            return .imageAdjustmentOutput(image: image)
        }

        if Task.isCancelled { return .cancel }

        var result = CanvasApplayerOutput.empty()
        
        if  let updatedImage = FilteringProcessor().process(image: image,
                                                                 filteringChain: filterChain),
            let cgImage = FilteringProcessor().createCGImage(from: updatedImage) {

            result = .imageAdjustmentOutput(image: UIImage(cgImage: cgImage))
        }
        return result
    }
}
