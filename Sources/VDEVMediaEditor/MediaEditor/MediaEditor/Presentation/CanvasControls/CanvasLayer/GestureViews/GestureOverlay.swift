//
//  GestureOverlay.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 07.02.2023.
//

import SwiftUI
import SwiftUIX

@MainActor
struct GestureOverlay<Content: View>: UIViewRepresentable {
    @Binding var offset: CGSize
    @Binding var scale: CGFloat
    @Binding var rotation: Angle
    @Binding var gestureInProgress: Bool
    @Binding var isHorizontalOrientation: Bool
    @Binding var isVerticalOrientation: Bool
    @Binding var isCenterVertical: Bool
    @Binding var isCenterHorizontal: Bool
    @Binding var tapScaleFactor: CGFloat
    
    private let content: () -> Content
    
    private(set) var itemType: CanvasItemType
    private(set) var onLongPress: () -> Void
    private(set) var onDoubleTap: () -> Void
    private(set) var onTap: () -> Void
    private(set) var canManipulate: () -> Bool
    
    internal init(offset: Binding<CGSize>,
                  scale: Binding<CGFloat>,
                  rotation: Binding<Angle>,
                  gestureInProgress: Binding<Bool>,
                  isHorizontalOrientation: Binding<Bool>,
                  isVerticalOrientation: Binding<Bool>,
                  isCenterVertical: Binding<Bool>,
                  isCenterHorizontal: Binding<Bool>,
                  tapScaleFactor: Binding<CGFloat>,
                  itemType: CanvasItemType,
                  @ViewBuilder content: @escaping () -> Content,
                  onLongPress: @escaping () -> Void,
                  onDoubleTap: @escaping () -> Void,
                  onTap: @escaping () -> Void,
                  canManipulate: @escaping () -> Bool) {
        
        self._offset = offset
        self.itemType = itemType
        self._tapScaleFactor = tapScaleFactor
        self._scale = scale
        self._rotation = rotation
        self._gestureInProgress = gestureInProgress
        self._isHorizontalOrientation = isHorizontalOrientation
        self._isVerticalOrientation = isVerticalOrientation
        self._isCenterVertical = isCenterVertical
        self._isCenterHorizontal = isCenterHorizontal
        self.onLongPress = onLongPress
        self.onDoubleTap = onDoubleTap
        self.onTap = onTap
        self.canManipulate = canManipulate
        self.content = content
    }
    
    func makeUIView(context: Context) -> _UIHostingView<Content> {
        let hView = _UIHostingView(rootView: content())
        hView.isOpaque = false
        hView.backgroundColor = .clear
        hView.clipsToBounds = true
        hView.shouldResizeToFitContent = true
        
        if itemType != .template {
            setupGest(for: hView, context: context)
        } else {
            setupGestForTemplate(for: hView, context: context)
        }
        
        hView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        hView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return hView
    }
    
