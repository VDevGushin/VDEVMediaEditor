//
//  CanvasLayersViewModel.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 02.02.2023.
//

import SwiftUI
import Combine
import AVKit
import IdentifiedCollections
import Resolver

final class CanvasLayersDataViewModel: ObservableObject {
    @Injected private var settings: VDEVMediaEditorSettings
    
    @Published var layers: IdentifiedArrayOf<CanvasItemModel> = []

    var isEmpty: Bool { layers.isEmpty }

    var isLimit: Bool { layers.count >= maximumLayers }
    
    private let maximumLayers: Int = 15

    private var subscriptions = Set<AnyCancellable>()
    private var storage = Set<AnyCancellable>()

    init() {
        // слежу за внутренними изменениями объектов в коллекции
        $layers
            .sink { [weak self] layers in
                guard let self = self else { return }

                self.subscriptions.removeAll()

                for item in layers {
                    item.objectWillChange
                        .sink(receiveValue: { [weak self] _ in self?.objectWillChange.send() })
                        .store(in: &self.subscriptions)
                }
            }
            .store(in: &storage)
    }
    
    func removeAll() {
        layers.removeAll()
    }

    func add(_ item: CanvasItemModel) {
        guard !isLimit else { return }
        layers.updateOrAppend(item)
    }
    
    @discardableResult
    func reset(_ item: CanvasItemModel) -> CanvasItemModel {
        guard let index = layers.index(id: item.id) else { return item }
        
        let copy = item.copy()
        copy.update(offset: .zero, scale: 1, rotation: .zero)
        layers.remove(item)
        layers.insert(copy, at: index)
        return copy
    }

    func copyReplace(_ item: CanvasItemModel) {
        let copy = item.copy()
        layers.remove(item)
        layers.append(copy)
    }

    func delete(_ item: CanvasItemModel) {
        let id = item.id
        layers.remove(id: id)
    }
    
    func delete(_ item: CanvasItemModel?) {
        guard let item = item else { return }
        delete(item)
    }

    func up(_ item: CanvasItemModel) {
        guard let index = layers.index(id: item.id) else { return }

        // Если этот слой самый верхний
        if index >= (layers.count - 1) { return }

        (layers[index], layers[index + 1]) = (layers[index + 1], layers[index])
    }

    func back(_ item: CanvasItemModel) {
        guard let index = layers.index(id: item.id) else { return }

        if index <= 0 { return }

        (layers[index], layers[index - 1]) = (layers[index - 1], layers[index])
    }

    func bringToBack(_ item: CanvasItemModel) {
        let id = item.id

        if let replaceItem = layers.remove(id: id) {
            layers.insert(replaceItem, at: 0)
        }
    }

    func bringToFront(_ item: CanvasItemModel) {
        let id = item.id

        if let replaceItem = layers.remove(id: id) {
            layers.append(replaceItem)
        }
    }
    
    func getStartTemplate(size: CGSize, completion: @escaping () -> Void) {
        settings.getStartTemplate(for: size) { [weak self] template in
            guard let self = self, let template = template else { return }
            DispatchQueue.main.async {
                self.addTemplate(.init(variants: template, editorSize: size))
                completion()
            }
        }
    }
}

// MARK: - Helpers
extension CanvasLayersDataViewModel {
    func canReset(item: CanvasItemModel) -> Bool {
        item.offset != .zero || item.scale != 1 || item.rotation != .zero
    }
}

extension CanvasLayersDataViewModel {
    // возможность вставить только 1 шаблон
    func addTemplate(_ item: CanvasTemplateModel) {
        layers.removeAll {
            $0 is CanvasTemplateModel
        }
        layers.insert(item, at: 0)
    }
}

// MARK: - Drag and drop
extension CanvasLayersDataViewModel {
    func handleDragAndDrop(for providers: [NSItemProvider],
                           completion: @escaping (CanvasItemModel) -> Void) -> Bool {
        var dropSucceed = false

        if providers.isEmpty {
            return dropSucceed
        }

        for provider in providers {
            if provider.canLoadObject(ofClass: UIImage.self) {
                dropSucceed = true

                _ = provider.loadObject(ofClass: UIImage.self) { [weak self] img, err in

                    guard let img = img as? UIImage else { return }

                    DispatchQueue.main.async { [weak self] in
                        let item = CanvasImageModel(image: img, asset: nil)
                        self?.add(item)
                        completion(item)
                    }
                }

            } else if provider.canLoadObject(ofClass: URL.self) {
                dropSucceed = true

                _ = provider.loadObject(ofClass: URL.self) { url, err in
                    guard let url = url else {
                        return
                    }

                    Task {
                        guard let image = await AssetExtractionUtil.image(fromURL: url) else { return }
                        await MainActor.run { [weak self] in
                            let item = CanvasImageModel(image: image, asset: nil)
                            self?.add(item)
                            completion(item)
                        }
                    }
                }
            } else if provider.canLoadObject(ofClass: String.self) {
                dropSucceed = true

                _ = provider.loadObject(ofClass: String.self) { [weak self] text, err in

                    guard let text = text else { return }

                    DispatchQueue.main.async { [weak self] in

                        let newModel = CanvasTextModel.with(text: text)
                        self?.add(newModel)
                        completion(newModel)
                    }
                }
            }
        }
        return dropSucceed
    }
}

// Check index for opacity when gesture
extension CanvasLayersDataViewModel {
    func rejectOpacityProperty(itemInCanvas: CanvasItemModel, itemInManipulation: CanvasItemModel?) -> Bool {
        // Get index of checkItem
        guard let itemInManipulation = itemInManipulation,
              let checkIndex = layers.index(id: itemInManipulation.id) else {
            return false
        }
        
        // Get index of current
        guard let currentIndex = layers.index(id: itemInCanvas.id) else { return false }
    
        return currentIndex < checkIndex
    }
}
