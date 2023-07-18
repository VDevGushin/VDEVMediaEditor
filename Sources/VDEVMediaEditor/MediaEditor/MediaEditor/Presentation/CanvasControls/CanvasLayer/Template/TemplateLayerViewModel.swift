//
//  TemplateLayerViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 17.02.2023.
//

import SwiftUI
import IdentifiedCollections
import Combine
import Kingfisher
import CollectionConcurrencyKit

final class TemplateLayerViewModel: ObservableObject {
    @Injected private var settings: VDEVMediaEditorSettings
    @Published private(set) var isLoading = false
    @Published var templateLayers: IdentifiedArrayOf<CanvasItemModel> = []
    private(set) var item: CanvasTemplateModel
    
    var canRemoveOrChangeTemplate: Bool { settings.сanRemoveOrChangeTemplate }
    
    private var operation: Task<Void, Never>?
    
    weak var delegate: CanvasEditorDelegate?

    init(item: CanvasTemplateModel, delegate: CanvasEditorDelegate?) {
        self.delegate = delegate
        self.item = item
        self.makeLayers()
    }

    deinit {
        operation?.cancel()
        operation = nil
        templateLayers.removeAll()
        Log.d("❌ Deinit[TEMPLATE]: TemplateLayerViewModel")
    }
}

fileprivate extension TemplateLayerViewModel {
    @MainActor
    func set(layers: [CanvasItemModel]) async {
        self.isLoading = false
        self.templateLayers = .init(uniqueElements: layers)
        self.item.update(layerItems: templateLayers)
    }

    func makeLayers() {
        isLoading = true

        operation = Task(priority: .utility) {
            let result: [CanvasItemModel] = await self.item.variants.asyncCompactMap { v in
                return try? await self.make(from: v, canvasSize: self.item.bounds.size)
            }

            await self.set(layers: result)
        }
    }

    func make(from item: TemplatePack.Variant.Item,
              canvasSize: CGSize) async throws -> CanvasItemModel? {

        if let fontPreset = item.fontPreset {
            let offset = CGSize.centralOffset(withTemplateRect: item.rect, canvasSize: canvasSize)

            if item.isMovable || item.isLocked {
                return CanvasTextModel(text: item.text,
                                       placeholder: item.placeholderText,
                                       fontSize: fontPreset.fontSize,
                                       color: fontPreset.color,
                                       alignment: Alignment(verticalAlignment: fontPreset.verticalAlignment),
                                       textAlignment: NSTextAlignment(textAlignment: fontPreset.textAlignment),
                                       textStyle: fontPreset.textStyle,
                                       needTextBG: false,
                                       textFrameSize: item.rect.size,
                                       offset: offset,
                                       rotation: .zero,
                                       scale: 1,
                                       isMovable: item.isMovable)
            } else {
                let text = CanvasTextModel(text: item.text,
                                           placeholder: item.placeholderText,
                                           fontSize: fontPreset.fontSize,
                                           color: fontPreset.color,
                                           alignment: Alignment(verticalAlignment: fontPreset.verticalAlignment),
                                           textAlignment: NSTextAlignment(textAlignment: fontPreset.textAlignment),
                                           textStyle: fontPreset.textStyle,
                                           needTextBG: false,
                                           textFrameSize: item.rect.size,
                                           offset: offset,
                                           rotation: .zero,
                                           scale: 1,
                                           isMovable: item.isMovable)
                
                return CanvasTextForTemplateItemModel(text: text)
            }
        } else {
            if item.isLocked {
                guard let url = item.url else { return nil }

                let cacheResult = try await ImageCache.default.retrieveImage(
                    downloadAndStoreIfNeededFrom: url,
                    forKey: url.absoluteString
                )

                guard let image = cacheResult.image else { return nil }

                let offset = CGSize.centralOffset(withTemplateRect: item.rect, canvasSize: canvasSize)

                return CanvasImageModel(image: image,
                                        asset: nil,
                                        bounds: item.rect,
                                        offset: offset,
                                        blendingMode: item.blendingMode)

            } else {
                let offset = CGSize.centralOffset(withTemplateRect: item.rect, canvasSize: canvasSize)
                
                return CanvasPlaceholderModel(url: item.url,
                                              bounds: item.rect,
                                              offset: offset,
                                              filters: item.filters,
                                              blendingMode: item.blendingMode)
            }
        }
    }
}

private extension Alignment {
    init(verticalAlignment id: Int) {
        switch id {
        case 0: self = .top
        case 1: self = .center
        case 2: self = .bottom
        default: self = .center
        }
    }
}