    private func setupGestForTemplate(for hView: UIView, context: Context) {
        let LongPressRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPressForTemplate(sender:)))
        LongPressRecognizer.minimumPressDuration = 0.1
        LongPressRecognizer.delaysTouchesBegan = true
        LongPressRecognizer.delegate = context.coordinator
        hView.addGestureRecognizer(LongPressRecognizer)
        
        let Pangesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePanForTemplate(sender:)))
        Pangesture.delegate = context.coordinator
        hView.addGestureRecognizer(Pangesture)
        Pangesture.cancelsTouchesInView = false
        context.coordinator.panGest = Pangesture
        
        let RotationGesture = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleRotateForTemplate(sender:)))
        RotationGesture.delegate = context.coordinator
        hView.addGestureRecognizer(RotationGesture)
        RotationGesture.cancelsTouchesInView = false
        context.coordinator.rotGest = RotationGesture
        
        let Pinchgesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinchForTemplate(sender:)))
        Pinchgesture.delegate = context.coordinator
        hView.addGestureRecognizer(Pinchgesture)
        Pinchgesture.cancelsTouchesInView = false
        context.coordinator.pinchGest = Pinchgesture
        
        context.coordinator.tapGest = nil
        context.coordinator.doubleTapGest = nil
    }
    
    private func setupGest(for hView: UIView, context: Context) {
        let Pangesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(sender:)))
        Pangesture.cancelsTouchesInView = true
        Pangesture.delegate = context.coordinator
        hView.addGestureRecognizer(Pangesture)
        context.coordinator.panGest = Pangesture
        
        let RotationGesture = UIRotationGestureRecognizer(target: context.coordinator, action:     #selector(context.coordinator.handleRotate(sender:)))
        RotationGesture.cancelsTouchesInView = true
        RotationGesture.delegate = context.coordinator
        hView.addGestureRecognizer(RotationGesture)
        context.coordinator.rotGest = RotationGesture
        
        let Pinchgesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
        Pinchgesture.cancelsTouchesInView = true
        Pinchgesture.delegate =  context.coordinator
        hView.addGestureRecognizer(Pinchgesture)
        context.coordinator.pinchGest = Pinchgesture
        
        // Если шаблон, то нам ничего не нужно (просто следим за манипуляциями)
        let TapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(sender:)))
        TapGestureRecognizer.numberOfTapsRequired = 1
        TapGestureRecognizer.delegate = context.coordinator
        hView.addGestureRecognizer(TapGestureRecognizer)
        context.coordinator.tapGest = TapGestureRecognizer
        
        let LongPressRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPress(sender:)))
        LongPressRecognizer.minimumPressDuration = 0.1
        LongPressRecognizer.delaysTouchesBegan = true
        LongPressRecognizer.delegate = context.coordinator
        hView.addGestureRecognizer(LongPressRecognizer)
        context.coordinator.longTapGest = LongPressRecognizer
        
        let DoubleTapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleDoubleTap))
        DoubleTapRecognizer.numberOfTapsRequired = 2
        DoubleTapRecognizer.delegate = context.coordinator
        hView.addGestureRecognizer(DoubleTapRecognizer)
        context.coordinator.doubleTapGest = DoubleTapRecognizer
        
        DoubleTapRecognizer.require(toFail: LongPressRecognizer)
        DoubleTapRecognizer.require(toFail: Pangesture)
        DoubleTapRecognizer.require(toFail: RotationGesture)
        DoubleTapRecognizer.require(toFail: Pinchgesture)
        TapGestureRecognizer.require(toFail: LongPressRecognizer)
        TapGestureRecognizer.require(toFail: DoubleTapRecognizer)
        TapGestureRecognizer.require(toFail: Pangesture)
        TapGestureRecognizer.require(toFail: RotationGesture)
        TapGestureRecognizer.require(toFail: Pinchgesture)
    }
    
    static func dismantleUIView(_ uiView: _UIHostingView<Content>, coordinator: Coordinator<Content>) {
        if let panGest = coordinator.panGest {
            uiView.removeGestureRecognizer(panGest)
        }
        
        if let pinchGest = coordinator.pinchGest {
            uiView.removeGestureRecognizer(pinchGest)
        }
        
        if let rotGest = coordinator.rotGest {
            uiView.removeGestureRecognizer(rotGest)
        }
        
        if let longTapGest = coordinator.longTapGest {
            uiView.removeGestureRecognizer(longTapGest)
        }
        
        if let doubleTapGest = coordinator.doubleTapGest  {
            uiView.removeGestureRecognizer(doubleTapGest)
        }
        
        if let tapGest = coordinator.tapGest {
            uiView.removeGestureRecognizer(tapGest)
        }
        
        uiView.removeFromSuperview()
    }
    
    func updateUIView(_ uiView: _UIHostingView<Content>, context: Context) {
        uiView.rootView = content()
    }
    
    func makeCoordinator() -> Coordinator<Content> {
        Coordinator(parent: self)
    }
    
    @MainActor
    final class Coordinator<Content: View>: NSObject, UIGestureRecognizerDelegate {
        private let animation: Animation = .linear(duration: 0.07)
        private let parent: GestureOverlay
        private var externalScale: CGFloat!
        private var externalRotation: Angle!
        private var lastStoreOffset: CGSize = .zero
        private let centerRange = CGFloat(-5.0)...CGFloat(5.0)
        
        // All gestures
        weak var panGest: UIGestureRecognizer?
        weak var rotGest: UIGestureRecognizer?
        weak var pinchGest: UIGestureRecognizer?
        weak var longTapGest: UILongPressGestureRecognizer?
        weak var doubleTapGest: UITapGestureRecognizer?
        weak var tapGest: UITapGestureRecognizer?
        
        // Gesture status
        private var tapInProgress = false { didSet { updateProgressStateAndSetExternalGestures() } }
        private var longTapInProgress = false { didSet { updateProgressStateAndSetExternalGestures() } }
        private var doubleTapInProgress = false { didSet { updateProgressStateAndSetExternalGestures() } }
        private var panInProgress = false { didSet { updateProgressStateAndSetExternalGestures() } }
        private var rotInProgress = false { didSet { updateProgressStateAndSetExternalGestures() } }
        private var scaleInProgress = false { didSet { updateProgressStateAndSetExternalGestures() } }
        
        private func updateProgressStateAndSetExternalGestures() {
            guard canManipulate() else { return }
            
            let anyGestureInProgress = panInProgress ||
            rotInProgress ||
            scaleInProgress ||
            longTapInProgress ||
            tapInProgress ||
            doubleTapInProgress
            parent.gestureInProgress = anyGestureInProgress
            setupExternalZoom(anyGestureInProgress)
        }
        
        deinit {
            Log.d("❌ Deinit: GestureOverlay.Coordinator")
        }
        
        init(parent: GestureOverlay) {
            self.parent = parent
        }
        
        @objc
        func handleDoubleTap(sender: UITapGestureRecognizer) {
            guard canManipulate() else { return }
            gestureStatus(state: &doubleTapInProgress, sender: sender)
            parent.onDoubleTap()
        }
        
        @objc
        func handleLongPress(sender: UILongPressGestureRecognizer) {
            guard canManipulate() else { return }
            gestureStatus(state: &longTapInProgress, sender: sender)
            parent.onLongPress()
        }
        
        @objc
        func handleTap(sender: UITapGestureRecognizer) {
            guard canManipulate() else { return }
            gestureStatus(state: &tapInProgress, sender: sender)
            parent.onTap()
        }
        
        @objc
        func handlePan(sender: UIPanGestureRecognizer) {
            guard canManipulate() else { return }
            
            guard let piece = sender.view else { return }
            
            gestureStatus(state: &panInProgress, sender: sender)
            
            let translation = sender.translation(in: piece.superview)
            
            if sender.state == .began { lastStoreOffset = parent.offset }
            
            if sender.state != .cancelled {
                let x = translation.x
                let y = translation.y
                let B = parent.rotation.radians
                
                let rotatedX = (CoreGraphics.cos(B) * x) - (sin(B) * y)
                let rotatedY = (CoreGraphics.sin(B) * x) + (cos(B) * y)
                
                var width: CGFloat
                var height: CGFloat
                
                width = lastStoreOffset.width + rotatedX * parent.scale
                height = lastStoreOffset.height + rotatedY * parent.scale
                
                if centerRange.contains(width) {
                    if !scaleInProgress  { width = 0 }
                    parent.isCenterVertical = true
                } else {
                    parent.isCenterVertical = false
                }
                
                if centerRange.contains(height) {
                    if !scaleInProgress  { height = 0 }
                    parent.isCenterHorizontal = true
                } else {
                    parent.isCenterHorizontal = false
                }
                set(offset: CGSize(width: width, height: height))
            } else {
                set(offset: lastStoreOffset)
            }
            if [UIGestureRecognizer.State.ended, .cancelled, .failed].contains(sender.state) {
                panInProgress = false
            }
        }
        
        private func set(offset: CGSize) {
            withAnimation(.interactiveSpring()) {
                guard canManipulate() else { return }
                parent.offset = offset
            }
        }
        
        @objc
        func handlePinch(sender: UIPinchGestureRecognizer) {
            guard canManipulate() else { return }
            gestureStatus(state: &scaleInProgress, sender: sender)
        }
        
        @objc
        func handleRotate(sender: UIRotationGestureRecognizer) {
            guard canManipulate() else { return }
            gestureStatus(state: &rotInProgress, sender: sender)
        }
        
        // MARK: - For template to detect manipulations
        @objc
        func handlePanForTemplate(sender: UIPanGestureRecognizer) {
            guard canManipulate() else { return }
            gestureStatus(state: &panInProgress, sender: sender)
        }
        
        @objc
        func handlePinchForTemplate(sender: UIPinchGestureRecognizer) {
            guard canManipulate() else { return }
            gestureStatus(state: &scaleInProgress, sender: sender)
        }
        
        @objc
        func handleRotateForTemplate(sender: UIRotationGestureRecognizer) {
            guard canManipulate() else { return }
            gestureStatus(state: &rotInProgress, sender: sender)
        }
        
        @objc
        func handleLongPressForTemplate(sender: UILongPressGestureRecognizer) {
            guard canManipulate() else { return }
            gestureStatus(state: &longTapInProgress, sender: sender)
            parent.onLongPress()
        }
        
        public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}

