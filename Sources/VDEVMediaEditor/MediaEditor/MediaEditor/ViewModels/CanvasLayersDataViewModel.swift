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
    @Injected private var settings: VDEVMediaEditorSettings
    
    private(set) lazy var dataModelObserver: CanvasLayersDataViewModelObserver = .init(dataModel: self)
    
    @Published var layers: IdentifiedArrayOf<CanvasItemModel> = []
    
    var isEmpty: Bool { layers.isEmpty }
    
    var isLimit: Bool { layers.count >= maximumLayers }
    
    private var maximumLayers: Int {
        settings.maximumLayers
    }
    
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
        dataModelObserver.onChange()
        layers.removeAll()
    }
    
    func add(_ item: CanvasItemModel) {
        guard !isLimit else { return }
        dataModelObserver.onChange()
        layers.updateOrAppend(item)
    }
    
    @discardableResult
    func reset(_ item: CanvasItemModel) -> CanvasItemModel {
        dataModelObserver.onChange()
        guard let index = layers.index(id: item.id) else { return item }
        let copy = item.copy()
        copy.update(offset: .zero, scale: 1, rotation: .zero)
        layers.remove(item)
        layers.insert(copy, at: index)
        return copy
    }
    
    func copyReplace(_ item: CanvasItemModel) {
        dataModelObserver.onChange()
        let copy = item.copy()
        layers.remove(item)
        layers.append(copy)
    }
    
    func delete(_ item: CanvasItemModel) {
        dataModelObserver.onChange()
        layers.remove(id: item.id)
    }
    
    func delete(_ item: CanvasItemModel?) {
        guard let id = item?.id else { return }
        dataModelObserver.onChange()
        layers.remove(id: id)
    }
    
    func up(_ item: CanvasItemModel) {
        guard let index = layers.index(id: item.id) else { return }
        // Если этот слой самый верхний
        if index >= (layers.count - 1) { return }
        dataModelObserver.onChange()
        (layers[index], layers[index + 1]) = (layers[index + 1], layers[index])
    }
    
    func back(_ item: CanvasItemModel) {
        guard let index = layers.index(id: item.id) else { return }
        if index <= 0 { return }
        dataModelObserver.onChange()
        (layers[index], layers[index - 1]) = (layers[index - 1], layers[index])
    }
    
    func bringToBack(_ item: CanvasItemModel) {
        let id = item.id
        if layers.index(id: id) == 0 { return }
        dataModelObserver.onChange()
        if let replaceItem = layers.remove(id: id) {
            
            layers.insert(replaceItem, at: 0)
        }
    }
    
    func bringToFront(_ item: CanvasItemModel) {
        let id = item.id
        if layers.index(id: id) == layers.count - 1 { return }
        dataModelObserver.onChange()
        if let replaceItem = layers.remove(id: id) {
            layers.append(replaceItem)
        }
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

// MARK: - Helpers
extension CanvasLayersDataViewModel {
    func canReset(item: CanvasItemModel) -> Bool {
        item.offset != .zero || item.scale != 1 || item.rotation != .zero
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

extension CanvasLayersDataViewModel {
    // возможность вставить только 1 шаблон
    func addTemplate(_ item: CanvasTemplateModel) {
        dataModelObserver.onChange()
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

// - MARK: MEMENTO
extension CanvasLayersDataViewModel {
    func forceSave() {
        dataModelObserver.onChange()
    }
    
    func saveState() -> LayersMemento {
        .init(layers: self.layers.elements)
    }
    
    func restoreState(_ memento: LayersMemento) {
        self.layers = .init(uniqueElements: memento.layers)
    }
}

final class CanvasLayersDataViewModelObserver: ObservableObject {
    @Published private(set) var canUndo: Bool = false
    @Injected private var settings: VDEVMediaEditorSettings
    
    private lazy var historyService = CanvasHistory(limit: settings.historyLimit)
    private weak var dataModel: CanvasLayersDataViewModel?
    
    init(dataModel: CanvasLayersDataViewModel) {
        self.dataModel = dataModel
        self.canUndo = false
    }
    
    func onChange() {
        guard let dataModel = dataModel else { return }
        historyService.push(dataModel.saveState())
        canUndo = !historyService.isEmpty
    }
    
    func undo() {
        guard let dataModel = dataModel,
              let element = historyService.pop() else { return }
        dataModel.restoreState(element)
        canUndo = !historyService.isEmpty
    }
}
