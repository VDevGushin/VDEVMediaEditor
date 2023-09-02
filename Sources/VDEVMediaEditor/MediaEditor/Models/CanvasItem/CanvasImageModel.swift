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
    @Published private(set) var image: UIImage
    @Published private(set) var inProgress: ProgresOperationType?
    
    private(set) var asset: CanvasItemAsset?
    private(set) var originalImage: UIImage
    private(set) var imageWithNeural: UIImage? // Картинка с нейронкой
    
    private let aplayer: CanvasApplayer = .init()
    private var storage = Cancellables()
    
    init(image: UIImage,
         asset: CanvasItemAsset?,
         originalImage: UIImage? = nil,
         imageWithNeural: UIImage? = nil,
         bounds: CGRect = .zero,
         offset: CGSize = .zero,
         adjustmentSettings: AdjustmentSettings? = nil,
         colorFilter: EditorFilter? = nil,
         neuralFilter: NeuralEditorFilter? = nil,
         textures: EditorFilter? = nil,
         masks: EditorFilter? = nil,
         blendingMode: BlendingMode = .normal) {
        
        self.originalImage = originalImage ?? image
        self.imageWithNeural = imageWithNeural
        self.image = image
        self.asset = asset
        
        super.init(
            offset: offset,
            bounds: bounds,
            type: .image,
            adjustmentSettings: adjustmentSettings,
            colorFilter: colorFilter,
            neuralFilter: neuralFilter,
            textures: textures,
            masks: masks,
            blendingMode: blendingMode)
    }
    
    deinit {
        storage.cancelAll()
        Log.d("❌ Deinit: CanvasImageModel")
    }
    
    override func apply(neuralFilter: NeuralEditorFilter?) {
        setNeuralFilters(neuralFilter: neuralFilter)
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
        setAllFilters(fromAdjustment: true)
    }
    
    override func copy() -> CanvasImageModel {
        let new = CanvasImageModel(image: image,
                                   asset: asset,
                                   originalImage: originalImage,
                                   imageWithNeural: imageWithNeural,
                                   adjustmentSettings: adjustmentSettings,
                                   colorFilter: colorFilter,
                                   neuralFilter: neuralFilter,
                                   textures: textures,
                                   masks: masks)
        new.update(offset: offset, scale: scale, rotation: rotation)
        return new
    }
}

private extension CanvasImageModel {
    func setNeuralFilters(neuralFilter: NeuralEditorFilter?) {
        let isWithNeural = setupBeforeAIProcessing(neuralFilter)
        storage.cancelAll()
        
        inProgress = .neural(
            withNeural: isWithNeural,
            fromAdjustment: false,
            image: image
        )
        
        aplayer
            .applyFilters(
                for: originalImage,
                neuralFilters: neuralFilter
            )
            .sink(
                on: .main,
                object: self
            ) { wSelf, output in
                makeHaptics()
                switch output.value {
                case .image(let value):
                    wSelf.imageWithNeural = isWithNeural ? value: nil
                    if wSelf.imageWithNeural == nil {
                        wSelf.neuralFilter = nil
                    }
                    wSelf.image = value
                default:
                    wSelf.imageWithNeural = nil
                    wSelf.neuralFilter = nil
                    wSelf.image = wSelf.originalImage
                }
                wSelf.inProgress = nil
            }
            .store(in: &storage)
    }
    
    // Применение фильтров пользователя
    func setAllFilters(fromAdjustment: Bool = false) {
        storage.limitCancel()
        inProgress = .simple(fromAdjustment: fromAdjustment)
        
        aplayer.applyFilters(
            for: imageWithNeural ?? originalImage,
            adjustmentSettings: adjustmentSettings,
            colorFilter: colorFilter,
            textures: textures,
            masks: masks
        )
        .throttle(for: 0.2, scheduler: DispatchQueue.main, latest: true)
        .sink(on: .main, object: self) { wSelf, output in
            switch output.value {
            case .image(let value):
                wSelf.image = value
            default:
                wSelf.image = wSelf.imageWithNeural ?? wSelf.originalImage
            }
            wSelf.inProgress = nil
        }
        .store(in: &storage)
    }
    
    private func setupBeforeAIProcessing(
        _ neuralFilter: NeuralEditorFilter?
    ) -> Bool {
        self.neuralFilter = neuralFilter
        guard neuralFilter != nil else { return false }
        masks = nil
        textures = nil
        adjustmentSettings = nil
        colorFilter = nil
        return true
    }
}

extension CanvasImageModel {
    func getFilteredOriginal() async -> UIImage? {
        // Если передать nil, то builder будет брать изображение с канваса
        await getFilteredOriginal(asset: imageWithNeural != nil ? nil : asset)
    }
}
