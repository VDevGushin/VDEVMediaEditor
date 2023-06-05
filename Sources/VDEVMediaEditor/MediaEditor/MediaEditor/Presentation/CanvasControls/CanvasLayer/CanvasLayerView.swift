//
//  CanvasLayerView1.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 08.02.2023.
//

import SwiftUI
import Combine

struct CanvasLayerPreview<Content: View>: View {
    private let content: (CanvasItemModel) -> Content
    private let item: CanvasItemModel
    
    init(item: CanvasItemModel,
         @ViewBuilder content: @escaping (CanvasItemModel) -> Content) {
        self.item = item
        self.content = content
    }
    
    var body: some View { content(item) }
}

private final class CanvasLayerViewModel: ObservableObject {
    unowned let item: CanvasItemModel
    @Published var offset: CGSize = .zero
    @Published var scale: CGFloat = 1
    @Published var rotation: Angle = .zero
    @Published var anchor: UnitPoint = .center
    
    private(set) var manipulationWatcher: ManipulationWatcher = .shared
    
    private var operation: AnyCancellable?
    private var watcherOperation: AnyCancellable?
    
    init(item: CanvasItemModel) {
        self.item = item
        self.offset = item.offset
        self.scale = item.scale
        self.rotation = item.rotation
        
        operation = Publishers.CombineLatest3($offset.removeDuplicates(),
                                              $scale.removeDuplicates(),
                                              $rotation.removeDuplicates())
        .receive(on: DispatchQueue.main)
        .sink { [weak self] offset, scale, rotation in
            self?.item.update(offset: offset, scale: scale, rotation: rotation)
        }
    }
    
    // фактический размер итема на канвасе(для комбайна видосов)
    // расчитывается конда на конве двигаем/крутим/скейлим
    func updateSize(_ frameSize: CGSize) {
        Log.d("Frame size: \(frameSize)")
        item.update(frameFetchedSize: frameSize)
    }
    
    deinit {
        manipulationWatcher.clear()
        operation = nil
        Log.d("❌ Deinit: CanvasLayerViewModel")
    }
}

struct CanvasLayerView<Content: View>: View {
    @Environment(\.guideLinesColor) private var guideLinesColor
    @StateObject private var vm: CanvasLayerViewModel
    
    @EnvironmentObject private var editorVM: CanvasEditorViewModel
    
    private let content: () -> Content
    
    // Callbacks
    private var onSelect: ((CanvasItemModel) -> Void)?
    private var onEdit: ((CanvasItemModel) -> Void)?
    private var onDelete: ((CanvasItemModel) -> Void)?
    private var onShowCenterV: ((Bool) -> Void)?
    private var onShowCenterH: ((Bool) -> Void)?
    private var onManipulated: ((CanvasItemModel) -> Void)?
    private var onEndManipulated: ((CanvasItemModel) -> Void)?
    
    @State private var gestureInProgress: Bool = false
    @State private var isHorizontalOrientation = false
    @State private var isVerticalOrientation = false
    @State private var isCenterVertical = false
    @State private var isCenterHorizontal = false
    @State private var isLongTap: Bool = false
    @State private var phase = 0.0 // for border animation
    
    // фактический размер итема на канвасе(для комбайна видосов)
    // расчитывается конда на конве двигаем/крутим/скейлим
    @State private var size: CGSize = .zero
    @State private var isCurrentInManipulation: Bool = true
    
    @State private var tapScaleFactor: CGFloat = 1.0
    // Детектим малейшее нажатие на глобальный контейнер
    @Binding private var contanerTouchLocation: ParentTouchResult
    @Binding private var containerSize: CGSize
    
    @ViewBuilder
    private var selectionColor: some View {
        if vm.item.type == .template { EmptyView() }
        
        if editorVM.tools.isItemInSelection(item: vm.item) {
            AnimatedGradientView(color: guideLinesColor.opacity(0.2))
        }
        
        if !isCurrentInManipulation { EmptyView() }
        
        if (gestureInProgress || isLongTap) {
            AnimatedGradientView(color: guideLinesColor.opacity(0.3))
        } else {
            EmptyView()
        }
    }
    
