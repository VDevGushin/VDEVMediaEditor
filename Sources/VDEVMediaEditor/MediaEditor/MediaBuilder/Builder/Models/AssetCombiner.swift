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

class AssetCombiner {
    // MARK: - public
    func combine(_ input: [CombinerAsset],
                 canvasSize: CGSize,
                 scaleFactor: CGFloat,
                 progressObserver: ProgressObserver? = nil) async throws -> CombinerOutput {
        
        let canvasNativeSize = canvasSize * scaleFactor
        
        // Создание видео
        if input.contains(where: { $0.body.videoBody != nil }) {
            let videoMixer = VideoMixer(renderSize: canvasNativeSize, progressObserver: progressObserver)
            return try await videoMixer.composeVideo(data: input)
            
            // Создание картиртинки
        } else {
            let mixer = ImageMixer(renderSize: canvasNativeSize, progressObserver: progressObserver)
            let resultPack = try mixer.combineAndStore(assets: input, alsoSaveToPhotos: false)
            return CombinerOutput(cover: resultPack.cover, url: resultPack.uri)
        }
    }
    
    func combineForMerge(_ input: [CombinerAsset],
                 canvasSize: CGSize,
                 scaleFactor: CGFloat,
                 progressObserver: ProgressObserver? = nil) async throws -> CombinerOutput {
        
        let canvasNativeSize = canvasSize * scaleFactor
        
        // Создание видео
        if input.contains(where: { $0.body.videoBody != nil }) {
            let videoMixer = VideoMixer(renderSize: canvasNativeSize, progressObserver: progressObserver)
            return try await videoMixer.composeVideo(data: input)
            
            // Создание картиртинки
        } else {
            let mixer = ImageMixerPng(renderSize: canvasNativeSize, progressObserver: progressObserver)
            let resultPack = try mixer.combineAndStore(assets: input, alsoSaveToPhotos: false)
            return CombinerOutput(cover: resultPack.cover, url: resultPack.uri)
        }
    }
}
