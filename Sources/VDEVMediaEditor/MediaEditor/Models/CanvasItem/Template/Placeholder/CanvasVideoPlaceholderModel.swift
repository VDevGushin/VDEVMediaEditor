//
//  CanvasVideoPlaceholderModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 24.02.2023.
//

import UIKit
import AVKit
import Combine
import Photos

final class CanvasVideoPlaceholderModel: CanvasItemModel {
    private(set) var asset: CanvasItemAsset?
    private var originalVideoURL: URL

    @Published private(set) var volume: Float
    @Published private(set) var avVideoComposition: AVVideoComposition?
    @Published private(set) var maskVideoComposition: AVVideoComposition?

    @Published var inProgress: Bool = false
    
    private(set) var thumbnail: UIImage?
    private(set) var videoURL: URL
    private(set) var aspect: CGFloat
    private(set) var size: CGSize
    private(set) var maskImageFromTemplate: UIImage?

    private let aplayer = CanvasApplayer()
    private var storage = Set<AnyCancellable>()
    private(set) var filters: [EditorFilter]
    
    override var filterChain: [FilterDescriptor] {
        filters.noMask.flatMap { $0.steps.makeFilterDescriptors() } + super.filterChain
    }

    init(url: URL,
         avVideoComposition: AVVideoComposition?,
         maskVideoComposition: AVVideoComposition?,
         asset: CanvasItemAsset?,
         volume: Float = 0.0,
         thumbnail: UIImage?,
         maskImageFromTemplate: UIImage?,
         size: CGSize,
         aspect: CGFloat,
         filters: [EditorFilter]) {
        self.volume = volume
        self.size = size
        self.asset = asset
        self.aspect = aspect
        self.thumbnail = thumbnail
        self.videoURL = url
        self.originalVideoURL = url
        self.avVideoComposition = avVideoComposition
        self.maskVideoComposition = maskVideoComposition
        self.filters = filters
        self.maskImageFromTemplate = maskImageFromTemplate

        super.init(type: .video)
    }

    deinit {
        storage.cancelAll()
        Log.d("❌ Deinit: CanvasVideoPlaceholderModel")
    }
    
    func update(volume: Float) {
        self.volume = volume
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

        aplayer.applyFilters(for: originalVideoURL,
                             baseFilters: filters.noMask,
                             adjustmentSettings: adjustmentSettings,
                             colorFilter: colorFilter,
                             textures: textures,
                             masks: masks)
        .receive(on: DispatchQueue.main)
        .sink { [weak self] output in
            guard let self = self else { return }
            switch output.value {
            case .video(let composition): self.avVideoComposition = composition
            case .empty: self.avVideoComposition = nil
            case .image, .cancel: break
            }
            self.inProgress = false
        }
        .store(in: &storage)
    }
}

// MARK: - Создание из контента пришедшего с медиа пикера
extension CanvasVideoPlaceholderModel {
    static func applyFilter(applyer: CanvasApplayer,
                            url: URL,
                            thumbnail: UIImage?,
                            asset: CanvasItemAsset?,
                            filters: [EditorFilter]) async -> CanvasVideoPlaceholderModel? {
        
        let size = await AVAsset(url: url).getSize()

        var aspect: CGFloat? = nil

        if let size = size  { aspect = size.width / size.height }

        guard let size = size, let aspect = aspect else { return nil }

        if filters.isEmpty {
            return .init(url: url,
                         avVideoComposition: nil,
                         maskVideoComposition: nil,
                         asset: asset,
                         volume: 0.0,
                         thumbnail: thumbnail,
                         maskImageFromTemplate: nil,
                         size: size,
                         aspect: aspect,
                         filters: [])
        }

        let noMaskFilters = filters.noMask
        let onlyMaskFilters =  filters.onlyMask

        Log.i(" Template all filters: \(filters.map { $0.steps.map { $0.type }})")
        Log.i(" Template no mask filters: \(noMaskFilters.map { $0.steps.map { $0.type }})")
        Log.i(" Template only mask filters: \(onlyMaskFilters.map { $0.steps.map { $0.type }})")

        var filteredFilter: CanvasApplayerOutput = .empty()
        if !noMaskFilters.isEmpty {
            filteredFilter = await applyer.applyFilters(for: url, filters: noMaskFilters)
        }

        var maskedFilter: CanvasApplayerOutput = .empty()
        if !onlyMaskFilters.isEmpty {
            maskedFilter = await applyer.applyFilters(for: url, filters: onlyMaskFilters)
        }
        
        var originalVideoComposition: AVVideoComposition?
        switch filteredFilter.value {
        case .video(let composition):
            originalVideoComposition = composition
        case .empty, .cancel, .image:
            originalVideoComposition = nil
        }

        var maskedVideoComposition: AVVideoComposition?
        switch maskedFilter.value {
        case .video(let composition):
            maskedVideoComposition = composition
        case .empty, .cancel, .image:
            maskedVideoComposition = originalVideoComposition
        }
        
        let maskImageFromTemplate = await PlaceholderMaskLoader.load(from: onlyMaskFilters.maskImageURL)

        return .init(url: url,
                     avVideoComposition: originalVideoComposition,
                     maskVideoComposition: maskedVideoComposition,
                     asset: asset,
                     volume: 0.0,
                     thumbnail: thumbnail,
                     maskImageFromTemplate: maskImageFromTemplate,
                     size: size,
                     aspect: aspect,
                     filters: filters)
    }
    
    static func changeVolume(from item: CanvasVideoPlaceholderModel, volume: Float) -> CanvasVideoPlaceholderModel? {
        
        return .init(url: item.videoURL,
                     avVideoComposition: item.avVideoComposition,
                     maskVideoComposition: item.maskVideoComposition,
                     asset: item.asset,
                     volume: volume,
                     thumbnail: item.thumbnail,
                     maskImageFromTemplate: item.maskImageFromTemplate,
                     size: item.size,
                     aspect: item.aspect,
                     filters: item.filters)
    }
}

extension CanvasVideoPlaceholderModel {
    func getOriginal() async -> URL? {
        await self.getOriginalURLFrom(asset: asset)
    }
}
