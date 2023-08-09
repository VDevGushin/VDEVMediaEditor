//
//  MediaTemplateViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 20.02.2023.
//

import SwiftUI
import AVKit
import Combine

extension PlaceholderTemplateViewModel {
    enum ProgresType {
        case simple
        case neural(UIImage?)
        
        init(withNeural: Bool, image: UIImage? = nil) {
            self = withNeural ? .neural(image) : .simple
        }
    }
}

final class PlaceholderTemplateViewModel: ObservableObject {
    unowned let item: CanvasPlaceholderModel
    weak var delegate: CanvasEditorDelegate?
    
    @Published private(set) var inProgress: ProgresType? = nil
    @Published private(set) var imageModel: CanvasImagePlaceholderModel?
    @Published private(set) var videoModel: CanvasVideoPlaceholderModel?
    @Published private(set) var showSelection: Bool = false
    @Published private(set) var isEmpty: Bool = true

    private let aplayer: CanvasApplayer = .init()
    private var storage = Cancellables()
    private var hasNeural: Bool { item.filters.hasNeural }
    
    var size: CGSize {
        imageModel?.imageSize ?? videoModel?.size ?? .zero
    }
    
    init(item: CanvasPlaceholderModel, delegate: CanvasEditorDelegate?) {
        self.item = item
        self.delegate = delegate
    }
    
    deinit {
        Log.d("❌ Deinit[TEMPLATE]: PlaceholderTemplateViewModel")
    }
}

// MARK: - Work with delegate
extension PlaceholderTemplateViewModel {
    func hideAllOverlayViews() {
        delegate?.endWorkWithItem?()
        delegate?.hideAllOverlayViews()
        showSelection = false
    }
    
    func openEditVariants() {
        if let canvasItem = imageModel ?? videoModel {
            hideAllOverlayViews()
            
            showSelection = true
            
            delegate?.deleteItem = { [weak self] model in
                if canvasItem == model {
                    self?.showSelection = false
                    self?.resetItem()
                }
            }
            
            delegate?.endWorkWithItem = { [weak self] in
                self?.showSelection = false
            }
            
            delegate?.changeSound = { [weak self] item, volume in
                guard let self = self else { return }
                self.videoModel?.update(volume: volume)

                self.showSelection = false
            }
            
            delegate?.showMediaEditor(item: canvasItem)
        }
    }

    func openMediaSelector() {
        if inProgress != nil { return }
        
        hideAllOverlayViews()
        delegate?.endWorkWithItem = { [weak self] in
            self?.showSelection = false
        }
        showSelection = true
        
        self.delegate?.pickSelector = { [weak self] model in
            guard let self = self else { return }
            guard let model = model else { return }
            showSelection = false
            self.storage.removeAll()
            let hasNeural = self.hasNeural
            self.inProgress = .init(withNeural: hasNeural)
            Task {
                switch model.mediaType {
                case .photo:
                    guard let image = model.image else { return }
                    
                    await MainActor.run {
                        self.inProgress = .init(withNeural: hasNeural, image: image)
                    }
                    
                    await self.reset()
                    let model = await CanvasImagePlaceholderModel
                        .applyFilter(applyer: self.aplayer,
                                     image: image,
                                     asset: model.itemAsset,
                                     filters: self.item.filters)

                    await self.setImage(model: model)
                    
                case .video:
                    guard let url = model.url else { return }
                    await self.reset()
                    let model = await CanvasVideoPlaceholderModel
                        .applyFilter(applyer:  self.aplayer,
                                     url: url,
                                     thumbnail: model.image,
                                     asset: model.itemAsset,
                                     filters: self.item.filters)

                    await self.setVideo(model: model)
                default: break
                }
            }
        }
        
        delegate?.showMediaPicker(workWithNeural: hasNeural)
    }
}

fileprivate extension PlaceholderTemplateViewModel {
    @MainActor
    func reset() async { resetItem() }
    
    func resetItem() {
        storage.removeAll()
        imageModel = nil
        videoModel = nil
        item.update(imageModel: nil)
        item.update(videoModel: nil)
        isEmpty = imageModel == nil && videoModel == nil
    }

    @MainActor
    func setImage(model: CanvasImagePlaceholderModel?) async {
        inProgress = nil
        imageModel = model
        guard let iModel = imageModel else { return }
        item.update(imageModel: iModel)
        observe(nested: iModel).store(in: &storage)
        isEmpty = false
        makeHaptics()
    }

    @MainActor
    func setVideo(model: CanvasVideoPlaceholderModel?) async {
        inProgress = nil
        videoModel = model
        guard let vModel = videoModel else { return }
        item.update(videoModel: vModel)
        observe(nested: vModel).store(in: &storage)
        isEmpty = false
        makeHaptics()
    }
}

