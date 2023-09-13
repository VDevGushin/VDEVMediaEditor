//
//  CanvasDrawModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 15.02.2023.
//

import SwiftUI

// MARK: - Drawing
final class CanvasDrawModel: CanvasItemModel {
    @Published private(set) var image: UIImage // То, что пользователь видит
    @Published private(set) var inProgress: ProgresOperationType?
    
    private(set) var originalImage: UIImage // Оригинальное изображение
    private(set) var imageWithNeural: UIImage? // Картинка с нейронкой

    private let aplayer: CanvasApplayer = .init()
    private var storage = Cancellables()
    
    var withNeural: Bool {
        imageWithNeural != nil
    }
    
    init(image: UIImage,
         originalImage: UIImage? = nil,
         imageWithNeural: UIImage? = nil,
         neuralFilter: NeuralEditorFilter? = nil,
         bounds: CGRect,
         offset: CGSize) {
        
        self.image = image
        self.originalImage = originalImage ?? image
        self.imageWithNeural = imageWithNeural
        
        super.init(
            offset: offset,
            bounds: bounds,
            type: .drawing,
            neuralFilter: neuralFilter
        )
    }
    
    override func apply(neuralFilter: NeuralEditorFilter?) {
        setNeuralFilters(neuralFilter: neuralFilter)
    }

    deinit {
        Log.d("❌ Deinit: CanvasDrawModel")
    }

    override func copy() -> CanvasItemModel {
        let new = CanvasDrawModel(
            image: image,
            originalImage: originalImage,
            imageWithNeural: imageWithNeural,
            neuralFilter: neuralFilter,
            bounds: bounds,
            offset: .zero
        )
        new.update(offset: offset, scale: scale, rotation: rotation)
        return new
    }
}

private extension CanvasDrawModel {
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
                    wSelf
                        .update(
                            offset: .zero,
                            scale: 1,
                            rotation: .zero
                        )
                        .update(
                            bounds: .init(
                                origin: .zero,
                                size: value.size
                            )
                        )
                default:
                    wSelf.imageWithNeural = nil
                    wSelf.neuralFilter = nil
                    wSelf.image = wSelf.originalImage
                    wSelf.update(
                        bounds: .init(
                            origin: .zero,
                            size: wSelf.originalImage.size
                        )
                    )
                }
                wSelf.inProgress = nil
            }
            .store(in: &storage)
    }
    
    func setupBeforeAIProcessing(_ neuralFilter: NeuralEditorFilter?) -> Bool {
        self.neuralFilter = neuralFilter
        guard neuralFilter != nil else { return false }
        masks = nil
        textures = nil
        adjustmentSettings = nil
        colorFilter = nil
        return true
    }
}
