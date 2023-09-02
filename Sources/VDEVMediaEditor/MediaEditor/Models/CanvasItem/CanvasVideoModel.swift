//
//  CanvasVideoModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 11.02.2023.
//

import SwiftUI
import AVKit
import Combine
import Photos

// MARK: - Video
final class CanvasVideoModel: CanvasItemModel {
    private(set) var asset: CanvasItemAsset?
    private(set) var volume: Float
    
    private var originalVideoURL: URL
    @Published private(set) var avVideoComposition: AVVideoComposition?
    @Published var inProgress: Bool = false
    private(set) var thumbnail: UIImage?
    private(set) var videoURL: URL

    private let aplayer = CanvasApplayer()
    private var storage = Cancellables()

    init(videoURL: URL,
         thumbnail: UIImage?,
         originalVideoURL: URL? = nil,
         asset: CanvasItemAsset?,
         volume: Float = 0.0,
         avVideoComposition: AVVideoComposition? = nil,
         adjustmentSettings: AdjustmentSettings? = nil,
         colorFilter: EditorFilter? = nil,
         textures: EditorFilter? = nil,
         masks: EditorFilter? = nil) {

        self.asset = asset
        self.thumbnail = thumbnail
        self.videoURL = videoURL
        self.originalVideoURL = originalVideoURL ?? videoURL
        self.avVideoComposition = avVideoComposition
        self.volume = volume

        super.init(type: .video,
                   adjustmentSettings: adjustmentSettings,
                   colorFilter: colorFilter,
                   textures: textures,
                   masks: masks)
    }

    deinit {
        storage.cancelAll()
        thumbnail = nil
        avVideoComposition = nil
        Log.d("❌ Deinit: CanvasVideoModel")
    }
    
    func update(volume: Float) {
        self.volume = volume
    }

    override func apply(colorFilter: EditorFilter?) {
        self.colorFilter = colorFilter
        setAllFilters()
    }

    override func apply(masks: EditorFilter?) {
        self.masks = masks
        setAllFilters()
    }

    override func apply(adjustmentSettings: AdjustmentSettings?) {
        self.adjustmentSettings = adjustmentSettings
        setAllFilters(fromAdjustment: true)
    }

    override func apply(textures: EditorFilter?) {
        self.textures = textures
        setAllFilters()
    }
    
    private func setAllFilters(fromAdjustment: Bool = false) {
        inProgress = fromAdjustment ? false : true

        storage.limitCancel()

        aplayer.applyFilters(for: originalVideoURL,
                             baseFilters: [],
                             adjustmentSettings: adjustmentSettings,
                             colorFilter: colorFilter,
                             textures: textures,
                             masks: masks)
        .sink(on: .main, object: self) { wSelf, output in
            switch output.value {
            case .video(let composition): wSelf.avVideoComposition = composition
            case .empty: wSelf.avVideoComposition = nil
            case .image, .cancel: break
            }
            wSelf.inProgress = false
        }
        .store(in: &storage)
    }

    override func copy() -> CanvasVideoModel {
        let new = CanvasVideoModel(videoURL: videoURL,
                                   thumbnail: thumbnail ,
                                   originalVideoURL: originalVideoURL,
                                   asset: asset,
                                   avVideoComposition: avVideoComposition,
                                   adjustmentSettings: adjustmentSettings,
                                   colorFilter: colorFilter,
                                   textures: textures,
                                   masks: masks)
        new.update(offset: offset, scale: scale, rotation: rotation)
        new.update(volume: volume)
        return new
    }
}

extension CanvasVideoModel {
    func getOriginal() async -> URL? {
        await self.getOriginalURLFrom(asset: asset)
    }
}
