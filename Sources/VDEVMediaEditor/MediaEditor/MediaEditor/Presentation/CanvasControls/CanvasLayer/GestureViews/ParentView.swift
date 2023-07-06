//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 30.05.2023.
//

import SwiftUI
import SwiftUIX

let ParentTouchHolder = ParentTouchResultHolder.shared

enum ParentTouchResult: Equatable {
    case noTouch
    case touch(scale: CGFloat, state: UIGestureRecognizer.State)
    case rotation(rotation: CGFloat, state: UIGestureRecognizer.State)
}

enum ExternalGesture {
    case scale
    case rotation
    case scaleInProgress(CGFloat)
    case rotationInProgress(CGFloat)
}

protocol ParentTouchResultHolderDelegate: AnyObject {
    func begin(gesture: ExternalGesture)
    func finish(gesture: ExternalGesture)
    func inProcess(gesture: ExternalGesture)
    func endAllGestures()
}

final class ParentTouchResultHolder {
    weak var delegate: ParentTouchResultHolderDelegate?
    
    fileprivate var onCancel: (() -> Void)?
    
    private init() { }
    
    static let shared = ParentTouchResultHolder()
    
    func endAllGestures() {
        delegate?.endAllGestures()
    }
    
    func set(_ value: ParentTouchResult) {
        switch value {
        case .noTouch:
            delegate?.finish(gesture: .scale)
            onCancel?()
        case let .touch(scale: scale, state: state):
            switch state {
            case .began:
                delegate?.begin(gesture: .scale)
            case .changed:
                delegate?.inProcess(gesture: .scaleInProgress(scale))
            case .possible, .ended, .cancelled, .failed:
                delegate?.finish(gesture: .scale)
            @unknown default:
                delegate?.finish(gesture: .scale)
            }
        case let .rotation(rotation: rotation, state: state):
            switch state {
            case .began:
                delegate?.begin(gesture: .rotation)
            case .changed:
                delegate?.inProcess(gesture: .rotationInProgress(rotation))
            case .possible, .ended, .cancelled, .failed:
                delegate?.finish(gesture: .rotation)
            @unknown default:
                delegate?.finish(gesture: .rotation)
            }
        }
    }
}

struct ParentView<Content: View>: UIViewRepresentable {
    let content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    func makeUIView(context: Context) -> UIHostingView<Content> {
        let view = _UIContainerHostingView(rootView: content)
        view.isOpaque = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        setupGest(for: view, context: context)
        return view
    }
    
    private func setupGest(for hView: UIView, context: Context) {
        let PinchRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
        PinchRecognizer.cancelsTouchesInView = true
        PinchRecognizer.delegate = context.coordinator
        
        let RotationGesture = UIRotationGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleRotate(sender:)))
        RotationGesture.cancelsTouchesInView = true
        RotationGesture.delegate = context.coordinator
        
        hView.addGestureRecognizer(PinchRecognizer)
        hView.addGestureRecognizer(RotationGesture)
        
        context.coordinator.pinchGest = PinchRecognizer
        context.coordinator.rotationGest = RotationGesture
    }
    
    func updateUIView(_ uiView: UIHostingView<Content>, context: Context) { uiView.rootView = content }
    
    static func dismantleUIView(_ uiView: UIHostingView<Content>, coordinator: Coordinator) {
        if let pinchGest = coordinator.pinchGest { uiView.removeGestureRecognizer(pinchGest) }
        if let rotationGest = coordinator.rotationGest { uiView.removeGestureRecognizer(rotationGest) }
        uiView.removeFromSuperview()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        weak var pinchGest: UIPinchGestureRecognizer?
        weak var rotationGest: UIRotationGestureRecognizer?
        
        private let parent: ParentView
        private var scaleInProgress = false
        private var rotationInProgress = false
        
        init(parent: ParentView) {
            self.parent = parent
            super.init()
            ParentTouchResultHolder.shared.onCancel = { [weak self] in
                self?.pinchGest?.reset()
                self?.pinchGest?.scale = 1.0
                self?.rotationGest?.reset()
                //self?.rotationGest?.rotation = 0.0
            }
        }
        
        @objc
        func handlePinch(sender: UIPinchGestureRecognizer) {
            gestureStatus(state: &scaleInProgress, sender: sender)
            if sender.state == .began {
                ParentTouchHolder.set(.touch(scale: sender.scale, state: .began))
            } else if sender.state == .changed {
                ParentTouchHolder.set(.touch(scale: sender.scale, state: .changed))
            } else if sender.state == .ended || sender.state == .cancelled {
                ParentTouchHolder.set(.touch(scale: sender.scale, state: .ended))
                checkEndAllGestures()
            }
        }
        
        @objc
        func handleRotate(sender: UIRotationGestureRecognizer) {
            gestureStatus(state: &rotationInProgress, sender: sender)
            switch sender.state {
            case .began:
                ParentTouchHolder.set(.rotation(rotation: sender.rotation, state: .began))
            case .changed:
                ParentTouchHolder.set(.rotation(rotation: sender.rotation, state: .changed))
            default:
                ParentTouchHolder.set(.rotation(rotation: sender.rotation, state: .ended))
                checkEndAllGestures()
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        private func checkEndAllGestures() {
            if !scaleInProgress && !rotationInProgress {
                ParentTouchHolder.endAllGestures()
            }
        }
        private func gestureStatus(state: inout Bool, sender: UIGestureRecognizer) {
            switch sender.state {
            case .began:
                state = true
            case .changed:
                state = true
            case .ended, .cancelled, .failed, .possible:
                state = false
            @unknown default:
                state = false
            }
        }
    }
}
