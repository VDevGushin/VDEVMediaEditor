//
//  GestureOverlay.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 07.02.2023.
//

import SwiftUI
import SwiftUIX

struct ParentView<Content: View>: UIViewRepresentable {
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIHostingView<Content> {
        let view = UIHostingView(rootView: content)
        view.isOpaque = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }
    
    func updateUIView(_ uiView: UIHostingView<Content>, context: Context) {
        uiView.rootView = content
    }
    
    static func dismantleUIView(_ uiView: UIHostingView<Content>, coordinator: ()) {
        uiView.removeFromSuperview()
    }
}

protocol _UIHostingViewDelegate: AnyObject {
    func touches(inProgress: Bool)
    func zoomIn()
    func zoomOut()
}

final class _UIHostingView<Content: View>: UIHostingView<Content>{
    weak var delegate: _UIHostingViewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.touches(inProgress: true)
        delegate?.zoomIn()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        delegate?.touches(inProgress: false)
        delegate?.zoomOut()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.touches(inProgress: false)
        delegate?.zoomOut()
    }
}

struct GestureOverlay<Content: View>: UIViewRepresentable {
    @Binding var offset: CGSize
    @Binding var scale: CGFloat
    @Binding var rotation: Angle
    @Binding var gestureInProgress: Bool
    @Binding var isHorizontalOrientation: Bool
    @Binding var isVerticalOrientation: Bool
    @Binding var isCenterVertical: Bool
    @Binding var isCenterHorizontal: Bool
    @Binding var anchor: UnitPoint
    @Binding var tapScaleFactor: CGFloat
    
    private let content: () -> Content
    private let itemType: CanvasItemType
    
    private(set) var onLongPress: () -> Void
    private(set) var onDoubleTap: () -> Void
    private(set) var onTap: () -> Void
    
    private(set) var canManipulate: () -> Bool
    
    internal init(offset: Binding<CGSize>,
                  scale: Binding<CGFloat>,
                  anchor: Binding<UnitPoint>,
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
        
        self._anchor = anchor
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
        hView.delegate = context.coordinator
        
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
        context.coordinator.longTapGest = nil
        context.coordinator.doubleTapGest = nil
    }
    
