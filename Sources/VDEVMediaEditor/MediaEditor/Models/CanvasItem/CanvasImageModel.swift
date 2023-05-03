//
//  CanvasImageModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 11.02.2023.
//

import SwiftUI
import Combine
import Photos

// MARK: - Image
final class CanvasImageModel: CanvasItemModel {
    private(set) var asset: CanvasItemAsset?
    private(set) var originalImage: UIImage
    
    @Published private(set) var image: UIImage
    @Published private(set) var inProgress: Bool = false
    
    private let aplayer: CanvasApplayer = .init()
    private var storage = Set<AnyCancellable>()

    init(image: UIImage,
         asset: CanvasItemAsset?,
         originalImage: UIImage? = nil,
         bounds: CGRect = .zero,
         offset: CGSize = .zero,
         adjustmentSettings: AdjustmentSettings? = nil,
         colorFilter: EditorFilter? = nil,
         textures: EditorFilter? = nil,
         masks: EditorFilter? = nil,
         blendingMode: BlendingMode = .normal) {
        
        self.originalImage = originalImage ?? image
        self.image = image
        self.asset = asset
        
        super.init(
            offset: offset,
            bounds: bounds,
            type: .image,
            adjustmentSettings: adjustmentSettings,
            colorFilter: colorFilter,
            textures: textures,
            masks: masks,
            blendingMode: blendingMode)
    }
    
    deinit {
        storage.cancelAll()
        Log.d("❌ Deinit: CanvasImageModel")
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
        .receive(on: DispatchQueue.main)
        .sink { [weak self] output in
            guard let self = self else { return }
            switch output.value {
            case .image(let value):
                self.image = value
            case .empty:
                self.image = self.originalImage
            case .video, .cancel:
                break
            }
            self.inProgress = false
        }
        .store(in: &storage)
    }
    
    override func copy() -> CanvasImageModel {
        let new = CanvasImageModel(image: image,
                                   asset: asset,
                                   originalImage: originalImage,
                                   adjustmentSettings: adjustmentSettings,
                                   colorFilter: colorFilter,
                                   textures: textures,
                                   masks: masks)
        
        new.update(offset: offset, scale: scale, rotation: rotation)
        
        return new
    }
}

extension CanvasImageModel {
    func getFilteredOriginal() async -> UIImage? {
       await getFilteredOriginal(asset: asset)
    }
}
