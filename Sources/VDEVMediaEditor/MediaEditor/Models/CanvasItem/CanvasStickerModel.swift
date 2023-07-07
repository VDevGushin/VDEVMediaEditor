//
//  CanvasStickerModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.02.2023.
//

import SwiftUI
import Combine

// MARK: - Sticker
final class CanvasStickerModel: CanvasItemModel {
    private(set) var originalImage: UIImage
    @Published private(set) var image: UIImage
    @Published private(set) var inProgress: Bool = false

    private let aplayer = CanvasApplayer()
    private var storage = Cancellables()

    init(image: UIImage,
         originalImage: UIImage? = nil,
         adjustmentSettings: AdjustmentSettings? = nil,
         colorFilter: EditorFilter? = nil,
         textures: EditorFilter? = nil,
         masks: EditorFilter? = nil) {
        
        self.image = image
        self.originalImage = originalImage ?? image

        super.init(type: .sticker,
                   adjustmentSettings: adjustmentSettings,
                   colorFilter: colorFilter,
                   textures: textures,
                   masks: masks)
    }

    deinit {
        storage.cancelAll()
        Log.d("❌ Deinit: CanvasStickerModel")
    }

    override func apply(masks: EditorFilter?) {
        self.masks = masks
        setAllFilters()
    }

    override func apply(textures: EditorFilter?) {
        self.textures = textures
        setAllFilters()
    }

    override func apply(colorFilter: EditorFilter?) {
        self.colorFilter = colorFilter
        setAllFilters()
    }

    override func apply(adjustmentSettings: AdjustmentSettings?) {
        self.adjustmentSettings = adjustmentSettings
        setAllFilters()
    }

    private func setAllFilters() {
        inProgress = true

        storage.limitCancel()

        aplayer.applyFilters(for: originalImage,
                             baseFilters: [],
                             adjustmentSettings: adjustmentSettings,
                             colorFilter: colorFilter,
                             textures: textures,
                             masks: masks)
        .sink(on: .main, object: self) { wSelf, output in
            switch output.value {
            case .image(let value): wSelf.image = value
            case .empty: wSelf.image = wSelf.originalImage
            case .video: break
            case .cancel: break
            }
            wSelf.inProgress = false
        }
        .store(in: &storage)
    }

    override func copy() -> CanvasStickerModel {
        let new = CanvasStickerModel(image: image,
                                     originalImage: originalImage,
                                     adjustmentSettings: adjustmentSettings,
                                     colorFilter: colorFilter,
                                     textures: textures,
                                     masks: masks)
        
        new.update(offset: offset, scale: scale, rotation: rotation)
        
        return new
    }
}

