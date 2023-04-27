//
//  CanvasEditorOverlayViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 22.02.2023.
//

import Foundation
import Combine
import SwiftUI


protocol CanvasEditorDelegate: AnyObject {
    // Select media from camera rall
    var pickSelector: ((PickerMediaOutput?) -> Void)? { get set }
    func showMediaPicker()
    func hideMediaPicker()

    // Edit media
    func showMediaEditor(item: CanvasItemModel)
    
    // Edit text
    var editText: ((CanvasTextModel) -> Void)? { get set }
    var deleteItem: ((CanvasItemModel?) -> Void)? { get set }
    var endWorkWithItem: (() -> Void)? { get set }
    func showTextEditor(item: CanvasTextModel)
    func hideAllOverlayViews()
}

final class CanvasEditorToolsForTemplateViewModel: ObservableObject, CanvasEditorDelegate {
    @Injected private var settings: VDEVMediaEditorSettings
    
    var baseChallengeId: String { settings.baseChallengeId }
    
    @Published var state: State = .empty
    @Published var showPhotoPicker: Bool = false
    @Published var showVideoPicker: Bool = false
    @Published private(set) var isAnyViewOpen: Bool = false

    private var storage: Set<AnyCancellable> = Set()
    

    init() {
        // Если у на вообще, что либо открыто на оверлее
        Publishers.CombineLatest3($showPhotoPicker, $showVideoPicker, $state)
            .map {
                $0 == true || $1 == true || $2 != .empty
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.isAnyViewOpen = $0
            }
            .store(in: &storage)
    }

    //MARK: - CanvasEditorDelegate
    
    var endWorkWithItem: (() -> Void)?
    
    func hideAllOverlayViews() {
        if state != .empty { set(.empty) }
    }
    
    // MARK: - Pick image
    var pickSelector: ((PickerMediaOutput?) -> Void)?

    func showMediaPicker() {
        hideAllOverlayViews()
        if state != .mediaPick { set(.mediaPick) }
    }

    func hideMediaPicker() { hideAllOverlayViews() }

    // MARK: - Image/Video filters adjustment image
  
    var deleteItem: ((CanvasItemModel?) -> Void)?
    
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
    
    // MARK: - Edit text
    var editText: ((CanvasTextModel) -> Void)?
    
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
}
