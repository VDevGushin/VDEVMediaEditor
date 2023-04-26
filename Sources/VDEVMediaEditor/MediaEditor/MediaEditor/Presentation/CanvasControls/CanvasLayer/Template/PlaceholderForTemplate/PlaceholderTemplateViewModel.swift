//
//  MediaTemplateViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 20.02.2023.
//

import SwiftUI
import AVKit
import Combine

final class PlaceholderTemplateViewModel: ObservableObject {
    unowned let item: CanvasPlaceholderModel
    weak var delegate: CanvasEditorDelegate?

    @Published private(set) var inProgress: Bool = false
    @Published private(set) var imageModel: CanvasImagePlaceholderModel?
    @Published private(set) var videoModel: CanvasVideoPlaceholderModel?
    
    @Published private(set) var showSelection: Bool = false

    private let aplayer: CanvasApplayer = .init()
    
    var size: CGSize { imageModel?.imageSize ?? videoModel?.size ?? .zero }
    
    var isEmpty: Bool { imageModel == nil && videoModel == nil }
    
    private var storage: Set<AnyCancellable> = Set()

    init(item: CanvasPlaceholderModel, delegate: CanvasEditorDelegate?) {
        self.item = item
        self.delegate = delegate
    }
}

// MARK: - Work with delegate
extension PlaceholderTemplateViewModel {
    func hideAllOverlayViews() {
        delegate?.hideAllOverlayViews()
    }
    
    func openEditVariants() {
        if let canvasItem = imageModel ?? videoModel {
            delegate?.endWorkWithItem?()
            
            delegate?.hideAllOverlayViews()
            
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
            
            delegate?.showMediaEditor(item: canvasItem)
        }
    }

    func openMediaSelector() {
        if inProgress { return }
        
        delegate?.endWorkWithItem?()

        self.delegate?.pickSelector = { [weak self] model in
            guard let self = self else { return }
            
            self.delegate?.hideMediaPicker()

            guard let model = model else { return }
            
            self.storage.removeAll()

            self.inProgress = true

            Task {
                switch model.mediaType {
                case .photo:
                    guard let image = model.image else { return }
                    
                    await self.reset()
                    
                    let model = await CanvasImagePlaceholderModel
                        .applyFilter(applyer: self.aplayer,
                                     image: image,
                                     asset: model.phAsset,
                                     filters: self.item.filters)

                    await self.setImage(model: model)
                    
                case .video:
                    guard let url = model.url else { return }
                    
                    await self.reset()
                    
                    let model = await CanvasVideoPlaceholderModel
                        .applyFilter(applyer:  self.aplayer,
                                     url: url,
                                     thumbnail: model.image,
                                     asset: model.phAsset,
                                     filters: self.item.filters)

                    await self.setVideo(model: model)
                default: break
                }
            }
        }

        delegate?.hideAllOverlayViews()
        delegate?.showMediaPicker()
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
    }

    @MainActor
    func setImage(model: CanvasImagePlaceholderModel?) async {
        inProgress = false
        imageModel = model

        guard let iModel = imageModel else { return }

        item.update(imageModel: iModel)
        observe(nested: iModel).store(in: &storage)
    }

    @MainActor
    func setVideo(model: CanvasVideoPlaceholderModel?) async {
        inProgress = false
        videoModel = model

        guard let vModel = videoModel else { return }
        item.update(videoModel: vModel)
        observe(nested: vModel).store(in: &storage)
    }
}

