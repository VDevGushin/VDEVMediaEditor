//
//  ToolsViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//
import SwiftUI
import Combine
import Kingfisher

final class CanvasToolsViewModel: ObservableObject {
    @Injected private var settings: VDEVMediaEditorSettings
    var baseChallengeId: String { settings.resourceID }

    // Открыть/закрыть показ развернутых слоев
    @Published private(set) var openLayersList: Bool = false
    // все возможные тулзы (что можно сделать с canvasitem)
    @Published private(set) var toolsItems: [ToolItem] = ToolItem.allCases
    // выбранная тулза в текущий момент
    @Published private(set) var currentToolItem: ToolItem = .empty
    // показать селектор возможных выбранных тулзов
    @Published private(set) var showAddItemSelector: Bool = false
    // получаем информацию о любых манипуляций от канваса
    // На главное vm - убираем все возможные меню
    @Published var layerInManipulation: CanvasItemModel?
    // Показать/скрыть менюху, где слои и добавление нового item в канвас
    @Published private(set) var layersAndAddNewItemIsVisible: Bool = true
    // показать лодер на загрузке стикеров
    @Published private(set) var isPrepareOjectOperation: Bool = false
    
    
    private var objectPrepareOperations = Cancellables()
    private var storage = Cancellables()
    
    @Published var overlay: CanvasEditorToolsForTemplateViewModel = .init()

    init() {
        observe(nested: self.overlay).store(in: &storage)
        
        $layerInManipulation
            .removeDuplicates()
            .combineLatest(overlay.$isAnyViewOpen)
            .sink(on: .main, object: self) { wSelf, result  in
                let layerInManipulation = result.0
                guard let value = layerInManipulation else { return }
                if value is CanvasTemplateModel {
                    wSelf.openLayersList(false)
                    return
                }
                
                wSelf.overlay.hideAllOverlayViews()
                wSelf.openLayersList(false)
                wSelf.hideAllTools()
            }
            .store(in: &storage)
        
        // Если закрываем наши менюхи
        // то надо обрывать операции загрузки(если они в процессе)
        $currentToolItem.combineLatest($showAddItemSelector)
            .map { $0.0 == .empty && $0.1 == false }
            .removeDuplicates()
            .sink(on: .main, object: self) { wSelf, value in
                if value {
                    wSelf.objectPrepareOperations.cancelAll()
                    wSelf.setPrepareOjectOperation(false)
                }
            }
            .store(in: &storage)
        
        $currentToolItem.combineLatest(overlay.$isAnyViewOpen)
            .sink(on: .main, object: self) { (wSelf, result) in
                let currentToolItem = result.0
                let isAnyViewOpen = result.1
                if currentToolItem != .empty {
                    wSelf.openLayersList(false)
                    wSelf.disableLayersAndAddNewItem(true)
                } else {
                    if isAnyViewOpen { return }
                    wSelf.disableLayersAndAddNewItem(false)
                }
            }
            .store(in: &storage)
    
        overlay
            .$isAnyViewOpen
            .removeDuplicates()
            .sink(on: .main, object: self) { wSelf, value in
                if value {
                    wSelf.closeTools(false)
                    wSelf.disableLayersAndAddNewItem(true)
                } else {
                    wSelf.disableLayersAndAddNewItem(false)
                }
            }
            .store(in: &storage)
    }

    // Открытие сразу редактирования для определенных элементов
    @discardableResult
    func tryToEdit(_ item: CanvasItemModel) -> Bool {
        if item is CanvasTextModel {
            let item: CanvasTextModel = CanvasItemModel.toType(model: item)
            seletedTool(.text(item))
            return true
        }
        return false
    }
    
    func hideAllTools() {
        switch currentToolItem {
        case .concreteItem: return
        default: seletedTool(.empty)
        }
    }

