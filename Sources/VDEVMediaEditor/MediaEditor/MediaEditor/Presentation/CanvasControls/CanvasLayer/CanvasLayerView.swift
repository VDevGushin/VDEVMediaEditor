//
//  CanvasLayerView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 08.02.2023.
//

import SwiftUI
import Combine

private final class CanvasLayerViewModel: ObservableObject {
    @Published var offset: CGSize = .zero
    @Published var scale: CGFloat = 1
    @Published var rotation: Angle = .zero
    
    unowned let item: CanvasItemModel
    weak var memento: MementoObject? // for save state
    
    private(set) var manipulationWatcher: ManipulationWatcher = .shared
    private var operation: AnyCancellable?
    private var watcherOperation: AnyCancellable?
    
    init(item: CanvasItemModel, memento: MementoObject) {
        self.item = item
        self.offset = item.offset
        self.scale = item.scale
        self.rotation = item.rotation
        self.memento = memento
        
        operation = Publishers.CombineLatest3($offset.removeDuplicates(),
                                              $scale.removeDuplicates(),
                                              $rotation.removeDuplicates())
        .sink(on: .main, object: self) { wSelf, result in
            let offset = result.0
            let scale = result.1
            let rotation = result.2
            wSelf.item.update(offset: offset, scale: scale, rotation: rotation)
        }
    }
    
    // фактический размер итема на канвасе(для комбайна видосов)
    // расчитывается конда на конве двигаем/крутим/скейлим
    func updateSize(_ frameSize: CGSize) {
        item.update(frameFetchedSize: frameSize)
    }
    
    deinit {
        manipulationWatcher.removeManipulated()
        operation = nil
        Log.d("❌ Deinit: CanvasLayerViewModel")
    }
    
    func mementoSave() {
        guard item.type != .template else { return }
        self.memento?.forceSave()
    }
}

struct CanvasLayerView<Content: View>: View {
    @Environment(\.guideLinesColor) private var guideLinesColor
    @StateObject private var vm: CanvasLayerViewModel
    
    private unowned var toolsModel: CanvasToolsViewModel
    private unowned var dataModel: CanvasLayersDataViewModel
    
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
    @State private var phase = 0.0 // for border animation
    // фактический размер итема на канвасе(для комбайна видосов)
    // расчитывается конда на конве двигаем/крутим/скейлим
    @State private var size: CGSize = .zero
    @State private var isCurrentInManipulation: Bool = true
    @State private var tapScaleFactor: CGFloat = 1.0
    
    init(item: CanvasItemModel,
         toolsModel: CanvasToolsViewModel,
         dataModel: CanvasLayersDataViewModel,
         @ViewBuilder content: @escaping () -> Content,
         onSelect: ((CanvasItemModel) -> Void)? = nil,
         onDelete: ((CanvasItemModel) -> Void)? = nil,
         onShowCenterV: ((Bool) -> Void)? = nil,
         onShowCenterH: ((Bool) -> Void)? = nil,
         onManipulated: ((CanvasItemModel) -> Void)? = nil,
         onEndManipulated: ((CanvasItemModel) -> Void)? = nil,
         onEdit: ((CanvasItemModel) -> Void)? = nil) {
        self.toolsModel = toolsModel
        self.dataModel = dataModel
        self.onSelect = onSelect
        self.onDelete = onDelete
        self.onShowCenterV = onShowCenterV
        self.onShowCenterH = onShowCenterH
        self.onManipulated = onManipulated
        self.onEndManipulated = onEndManipulated
        self.onEdit = onEdit
        self.content = content
        self._vm = .init(wrappedValue: .init(item: item, memento: dataModel))
    }
    
    var body: some View {
        GeometryReader {
            GestureOverlay(
                offset: $vm.offset,
                scale: $vm.scale,
                rotation: $vm.rotation,
                gestureInProgress: $gestureInProgress,
                isHorizontalOrientation: $isHorizontalOrientation,
                isVerticalOrientation: $isVerticalOrientation,
                isCenterVertical: $isCenterVertical,
                isCenterHorizontal: $isCenterHorizontal,
                tapScaleFactor: $tapScaleFactor,
                itemType: vm.item.type) {
                    content()
                } onLongPress: {
                } onDoubleTap: {
                    onSelect?(vm.item)
                    haptics(.light)
                } onTap: {
                    onEdit?(vm.item)
                    haptics(.light)
                } canManipulate: { canManipulate }
                .overlay(content: HorizontOverlay)
                .background(selectionColor)
                .border(guideLinesColor.opacity(0.5),
                        width: borderType.border(scale: vm.scale))
                .overlay(
                    SelectionView(
                        scale: $vm.scale,
                        borderType: borderType,
                        guideLinesColor: guideLinesColor
                    )
                )
                .scaleEffect(vm.scale)
                .rotationEffect(vm.rotation)
                .offset(vm.offset)
                .disabled(!canManipulate)
                .allowsHitTesting(canManipulate)
                .opacity(itemOpacity)
                .blur(radius: itemBlur)
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
                .onChange(of: isVerticalOrientation) {
                    value in if value { haptics(.light) }
                }
                .onChange(of: isHorizontalOrientation) {
                    value in if value { haptics(.light) }
                }
                .onChange(of: gestureInProgress) { newValue in
                    switch newValue {
                    case true:
                        vm.manipulationWatcher.setManipulated(item: vm.item)
                        onManipulated?(vm.item)
                        vm.mementoSave()
                    case false:
                        vm.manipulationWatcher.removeManipulated()
                        onEndManipulated?(vm.item)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isHorizontalOrientation = false
                            isVerticalOrientation = false
                            onShowCenterV?(false)
                            onShowCenterH?(false)
                        }
                    }
                }
                .onChange(of: size) { value in
                    vm.updateSize(value)
                }
                .frame(width: $0.size.width, height: $0.size.height)
        }
        .onReceive(vm.manipulationWatcher.current) { value in
            //Если еще не было манипуляций ни с одним элементом нам надо разрешить действие
            guard let value = value else { return isCurrentInManipulation = true }
            isCurrentInManipulation = value == vm.item
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
                    .frame(width: 1 / vm.scale)
                    .frame(maxHeight: .infinity)
            }
            