    private var borderType: BorderType {
        if vm.item.type == .template { return .empty }
        
        if editorVM.tools.isItemInSelection(item: vm.item) {
            return .selected
        }
        
        if !isCurrentInManipulation { return .empty }
        
        return (gestureInProgress || isLongTap) ? .manipulated : .empty
    }
    
    private var canManipulate: Bool {
        if editorVM.tools.overlay.isAnyViewOpen { return vm.item is CanvasTemplateModel }
        return editorVM.tools.isCurrent(item: vm.item) && isCurrentInManipulation
    }
    
    private var itemOpacity: CGFloat {
        let maxOpacity: CGFloat = 1.0
        let minOpacity: CGFloat = 0.6
        let superMinOpacity: CGFloat = 0.2
        
        // Если открыто любое меню операций над шаблонами
        if editorVM.tools.overlay.isAnyViewOpen {
            return vm.item is CanvasTemplateModel ? maxOpacity : minOpacity
        }
        
        // Если это не текущий выбранный элемент
        if !editorVM.tools.isCurrent(item: vm.item) { return superMinOpacity }
        
        // Если это шаблон
        if vm.item is CanvasTemplateModel { return maxOpacity }
        
        // Проверка на возможность применить свойство опасити
        if vm.manipulationWatcher
            .regectOpacityWith(dataModel: editorVM.data,
                               for: vm.item) {
            return maxOpacity
        }
        
        return isCurrentInManipulation ? maxOpacity : minOpacity
    }
    
    init(item: CanvasItemModel,
         contanerTouchLocation: Binding<ParentTouchResult>,
         containerSize: Binding<CGSize>,
         @ViewBuilder content: @escaping () -> Content,
         onSelect: ((CanvasItemModel) -> Void)? = nil,
         onDelete: ((CanvasItemModel) -> Void)? = nil,
         onShowCenterV: ((Bool) -> Void)? = nil,
         onShowCenterH: ((Bool) -> Void)? = nil,
         onManipulated: ((CanvasItemModel) -> Void)? = nil,
         onEndManipulated: ((CanvasItemModel) -> Void)? = nil,
         onEdit: ((CanvasItemModel) -> Void)? = nil) {
        self._contanerTouchLocation = contanerTouchLocation
        self._containerSize = containerSize
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.onShowCenterV = onShowCenterV
        self.onShowCenterH = onShowCenterH
        self.onManipulated = onManipulated
        self.onEndManipulated = onEndManipulated
        self.onEdit = onEdit
        self.content = content
        self._vm = .init(wrappedValue: .init(item: item))
    }
    
    var body: some View {
        GeometryReader {
            GestureOverlay(
                offset: $vm.offset,
                scale: $vm.scale,
                anchor: $vm.anchor,
                rotation: $vm.rotation,
                gestureInProgress: $gestureInProgress,
                isHorizontalOrientation: $isHorizontalOrientation,
                isVerticalOrientation: $isVerticalOrientation,
                isCenterVertical: $isCenterVertical,
                isCenterHorizontal: $isCenterHorizontal,
                tapScaleFactor: $tapScaleFactor,
                contanerTouchLocation: $contanerTouchLocation,
                containerSize: $containerSize,
                itemType: vm.item.type) {
                    content()
                } onLongPress: {
                    // Long tap
                } onDoubleTap: {
                    onSelect?(vm.item)
                    haptics(.light)
                } onTap: {
                    onEdit?(vm.item)
                    haptics(.light)
                } canManipulate: { canManipulate }
                .overlay(content: HorizontOverlay)
                .background(selectionColor)
                .border(guideLinesColor.opacity(0.9), width: borderType.border(scale: vm.scale))
                .overlay(selectionOverlay)
                .scaleEffect(vm.scale)
                .rotationEffect(vm.rotation)
                .offset(vm.offset)
                .disabled(!canManipulate)
                .allowsHitTesting(canManipulate)
                .opacity(itemOpacity)
                .fetchSize($size)
                .onChange(of: isCenterVertical) { value in
                    if value {
                        onShowCenterV?(true)
                        haptics(.light)
                    }else {
                        onShowCenterV?(false)
                    }
                }
                .onChange(of: isCenterHorizontal) { value in
                    if value {
                        onShowCenterH?(true)
                        haptics(.light)
                    } else {
                        onShowCenterH?(false)
                    }
                }
                .onChange(of: isVerticalOrientation) { value in
                    if value { haptics(.light) }
                }
                .onChange(of: isHorizontalOrientation) { value in
                    if value { haptics(.light) }
                }
                .onChange(of: gestureInProgress) { newValue in
                    if !newValue {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isHorizontalOrientation = false
                            isVerticalOrientation = false
                            onShowCenterV?(false)
                            onShowCenterH?(false)
                        }
                    }
                    
                    if newValue {
                        vm.manipulationWatcher.setManipulated(item: vm.item)
                        onManipulated?(vm.item)
                    } else {
                        vm.manipulationWatcher.removeManipulated(item: vm.item)
                        onEndManipulated?(vm.item)
                    }
                }
                .onChange(of: size) { value in vm.updateSize(value) }
                .frame($0.size)
        }
        .onReceive(vm.manipulationWatcher.$current.removeDuplicates()) { value in
            //Если еще не было манипуляций ни с одним элементом нам надо разрешить действие
            guard let value = value else { return isCurrentInManipulation = true }
            
            if value.id == vm.item.id {
                isCurrentInManipulation = true
            } else {
                isCurrentInManipulation = false
                gestureInProgress = false
            }
        }
    }
}