    // Oбнуление или показ конкретныз тулзов
    func seletedTool(_ tool: ToolItem) {
        guard tool != currentToolItem else { return }

        if tool != .empty  { set(showAddItemSelector: false) }
        set(currentToolItem: tool)
        makeHaptics()
    }

    // Показ всех возможных тулзов
    // Общий список
    func showAddItemSelector(_ value: Bool) {
        guard value != showAddItemSelector else { return }
        set(currentToolItem: .empty)
        set(showAddItemSelector: value)
        makeHaptics()
    }
    
    func openLayersList(_ value: Bool) {
        guard openLayersList != value else { return }
        set(openLayersList: value)
        makeHaptics()
    }
    
    func closeTools(_ showLayerMenu: Bool = true) {
        showAddItemSelector(false)
        set(currentToolItem: .empty)
        openLayersList(showLayerMenu)
    }
    
    func currentCloseActionFor(_ item: CanvasItemModel) {
        showAddItemSelector(false)
        openLayersList(false)
        seletedTool(.concreteItem(item))
    }
    
    func disableLayersAndAddNewItem(_ value: Bool) {
        withAnimation(.interactiveSpring()) {
            layersAndAddNewItemIsVisible = value ? false : true
        }
    }
    
    private func set(showAddItemSelector: Bool) {
        withAnimation(.interactiveSpring()) {
            self.showAddItemSelector = showAddItemSelector
        }
    }
    
    private func set(currentToolItem: ToolItem) {
        withAnimation(.interactiveSpring()) {
            self.currentToolItem = currentToolItem
        }
    }
    
    private func set(openLayersList: Bool) {
        withAnimation(.interactiveSpring()) {
            self.openLayersList = openLayersList
        }
    }
}

// MARK: - Helpers
extension CanvasToolsViewModel {
    // Если есть текущий слой в режиме модификации
    // (закрывать управление некторомыми элементами)
    private var currentCanvasItemInEditMode: CanvasItemModel? {
        guard case .concreteItem(let canvasItem) = currentToolItem else {
            return nil
        }
        return canvasItem
    }

    func inEditMode(item: CanvasItemModel) -> Bool {
        guard let id = currentCanvasItemInEditMode?.id else { return true }
        return item.id == id
    }
    
    func isItemInSelection(item: CanvasItemModel) -> Bool {
        guard let id = currentCanvasItemInEditMode?.id else { return false }
        return item.id == id
    }

    func needDisableIfNotCurrent(item: CanvasItemModel) -> Bool {
        guard let id = currentCanvasItemInEditMode?.id else { return false }
        return item.id != id
    }
}

// MARK: - Async operation
// Кажется, что это костыльное место (но работает - не трогай)
extension CanvasToolsViewModel {
    func setPrepareOjectOperation(_ value: Bool) {
        guard value != isPrepareOjectOperation else { return }
        isPrepareOjectOperation = value
        makeHaptics()
    }

    @MainActor
    func stickerPreparation(_ stickerItem: StickerItem?,
                            completion: @escaping (UIImage?) -> Void) {

        guard let item = stickerItem else { return }

        setPrepareOjectOperation(true)

        Future {
            try await ImageCache.default.retrieveImage(
                downloadAndStoreIfNeededFrom: item.url,
                forKey: item.url.absoluteString)
        }
        .replaceError(with: nil)
        .sink(on: .main, object: self) { wSelf, value in
            wSelf.setPrepareOjectOperation(false)
            if wSelf.currentToolItem == .stickers {
                completion(value?.image)
            }
        }
        .store(in: &objectPrepareOperations)
    }
}

// MARK: - Handle drag and drop
extension CanvasToolsViewModel {
    func handle(_ item: CanvasItemModel) {
        switch item.type {
        case .text:
            let textItem: CanvasTextModel = CanvasItemModel.toType(model: item)
            showAddItemSelector(false)
            openLayersList(false)
            seletedTool(.text(textItem))
        default: break
        }
    }
}
