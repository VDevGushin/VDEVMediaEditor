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

final class CanvasLayersDataViewModel: ObservableObject {
    @Published var layers: IdentifiedArrayOf<CanvasItemModel> = []
    @Injected private var settings: VDEVMediaEditorSettings
    @Injected private var mementoService: MementoService

    var isEmpty: Bool { layers.isEmpty }
    var isLimit: Bool { layers.count >= maximumLayers }
    
    private var maximumLayers: Int { settings.maximumLayers }
    private var subscriptions = Cancellables()
    private var storage = Cancellables()
    
    init() {
        // слежу за внутренними изменениями объектов в коллекции
        $layers
            .sink(self) { wSelf, layers in
                wSelf.subscriptions.removeAll()
                for item in layers {
                    item.objectWillChange
                        .sink { _ in
                            wSelf.objectWillChange.send()
                        }
                        .store(in: &wSelf.subscriptions)
                }
            }
            .store(in: &storage)
    }
    
    func removeAll(withSave: Bool = true) {
        if withSave { forceSave() }
        layers.removeAll()
    }
    
    func add(_ item: CanvasItemModel, withSave: Bool = true) {
        guard !isLimit else { return }
        if withSave { forceSave() }
        layers.updateOrAppend(item)
    }
    
    @discardableResult
    func reset(_ item: CanvasItemModel) -> CanvasItemModel {
        forceSave()
        guard let index = layers.index(id: item.id) else { return item }
        let copy = item.copy()
        copy.update(offset: .zero, scale: 1, rotation: .zero)
        layers.remove(item)
        layers.insert(copy, at: index)
        return copy
    }
    
    func copyReplace(_ item: CanvasItemModel) {
        forceSave()
        let copy = item.copy()
        layers.remove(item)
        layers.append(copy)
    }
    
    func delete(_ item: CanvasItemModel, withSave: Bool = true) {
        guard let index = layers.index(id: item.id) else { return }
        if withSave { forceSave() }
        layers.remove(at: index)
    }
    
    func delete(_ item: CanvasItemModel?, withSave: Bool = true) {
        guard let id = item?.id else { return }
        if withSave { forceSave() }
        layers.remove(id: id)
    }
    
    func up(_ item: CanvasItemModel) {
        guard let index = layers.index(id: item.id) else { return }
        // Если этот слой самый верхний
        if index >= (layers.count - 1) { return }
        forceSave()
        (layers[index], layers[index + 1]) = (layers[index + 1], layers[index])
    }
    
    func back(_ item: CanvasItemModel) {
        guard let index = layers.index(id: item.id) else { return }
        if index <= 0 { return }
        forceSave()
        (layers[index], layers[index - 1]) = (layers[index - 1], layers[index])
    }
    
    func bringToBack(_ item: CanvasItemModel) {
        let id = item.id
        if layers.index(id: id) == 0 { return }
        forceSave()
        if let replaceItem = layers.remove(id: id) {
            layers.insert(replaceItem, at: 0)
        }
    }
    
    func bringToFront(_ item: CanvasItemModel) {
        let id = item.id
        if layers.index(id: id) == layers.count - 1 { return }
        forceSave()
        if let replaceItem = layers.remove(id: id) {
            layers.append(replaceItem)
        }
    }
    
    // возможность вставить только 1 шаблон
    func addTemplate(_ item: CanvasTemplateModel) {
        forceSave()
        layers.removeAll { $0 is CanvasTemplateModel }
        layers.insert(item, at: 0)
    }
    
    func getStartTemplate(size: CGSize, completion: @escaping () -> Void) {
        guard size != .zero else {
            Log.e("Editor size is zero...")
            completion()
            return
        }
        
        settings.getStartTemplate(for: size) { [weak self] template in
            guard let self = self else { return }
            if let template = template {
                DispatchQueue.main.async {
                    self.addTemplate(.init(variants: template, editorSize: size))
                    Log.d("Start template is ready")
                    completion()
                }
                return
            }
            Log.d("Start template is empty")
            completion()
        }
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

// Work with sound
extension CanvasLayersDataViewModel {
    func set(sound: Float, for item: CanvasItemModel) -> CanvasItemModel {
        func copyReplaceWithOrder(_ item: CanvasItemModel) -> CanvasItemModel{
            guard let index = layers.index(id: item.id) else { return item }
            let copy = item.copy()
            layers.remove(item)
            layers.insert(copy, at: index)
            return copy
        }
        
        guard let item = layers[id: item.id] else { return item }
        
        if let item: CanvasVideoModel = CanvasItemModel.toTypeOptional(model: item) {
            item.update(volume: sound)
            return copyReplaceWithOrder(item)
        }
        
        if let item: CanvasAudioModel = CanvasItemModel.toTypeOptional(model: item) {
            item.update(volume: sound)
            return copyReplaceWithOrder(item)
        }
        
        if let item: CanvasVideoPlaceholderModel = CanvasItemModel.toTypeOptional(model: item) {
            item.update(volume: sound)
            return copyReplaceWithOrder(item)
        }
        
        return item
    }
}

// MARK: - Helpers
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

extension CanvasLayersDataViewModel {
    func canMerge(item: CanvasItemModel) -> CanvasItemModel? {
        guard !isLimit else { return nil }
        guard item.canMerge else { return nil }
        guard let index = layers.index(id: item.id), index > 0 else { return nil }
        guard let prevItem = layers[safe: index - 1], prevItem.canMerge else { return nil }
        return prevItem
    }
}

// - MARK: RELOADALL
extension CanvasLayersDataViewModel {
    func reloadAll() {
        removeAll(withSave: true)
        undo()
    }
}

// - MARK: MEMENTO
extension CanvasLayersDataViewModel: MementoObject {
    func undo() {
        layers.removeAll()
        if let layers = mementoService.undo()?.layers {
            self.layers = .init(uniqueElements: layers)
        }
    }
    
    func forceSave() {
        mementoService.save(newElement: LayersMemento(layers: self.layers.elements))
    }
}