    private func setupGest(for hView: UIView, context: Context) {
        let Pangesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(sender:)))
        Pangesture.delegate = context.coordinator
        hView.addGestureRecognizer(Pangesture)
        Pangesture.cancelsTouchesInView = false
        context.coordinator.panGest = Pangesture
        
        let RotationGesture = UIRotationGestureRecognizer(target: context.coordinator, action:     #selector(context.coordinator.handleRotate(sender:)))
        RotationGesture.delegate = context.coordinator
        hView.addGestureRecognizer(RotationGesture)
        RotationGesture.cancelsTouchesInView = false
        context.coordinator.rotGest = RotationGesture
        
        let Pinchgesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
        Pinchgesture.delegate = context.coordinator
        hView.addGestureRecognizer(Pinchgesture)
        Pinchgesture.cancelsTouchesInView = false
        context.coordinator.pinchGest = Pinchgesture
        
        // Если шаблон, то нам ничего не нужно (просто следим за манипуляциями)
        let TapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(sender:)))
        TapGestureRecognizer.numberOfTapsRequired = 1
        hView.addGestureRecognizer(TapGestureRecognizer)
        context.coordinator.tapGest = TapGestureRecognizer
        
        let LongPressRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPress(sender:)))
        LongPressRecognizer.minimumPressDuration = 0.7
        hView.addGestureRecognizer(LongPressRecognizer)
        context.coordinator.longTapGest = LongPressRecognizer
        
        let DoubleTapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleDoubleTap))
        DoubleTapRecognizer.numberOfTapsRequired = 2
        hView.addGestureRecognizer(DoubleTapRecognizer)
        context.coordinator.doubleTapGest = DoubleTapRecognizer
        
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
    
    final class Coordinator<Content: View>: NSObject, UIGestureRecognizerDelegate, _UIHostingViewDelegate {

        private let parent: GestureOverlay
        
        private var lastScale: CGFloat!
        private var lastStoreOffset: CGSize = .zero
        private var lastRotation: Angle!
        private let centerRange = CGFloat(-5.0)...CGFloat(5.0)
        
        // All gestures
        weak var panGest: UIGestureRecognizer?
        weak var rotGest: UIGestureRecognizer?
        weak var pinchGest: UIGestureRecognizer?
        weak var longTapGest: UILongPressGestureRecognizer?
        weak var doubleTapGest: UITapGestureRecognizer?
        weak var tapGest: UITapGestureRecognizer?
        
        // Gesture status
        private var tapInProgress = false { didSet { updateInProgressState() } }
        private var longTapInProgress = false { didSet { updateInProgressState() } }
        private var doubleTapInProgress = false { didSet { updateInProgressState() } }
        private var panInProgress = false { didSet { updateInProgressState() } }
        private var rotInProgress = false { didSet { updateInProgressState() } }
        private var scaleInProgress = false { didSet { updateInProgressState() } }
        private var touchesInProgress = false { didSet { updateInProgressState() } }
        
        // _UIHostingViewDelegate
        func touches(inProgress: Bool) { touchesInProgress = inProgress }
        
        func zoomIn() {}
        
        func zoomOut() {}
        
        private func updateInProgressState() {
            guard canManipulate() else { return }
            
            self.parent.gestureInProgress = panInProgress ||
            rotInProgress ||
            scaleInProgress ||
            longTapInProgress ||
            tapInProgress ||
            doubleTapInProgress ||
            touchesInProgress
        }
        
        deinit { Log.d("❌ Deinit: GestureOverlay.Coordinator") }
        
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
            
            sender.maximumNumberOfTouches = 2
            
            guard let piece = sender.view else { return }
            
            let translation = sender.translation(in: piece.superview)
            
            gestureStatus(state: &panInProgress, sender: sender)
            
            if sender.state == .began {
                lastStoreOffset = parent.offset
            }
            
            if sender.state != .cancelled {
                let x = translation.x
                let y = translation.y
                let B = parent.rotation.radians
                
                let rotatedX = (CoreGraphics.cos(B) * x) - (sin(B) * y)
                let rotatedY = (CoreGraphics.sin(B) * x) + (cos(B) * y)
                
                var width = lastStoreOffset.width + rotatedX * parent.scale
                var height = lastStoreOffset.height + rotatedY * parent.scale
                
                if centerRange.contains(width) {
                    width = 0
                    parent.isCenterVertical = true
                } else {
                    parent.isCenterVertical = false
                }
                
                if centerRange.contains(height) {
                    height = 0
                    parent.isCenterHorizontal = true
                }else {
                    parent.isCenterHorizontal = false
                }
                
                withAnimation(.interactiveSpring()) {
                    parent.offset = CGSize(
                        width: width,
                        height: height
                    )
                }
            } else {
                withAnimation(.interactiveSpring()) {
                    parent.offset = lastStoreOffset
                }
            }
            if [UIGestureRecognizer.State.ended, .cancelled, .failed].contains(sender.state) {
                panInProgress = false
            }
        }
        
        @objc
        func handlePinch(sender: UIPinchGestureRecognizer) {
            guard canManipulate() else { return }
            
            gestureStatus(state: &scaleInProgress, sender: sender)
            
            if sender.state == .began {
                if lastScale == nil {
                    lastScale = parent.scale
                }
            } else if sender.state == .changed {
                guard checkInView(sender: sender, scale: parent.scale, forCancel: pinchGest) else {
                    parent.scale = parent.scale
                    return
                }
                
                let zoom = max(CGFloat(0.1), min(CGFloat(2.0), (lastScale * abs(sender.scale))))
                
                parent.scale = zoom
            } else if sender.state == .ended ||
                        sender.state == .cancelled {
                lastScale = nil
            }
        }
        
        @objc
        func handleRotate(sender: UIRotationGestureRecognizer) {
            guard canManipulate() else { return }
            
            gestureStatus(state: &rotInProgress, sender: sender)
            
            if sender.state == .began {
                rotInProgress = true
                if lastRotation == nil {
                    lastRotation = parent.rotation
                }
            } else if sender.state == .changed {
                let angle: Angle = .radians(lastRotation.radians + sender.rotation)
                parent.rotation = angle.degrees.makeAngle { [weak self] value in
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
            } else if sender.state == .ended {
                lastRotation = nil
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
        
        private func checkInView(sender: UIGestureRecognizer,
                                 scale: CGFloat?,
                                 forCancel: UIGestureRecognizer?...) -> Bool {
            func _check(sender: UIGestureRecognizer, scale: CGFloat?) -> Bool {
                guard let view = sender.view else { return false }
                
                let point = sender.location(in: view)
                let scaledSize = view.bounds.size
                
                return (CGFloat(0.0)...scaledSize.width).contains(point.x) &&
                (CGFloat(0.0)...scaledSize.height).contains(point.y)
            }
            
            if !_check(sender: sender, scale: scale) {
                forCancel.forEach {
                    $0?.cancel()
                }
                return false
            }
            return true
        }
        
        // MARK: - For template to detect manipulations
        @objc
        func handlePanForTemplate(sender: UIPanGestureRecognizer) {
            gestureStatus(state: &panInProgress, sender: sender)
        }
        
        @objc
        func handlePinchForTemplate(sender: UIPinchGestureRecognizer) {
            gestureStatus(state: &scaleInProgress, sender: sender)
        }
        
        @objc
        func handleRotateForTemplate(sender: UIRotationGestureRecognizer) {
            gestureStatus(state: &rotInProgress, sender: sender)
        }
        
        private func canManipulate() -> Bool {
            guard parent.canManipulate() else {
                parent.gestureInProgress = false
                return false
            }
            return true
        }
        
        private func gestureStatus(state: inout Bool, sender: UIGestureRecognizer) {
            if sender.state == .began { state = true }
            if [UIGestureRecognizer.State.ended, .cancelled, .failed].contains(sender.state) {
                state = false
            }
        }
    }
}

fileprivate extension UIGestureRecognizer {
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
}
