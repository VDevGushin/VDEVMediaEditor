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
    private(set) var asset: PHAsset?
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
    private var storage = Set<AnyCancellable>()
    private(set) var filters: [EditorFilter]
    
    override var filterChain: [FilterDescriptor] {
        filters.noMask.flatMap { $0.steps.makeFilterDescriptors() } + super.filterChain
    }
    
    init(image: UIImage,
         templatedImage: UIImage? = nil,
         maskImageFromTemplate: UIImage?,
         asset: PHAsset?,
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
        Log.d("❌ Deinit: CanvasImagePlaceholderModel")
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
                             baseFilters: filters.noMask,
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
}

// MARK: - Создание из контента пришедшего с медиа пикера
extension CanvasImagePlaceholderModel {
    static func applyFilter(applyer: CanvasApplayer,
                            image: UIImage,
                            asset: PHAsset?,
                            filters: [EditorFilter]) async -> CanvasImagePlaceholderModel {
        
        if filters.isEmpty {
            return .init(image: image, templatedImage: nil, maskImageFromTemplate: nil, asset: asset, filters: [])
        }
        
        let noMaskFilters = filters.noMask
        let onlyMaskFilters =  filters.onlyMask
        
        Log.i("Template all filters: \(filters.map { $0.steps.map { $0.type }})")
        Log.i("Template no mask filters: \(noMaskFilters.map { $0.steps.map { $0.type }})")
        Log.i("Template only mask filters: \(onlyMaskFilters.map { $0.steps.map { $0.type }})")
        
        
        let filteredFilter = await applyer.applyFilters(for: image, filters: noMaskFilters)
        
        let maskedFilter = await applyer.applyFilters(for: image, filters: onlyMaskFilters)
        
        let original: UIImage
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