// MARK: - Helpers
// Работа с внешними гестурами
extension GestureOverlay.Coordinator: ParentTouchResultHolderDelegate {
    private func setupExternalZoom(_ gestureInProgress: Bool) {
        //Начать подписку на внешние гестуры
        //Отписка - когда гестура закончился
        guard parent.itemType != .template  else { return }
        
        guard gestureInProgress, canManipulate() else {
            ParentTouchHolder.cancel()
            return
        }
        
        if !(ParentTouchHolder.delegate === self) {
            ParentTouchHolder.delegate = self
        }
    }
    
    func begin(gesture: ExternalGesture) {
        guard canManipulate() else { return }
        switch gesture {
        case .scale:
            guard ParentTouchHolder.delegate === self else { return }
            if externalScale == nil { externalScale = parent.scale }
        case .rotation:
            guard ParentTouchHolder.delegate === self else { return }
            if externalRotation == nil { externalRotation = parent.rotation }
        default:
            break
        }
    }
    
    func finish(gesture: ExternalGesture) {
        guard canManipulate() else { return }
        switch gesture {
        case .scale:
            guard ParentTouchHolder.delegate === self else { return }
            externalScale = nil
        case .rotation:
            guard ParentTouchHolder.delegate === self else { return }
            externalRotation = nil
        default:
            break
        }
    }
    