           if isVerticalOrientation {
                Rectangle()
                    .foregroundColor(guideLinesColor.opacity(0.6))
                    .frame(height:  1 / vm.scale)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
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

// MARK: - Props
fileprivate extension CanvasLayerView {
    @ViewBuilder
    var selectionColor: some View {
        if vm.item.type == .template { EmptyView() }
        if toolsModel.isItemInSelection(item: vm.item) {
            AnimatedGradientView(color: guideLinesColor.opacity(0.1))
        }
        if !isCurrentInManipulation { EmptyView() }
        if gestureInProgress {
            AnimatedGradientView(color: guideLinesColor.opacity(0.2))
        } else {
            EmptyView()
        }
    }
    
    var borderType: BorderType {
        if vm.item.type == .template { return .empty }
        if toolsModel.isItemInSelection(item: vm.item) { return .selected }
        if !isCurrentInManipulation { return .empty }
        return gestureInProgress ? .manipulated : .empty
    }
    
    var canManipulate: Bool {
        if toolsModel.overlay.isAnyViewOpen {
            return vm.item is CanvasTemplateModel
        }
        return isCurrentInManipulation && toolsModel.inEditMode(item: vm.item)
    }
    
    var itemBlur: CGFloat {
        let maxBlur: CGFloat = 0.0
        let minBlur: CGFloat = 2
        let superMinBlur: CGFloat = 20
        // Если открыто любое меню операций над шаблонами
        if toolsModel.overlay.isAnyViewOpen {
            return vm.item is CanvasTemplateModel ? maxBlur : minBlur
        }
        // Если это не текущий выбранный элемент
        if !toolsModel.inEditMode(item: vm.item) { return superMinBlur }
        // Если это шаблон
        if vm.item is CanvasTemplateModel { return maxBlur }
        // Проверка на возможность применить свойство опасити
        if vm.manipulationWatcher
            .regectOpacityWith(dataModel: dataModel, for: vm.item) {
            return maxBlur
        }
        
        return isCurrentInManipulation ? maxBlur : minBlur
    }
    
    var itemOpacity: CGFloat {
        let maxOpacity: CGFloat = 1.0
        let minOpacity: CGFloat = 0.6
        let superMinOpacity: CGFloat = 0.2
        // Если открыто любое меню операций над шаблонами
        if toolsModel.overlay.isAnyViewOpen {
            return vm.item is CanvasTemplateModel ? maxOpacity : minOpacity
        }
        // Если это не текущий выбранный элемент
        if !toolsModel.inEditMode(item: vm.item) { return superMinOpacity }
        // Если это шаблон
        if vm.item is CanvasTemplateModel { return maxOpacity }
        // Проверка на возможность применить свойство опасити
        if vm.manipulationWatcher
            .regectOpacityWith(dataModel: dataModel, for: vm.item) {
            return maxOpacity
        }
        return isCurrentInManipulation ? maxOpacity : minOpacity
    }
}

// MARK: - ManipulationWatcher
// Следим, чтобы объект манипуляции был только один
private final class ManipulationWatcher: ObservableObject {
    var current: AnyPublisher<CanvasItemModel?, Never> {
        _current
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private var _current = CurrentValueSubject<CanvasItemModel?, Never>(nil)
    private init() { }
    
    static let shared = ManipulationWatcher()
    
    func setManipulated(item: CanvasItemModel) {
        _current.send(item)
    }
    
    func removeManipulated() {
        _current.send(nil)
    }
    
    func regectOpacityWith(dataModel: CanvasLayersDataViewModel,
                           for item: CanvasItemModel) -> Bool {
        dataModel.rejectOpacityProperty(itemInCanvas: item, itemInManipulation: _current.value)
    }
}
// MARK: - Helps

fileprivate enum BorderType: Equatable, Identifiable {
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
    
    static func == (
        lhs: BorderType,
        rhs: BorderType
    ) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: Int {
        switch self {
        case .empty:
            return 0
        case .selected:
            return 1
        case .manipulated:
            return 2
        }
    }
}

fileprivate struct SelectionView: View {
    @Binding private var scale: CGFloat
    @State private var phase = 0.0
    private var borderType: BorderType
    private var guideLinesColor: Color
    
    init(
        scale: Binding<CGFloat>,
        borderType: BorderType,
        guideLinesColor: Color
    ) {
        self._scale = scale
        self.borderType = borderType
        self.guideLinesColor = guideLinesColor
        self.phase = phase
    }
    
    var body: some View {
        if case .selected = borderType {
            Rectangle()
                .inset(
                    by: -borderType.borderOverlay(scale: scale)
                )
                .stroke(
                    guideLinesColor.opacity(0.8),
                    style: StrokeStyle(
                        lineWidth: borderType.borderOverlay(scale: scale),
                        lineCap: .round,
                        lineJoin: .round,
                        dash: [10, 10],
                        dashPhase: phase)
                )
                .animation(
                    Animation
                        .linear(duration: 15)
                        .repeatForever(autoreverses: true),
                    value: phase)
                .onAppear {
                    phase -= 100
                }
        }
    }
}

