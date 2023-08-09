//
//  CanvasImagePlaceholderModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 24.02.2023.
//

import UIKit
import Combine
import Photos

final class CanvasImagePlaceholderModel: CanvasItemModel {
    private(set) var asset: CanvasItemAsset?
    
    private(set) var originalImage: UIImage
    // картинка, которую показываем
    @Published private(set) var image: UIImage
    // Картинка для применения маски обрезания (чтобы скролить фотки внутри контейнера)
    @Published private(set) var templatedImage: UIImage?
    @Published private(set) var inProgress: Bool = false
    
    private(set) var maskImageFromTemplate: UIImage?
    
    var imageSize: CGSize { originalImage.size }
    var aspectRatio: CGFloat { originalImage.aspectRatio }
    
    private let aplayer: CanvasApplayer = .init()
    private var storage = Cancellables()
    private(set) var filters: [EditorFilter]
    
    override var filterChain: [FilterDescriptor] {
        filters.noMask.flatMap { $0.steps.makeFilterDescriptors(id: $0.id) } + super.filterChain
    }
    
    init(image: UIImage,
         templatedImage: UIImage? = nil,
         maskImageFromTemplate: UIImage?,
         asset: CanvasItemAsset?,
         filters: [EditorFilter]) {
        self.originalImage = image
        self.image = image
        self.templatedImage = templatedImage
        self.filters = filters
        self.asset = asset
        self.maskImageFromTemplate = maskImageFromTemplate
        super.init(type: .image)
    }
    
    deinit {
        storage.cancelAll()
        Log.d("❌ Deinit[TEMPLATE]: CanvasImagePlaceholderModel")
    }
    
    override func apply(textures: EditorFilter?) {
        self.textures = textures
        applyUserFilters()
    }
    
    override func apply(colorFilter: EditorFilter?) {
        self.colorFilter = colorFilter
        applyUserFilters()
    }
    
    override func apply(adjustmentSettings: AdjustmentSettings?) {
        self.adjustmentSettings = adjustmentSettings
        applyUserFilters()
    }
    
    private func applyUserFilters() {
        inProgress = true
        
        storage.limitCancel()
        
        applyFilters()
            .sink(on: .main, object: self) { wSelf, output in
                switch output.value {
                case .image(let value):
                    wSelf.image = value
                case .empty:
                    wSelf.image = wSelf.originalImage
                case .video, .cancel:
                    break
                }
                wSelf.inProgress = false
            }
            .store(in: &storage)
    }
    
    // Если есть фильтры с нейросетями - необходимо работать с картинкой,
    // которая уже получена из нейронки
    // иначе при применение пользователем фильтров, будет всегда применяться
    // нейронка (для нас это плохо, так как результат, каждый раз разный!
    private func applyFilters() -> AnyPublisher<CanvasApplayerOutput, Never> {
        if filters.hasNeural {
            // image = уже обработанная базовыми фильтрами и нейронкой картинка
            return aplayer.applyFilters(for: originalImage, filterChain: super.filterChain)
        } else {
            return aplayer.applyFilters(for: originalImage,
                                        baseFilters: filters.noMask,
                                        adjustmentSettings: adjustmentSettings,
                                        colorFilter: colorFilter,
                                        textures: textures,
                                        masks: masks)
        }
    }
}

// MARK: - Создание из контента пришедшего с медиа пикера
// тут возможно применение нейронки
extension CanvasImagePlaceholderModel {
    static func applyFilter(applyer: CanvasApplayer,
                            image: UIImage,
                            asset: CanvasItemAsset?,
                            filters: [EditorFilter]) async -> CanvasImagePlaceholderModel {
        
        if filters.isEmpty {
            return .init(
                image: image,
                templatedImage: nil,
                maskImageFromTemplate: nil,
                asset: asset,
                filters: []
            )
        }
        
        let simpleFilters = filters.noMask
        let onlyMaskFilters = filters.onlyMask
        
        let filteredFilter = await applyer.applyFilters(for: image, filters: simpleFilters)
        let maskedFilter = await applyer.applyFilters(for: image, filters: onlyMaskFilters)
        
        var original: UIImage
        switch filteredFilter.value {
        case .image(let value): original = value
        case .video, .cancel, .empty: original = image
        }
        
        var templatedImage: UIImage?
        switch maskedFilter.value {
        case .image(let value): templatedImage = value
        case .video, .cancel, .empty: templatedImage = nil
        }
        
        let maskImageFromTemplate = await PlaceholderMaskLoader.load(from: onlyMaskFilters.maskImageURL)
        
        return .init(image: original,
                     templatedImage: templatedImage,
                     maskImageFromTemplate: maskImageFromTemplate,
                     asset: asset,
                     filters: filters)
    }
}

extension CanvasImagePlaceholderModel {
    func getFilteredOriginal() async -> UIImage? {
        await getFilteredOriginal(asset: asset)
    }
}