fileprivate extension CanvasLayerView {
    @ViewBuilder
    func HorizontOverlay() -> some View {
        ZStack {
            if isHorizontalOrientation {
                Rectangle()
                    .foregroundColor(guideLinesColor.opacity(0.6))
                    .frame(width:  1 / vm.scale)
                    .frame(maxHeight: .infinity)
            }
            
            if isVerticalOrientation {
                Rectangle()
                    .foregroundColor(guideLinesColor.opacity(0.6))
                    .frame(height:  1 / vm.scale)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}

fileprivate extension CanvasLayerView {
    func resetAll() {
        withAnimation(.interactiveSpring()) {
            vm.offset = .zero
            vm.rotation = .zero
            vm.scale = 1
        }
    }
    
    func resetCenter() { withAnimation(.interactiveSpring()) { vm.offset = .zero } }
}

fileprivate extension CanvasLayerView {
    enum BorderType {
        case empty
        case selected
        case manipulated
        
        func border(scale: CGFloat) -> CGFloat {
            switch self {
            case .manipulated: return 1 / scale
            default: return 0.0
            }
        }
        
        func borderOverlay(scale: CGFloat) -> CGFloat {
            switch self {
            case .selected: return 1 / scale
            default: return 0.0
            }
        }
    }
    
    @ViewBuilder
    var selectionOverlay: some View {
        switch borderType {
        case .selected:
            Rectangle()
                .inset(by: -borderType.borderOverlay(scale: vm.scale))
                .stroke(guideLinesColor.opacity(0.8), style:
                            StrokeStyle(lineWidth: borderType.borderOverlay(scale: vm.scale),
                                        lineCap: .round,
                                        lineJoin: .round,
                                        dash: [10, 10],
                                        dashPhase: phase)
                )
                .animation(
                    Animation.linear(duration: 15)
                        .repeatForever(autoreverses: true),
                    value: phase)
                .onAppear {
                    phase -= 100
                }
        default: EmptyView()
        }
    }
}

// MARK: - ManipulationWatcher
// Следим, чтобы объект манипуляции был только один
final class ManipulationWatcher: ObservableObject {
    @Published private(set) var current: CanvasItemModel?
    
    private init() { }
    
    static let shared = ManipulationWatcher()
    
    func setManipulated(item: CanvasItemModel) { if current == nil { current = item } }
    
    func removeManipulated(item: CanvasItemModel) { if isSame(item) { current = nil } }
    
    func clear() { current = nil }
    
    func regectOpacityWith(dataModel: CanvasLayersDataViewModel,
                           for item: CanvasItemModel) -> Bool {
        dataModel.rejectOpacityProperty(itemInCanvas: item, itemInManipulation: current)
    }
    
    private func isSame(_ item: CanvasItemModel?) -> Bool { current?.id == item?.id }
}
