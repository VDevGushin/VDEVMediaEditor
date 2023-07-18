//
//  AssetCombiner.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import UIKit
import AVFoundation
import Photos
import CollectionConcurrencyKit

final class AssetCombiner {
    @Injected private var settings: VDEVMediaEditorSettings
    @Injected private var resultSettings: VDEVMediaEditorResultSettings
    @Injected private var resolution: ResolutionService
    
    // MARK: - public
    func combine(_ input: [CombinerAsset],
                 scaleFactor: CGFloat,
                 canvasNativeSize: CGSize,
                 progressObserver: ProgressObserver? = nil) async throws -> CombinerOutput {
        
        // Создание видео
        if input.contains(where: { $0.body.videoBody != nil }) {
            let result = try await VideoMixer.composeVideo(
                renderSize: canvasNativeSize,
                progressObserver: progressObserver,
                data: input,
                videoExportPreset: resolution.videoExportPreset(),
                withAudio: settings.canTurnOnSoundInVideos
            )
            return result
        } else {
            let result = try ImageMixer.combineAndStore(
                renderSize: canvasNativeSize,
                progressObserver: progressObserver,
                assets: input,
                needAutoEnhance: resultSettings.needAutoEnhance.value,
                alsoSaveToPhotos: false)
            return result
        }
    }
    
    func combineForMerge(_ input: [CombinerAsset],
                         scaleFactor: CGFloat,
                         canvasNativeSize: CGSize,
                         progressObserver: ProgressObserver? = nil) async throws -> CombinerOutput {
        
        // Создание видео
        if input.contains(where: { $0.body.videoBody != nil }) {
            let result = try await VideoMixer.composeVideo(
                renderSize: canvasNativeSize,
                progressObserver: progressObserver,
                data: input,
                videoExportPreset: resolution.videoExportPreset(),
                withAudio: false
            )
            return result
        // Создание картиртинки
        } else {
            let mixer = ImageMixerPng(renderSize: canvasNativeSize, progressObserver: progressObserver)
            let resultPack = try mixer.combineAndStore(assets: input, alsoSaveToPhotos: false)
            return CombinerOutput(cover: resultPack.cover, url: resultPack.uri, aspect: canvasNativeSize.width / canvasNativeSize.height)
        }
    }
}