    func endAllGestures() {
        guard ParentTouchHolder.delegate === self else { return }
        ParentTouchHolder.delegate = nil
        externalRotation = nil
        externalScale = nil
    }
    
    func inProcess(gesture: ExternalGesture) {
        switch gesture {
        case let .scaleInProgress(scale):
            scaleInProgress(scale)
        case let .rotationInProgress(rotation):
            rotationInProgress(rotation)
        default:
            break
        }
    }
    
    private func scaleInProgress(_ scale: CGFloat) {
        guard canManipulate() else { return }
        
        guard ParentTouchHolder.delegate === self else { return }
        if externalScale == nil {
            externalScale = parent.scale
            return
        }
        let zoom = max(CGFloat(0.01), (externalScale * abs(scale)))
        withAnimation(animation) {
            parent.scale = zoom
        }
    }
    
    private func rotationInProgress(_ rotation: CGFloat) {
        guard canManipulate() else { return }
        
        if externalRotation == nil {
            externalRotation = parent.rotation
            return
        }
        let angle: Angle = .radians(externalRotation.radians + rotation)
        let rotationForParent: Angle = angle.degrees.makeAngle { [weak self] value in
            guard let self = self else { return }
            switch value {
            case .vertical:
                self.parent.isHorizontalOrientation = false
                self.parent.isVerticalOrientation = true
            case .horizontal:
                self.parent.isHorizontalOrientation = true
                self.parent.isVerticalOrientation = false
            default:
                self.parent.isHorizontalOrientation = false
                self.parent.isVerticalOrientation = false
            }
        }
        parent.rotation = rotationForParent
    }
}

fileprivate extension GestureOverlay.Coordinator {
    func canManipulate() -> Bool {
        guard parent.canManipulate() else {
            parent.gestureInProgress = false
            return false
        }
        return true
    }
    
    func gestureStatus(state: inout Bool, sender: UIGestureRecognizer) {
        switch sender.state {
        case .began: state = true
        case .changed: state = true
        case .ended, .cancelled, .failed, .possible: state = false
        @unknown default: state = false
        }
    }
}
