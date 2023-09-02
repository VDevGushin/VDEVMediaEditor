//
//  CanvasItemModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 11.02.2023.
//

import SwiftUI
import UIKit
import AVKit
import Combine
import Photos

enum CanvasItemType {
    case image
    case sticker
    case video
    case audio
    case drawing
    case text
    case template
    case placeholder
    case textForTemplate
    case empty
}

extension CanvasItemModel: Hashable, Equatable {
    static func == (lhs: CanvasItemModel, rhs: CanvasItemModel) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

extension CanvasItemModel {
    static func toType<T, Input>(model: Input) -> T {
        guard let obj = model as? T else  { fatalError("Error layer item type") }
        return obj
    }
    
    static func toTypeOptional<T, Input>(model: Input) -> T? {
        guard let obj = model as? T else  { return nil }
        return obj
    }
}

extension CanvasItemModel {
    var canMerge: Bool {
        type == .drawing ||
        type == .image ||
        type == .sticker ||
        type == .text
    }
}

// MARK: - Base
class CanvasItemModel: Identifiable, ObservableObject {
    var adjustmentSettings: AdjustmentSettings?
    var colorFilter: EditorFilter?
    var neuralFilter: NeuralEditorFilter?
    var textures: EditorFilter?
    var masks: EditorFilter?

    private(set) var id: UUID
    private(set) var offset: CGSize
    private(set) var scale: CGFloat
    private(set) var rotation: Angle
    private(set) var type: CanvasItemType
    private(set) var blendingMode: BlendingMode = .normal
    private(set) var bounds: CGRect

    // фактический размер итема на канвасе(для комбайна видосов)
    // расчитывается когда на конве двигаем/крутим/скейлим
    // приходит из CanvasLayerViewModel
    // Выставляется 1 раз при попадания элемента на канвас
    private(set) var frameFetchedSize: CGSize = .zero

    var filterChain: [FilterDescriptor] {
        let adjustSettingsFDs = adjustmentSettings?.makeFilterDescriptors() ?? []
        let colorFD = colorFilter?.steps.makeFilterDescriptors() ?? []
        let texturesFD = textures?.steps.makeFilterDescriptors() ?? []
        let masksFD = masks?.steps.makeFilterDescriptors() ?? []
        
        return adjustSettingsFDs + colorFD + texturesFD + masksFD
    }
    
    var canReset: Bool {
        offset != .zero || scale != 1 || rotation != .zero
    }
    
    var isNeuralProgress: Bool {
        guard let canvasImageModel: CanvasImageModel = CanvasItemModel.toTypeOptional(model: self),
              let progress = canvasImageModel.inProgress
        else { return false }
        switch progress {
        case .neural: return true
        case .simple: return false
        }
    }

    init(id: UUID = UUID(),
         offset: CGSize = .zero,
         rotation: Angle = .zero,
         bounds: CGRect = .zero,
         scale: CGFloat = 1,
         type: CanvasItemType = .empty,
         adjustmentSettings: AdjustmentSettings? = nil,
         colorFilter: EditorFilter? = nil,
         neuralFilter: NeuralEditorFilter? = nil,
         textures: EditorFilter? = nil,
         masks: EditorFilter? = nil,
         blendingMode: BlendingMode = .normal) {

        self.id = id
        self.offset = offset
        self.scale = scale
        self.rotation = rotation
        self.type = type
        self.adjustmentSettings = adjustmentSettings
        self.colorFilter = colorFilter
        self.neuralFilter = neuralFilter
        self.masks = masks
        self.textures = textures
        self.blendingMode = blendingMode
        self.bounds = bounds
    }

    @discardableResult
    func update(offset: CGSize, scale: CGFloat, rotation: Angle) -> Self {
        self.offset = offset
        self.scale = scale
        self.rotation = rotation
        return self
    }

    @discardableResult
    func update(frameFetchedSize: CGSize) -> Self {
        self.frameFetchedSize = frameFetchedSize
        return self
    }

    func apply(masks: EditorFilter?) {
        Log.i("------> base apply")
    }

    func apply(textures: EditorFilter?) {
        Log.i("------> base apply")
    }

    func apply(adjustmentSettings: AdjustmentSettings?) {
        Log.i("------> base apply")
    }

    func apply(colorFilter: EditorFilter?) {
        Log.i("------> base apply")
    }
    
    func apply(neuralFilter: NeuralEditorFilter?) {
        Log.i("------> base apply")
    }

    func apply(filters: [EditorFilter]) {
        Log.i("------> base apply filters")
    }

    func copy() -> CanvasItemModel {
        let new = CanvasItemModel(id: UUID(),
                                  offset: offset,
                                  rotation: rotation,
                                  scale: scale,
                                  type: type,
                                  adjustmentSettings: adjustmentSettings,
                                  colorFilter: colorFilter,
                                  textures: textures,
                                  masks: masks)
        return new
    }
    
    func getOriginalURLFrom(asset: PHAsset?) async -> URL? {
        guard let asset = asset, asset.mediaType == .video else { return nil }
        
        let options = PHVideoRequestOptions()
        options.isNetworkAccessAllowed = true
        
        return await withCheckedContinuation { c in
            PHImageManager().requestAVAsset(forVideo: asset, options: options) { (avAsset, _, _) in
                guard let avAsset = avAsset as? AVURLAsset else {
                    c.resume(returning: nil)
                    return
                }
                c.resume(returning: avAsset.url)
            }
        }
    }
    
    func getFilteredOriginal(asset: CanvasItemAsset?) async -> UIImage? {
        guard let asset = asset else { return nil }
        guard asset.type == .image else { return nil }
        
        var phImage: UIImage? = await getFrom(asset: asset.asset) ?? asset.image
        
        if let _phImage = phImage {
            let applyer: CanvasApplayer = .init()
            let res = await applyer.applyFilters(for: _phImage, filterChain: filterChain)
            switch res.value {
            case .image(let image): phImage = image
            default: break
            }
        }
        
        return phImage
    }
}

extension CanvasItemModel {
    func getOriginalURLFrom(asset: CanvasItemAsset?) async -> URL? {
        guard let asset = asset, asset.type == .video else { return nil }
        let originalURL: URL? = await getOriginalURLFrom(asset: asset.asset) ?? asset.url
        return originalURL
    }
}

extension CanvasItemModel {
    func getFrom(asset: PHAsset?) async -> UIImage? {
        guard let asset = asset else { return nil }
        
        var phImage: UIImage?
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: options) { image, _ in
            phImage = image
        }
        
        return phImage
    }
}

final class CanvasItemAsset {
    enum `Type` {
        case image
        case video
    }
    
    let asset: PHAsset?
    let image: UIImage?
    let url: URL?
    let type: `Type`
    
    init(asset: PHAsset?, image: UIImage?, url: URL?, type: `Type`) {
        self.asset = asset
        self.image = image
        self.url = url
        self.type = type
    }
    
    static func image(asset: PHAsset?, image: UIImage?)  -> CanvasItemAsset{
        return .init(asset: asset, image: image, url: nil, type: .image)
    }
    
    static func video(asset: PHAsset?, url: URL?) -> CanvasItemAsset{
        return .init(asset: asset, image: nil, url: url, type: .video)
    }
}
