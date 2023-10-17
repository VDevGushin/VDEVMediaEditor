//
//  CanvasEditorOverlayViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 22.02.2023.
//

import Foundation
import Combine
import SwiftUI

//Select media from camera rall
protocol CanvasEditorSelectMediaFromMediaPickerForTemplate {
    // Select media from camera rall
    var pickSelector: ((PickerMediaOutput?) -> Void)? { get set }
    func showMediaPicker(workWithNeural: Bool)
    func hideMediaPicker()
}

// Variants for edit for template object
protocol CanvasEditorEditVariantsForTemplate {
    // Edit media
    var endWorkWithItem: (() -> Void)? { get set }
    var deleteItem: ((CanvasItemModel?) -> Void)? { get set }
    var changeSound: ((CanvasVideoPlaceholderModel, Float) -> Void)? { get set }
    func showMediaEditor(item: CanvasItemModel)
}

// Work with text
protocol CanvasEditorWorkWithTextForTemplate {
    var editText: ((CanvasTextModel) -> Void)? { get set }
    func showTextEditor(item: CanvasTextModel)
}

protocol CanvasEditorDelegate: AnyObject,
                               CanvasEditorSelectMediaFromMediaPickerForTemplate,
                               CanvasEditorEditVariantsForTemplate,
                               CanvasEditorWorkWithTextForTemplate{
    func hideAllOverlayViews()
}

final class CanvasEditorToolsForTemplateViewModel:
    ObservableObject, CanvasEditorDelegate {
    
    @Injected private var settings: VDEVMediaEditorSettings
    @Injected private var pasteboardService: PasteboardService
    
    @Published var state: State = .empty
    @Published var showMediaPicker: PhotoPickerType? = nil
    @Published private(set) var isAnyViewOpen: Bool = false
    
    var baseChallengeId: String { settings.resourceID }
    var endWorkWithItem: (() -> Void)?
    var pickSelector: ((PickerMediaOutput?) -> Void)?
    var deleteItem: ((CanvasItemModel?) -> Void)?
    var changeSound: ((CanvasVideoPlaceholderModel, Float) -> Void)?
    var editText: ((CanvasTextModel) -> Void)?
    
    private var storage = Cancellables()
    
    init() {
        Publishers.CombineLatest(
            $showMediaPicker,
            $state
        ).map { ($0 != nil || $1 != .empty) }
        .receiveOnMain()
        .sink(
            on: .main,
            object: self
        ) { wSelf, value in
            wSelf.isAnyViewOpen = value
        }
        .store(in: &storage)
    }
    
    func hideAllOverlayViews() {
        if state != .empty { set(.empty) }
    }
    
    func showMediaPicker(workWithNeural: Bool) {
        hideAllOverlayViews()
        switch state {
        case .mediaPick: break
        default:
            // Если нужна работа с AI необходимо оригинал картинки
            guard !workWithNeural else {
                endWorkWithItem?()
                set(showMediaPicker: .neural)
                return
            }
            
            // Если нет ничего для вставки (работает только с картинками)
            guard pasteboardService.canPasteImage else {
                endWorkWithItem?()
                set(showMediaPicker: .compressed)
                return
            }
            
            // Показываем стандартный список [выбрать фото/видео, вставить картинку]
            hideMediaPicker()
            set(.mediaPick)
        }
    }
    
    func hideMediaPicker() {
        hideAllOverlayViews()
        endWorkWithItem?()
    }
    
    func onDeleteItem(item: CanvasItemModel) {
        hideAllOverlayViews()
        deleteItem?(item)
    }
    
    func showMediaEditor(item: CanvasItemModel) {
        hideAllOverlayViews()
        if state.id != 2 { set(.editVariants(item: item)) }
    }
    
    func showAdjustments(item: CanvasItemModel) {
        hideAllOverlayViews()
        if state.id != 3 { set(.adjustments(item: item)) }
    }
    
    func showTexture(item: CanvasItemModel) {
        hideAllOverlayViews()
        if state.id != 4 { set(.texture(item: item)) }
    }
    
    func showFilters(item: CanvasItemModel) {
        hideAllOverlayViews()
        if state.id != 5 { set(.filter(item: item)) }
    }
    
    func set(showMediaPicker value: PhotoPickerType?) {
        if self.showMediaPicker != value {
            showMediaPicker = value
        }
    }
    
    func onChangeSound(for model: CanvasVideoPlaceholderModel, value: Float) {
        hideAllOverlayViews()
        changeSound?(model, value)
    }
    
    func showTextEditor(item: CanvasTextModel) {
        hideAllOverlayViews()
        if state.id != 6 { set(.editText(item: item)) }
    }
    
    private func set(_ state: State) {
        withAnimation(.interactiveSpring()) {
            self.state = state
        }
    }
}

extension CanvasEditorToolsForTemplateViewModel {
    enum State: Equatable, Hashable {
        case empty
        case mediaPick
        case editVariants(item: CanvasItemModel)
        case adjustments(item: CanvasItemModel)
        case texture(item: CanvasItemModel)
        case filter(item: CanvasItemModel)
        case editText(item: CanvasTextModel)
        
        var id: Int {
            switch self {
            case .empty: return 0
            case .mediaPick: return 1
            case .editVariants: return 2
            case .adjustments: return 3
            case .texture: return 4
            case .filter: return 5
            case .editText: return 6
            }
        }
        
        static func == (lhs: State, rhs: State) -> Bool { lhs.id == rhs.id }
        
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
    }
    
    enum PhotoPickerType: Int, Identifiable, Equatable, Hashable {
        case neural = 0 // work with media and neural
        case compressed = 1 // default work with media
        
        var id: Int {
            self.rawValue
        }
        
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
    }
}