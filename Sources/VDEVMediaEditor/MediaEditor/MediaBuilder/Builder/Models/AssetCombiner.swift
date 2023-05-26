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
    // MARK: - public
    func combine(_ input: [CombinerAsset],
                 scaleFactor: CGFloat,
                 canvasNativeSize: CGSize,
                 progressObserver: ProgressObserver? = nil) async throws -> CombinerOutput {
        
        // Создание видео
        if input.contains(where: { $0.body.videoBody != nil }) {
            let videoMixer = VideoMixer(renderSize: canvasNativeSize, progressObserver: progressObserver)
            return try await videoMixer.composeVideo(data: input, withAudio: settings.canTurnOnSoundInVideos)
            
            // Создание картиртинки
        } else {
            let mixer = ImageMixer(renderSize: canvasNativeSize, progressObserver: progressObserver)
            let resultPack = try mixer.combineAndStore(assets: input, alsoSaveToPhotos: false)
            return CombinerOutput(cover: resultPack.cover, url: resultPack.uri, aspect: canvasNativeSize.width / canvasNativeSize.height)
        }
    }
    
    func combineForMerge(_ input: [CombinerAsset],
                         scaleFactor: CGFloat,
                         canvasNativeSize: CGSize,
                         progressObserver: ProgressObserver? = nil) async throws -> CombinerOutput {
        
        // Создание видео
        if input.contains(where: { $0.body.videoBody != nil }) {
            let videoMixer = VideoMixer(renderSize: canvasNativeSize, progressObserver: progressObserver)
            return try await videoMixer.composeVideo(data: input, withAudio: false)
            
        // Создание картиртинки
        } else {
            let mixer = ImageMixerPng(renderSize: canvasNativeSize, progressObserver: progressObserver)
            let resultPack = try mixer.combineAndStore(assets: input, alsoSaveToPhotos: false)
            return CombinerOutput(cover: resultPack.cover, url: resultPack.uri, aspect: canvasNativeSize.width / canvasNativeSize.height)
        }
    }
}
