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
}

protocol ParentTouchResultHolderDelegate: AnyObject {
    func begin()
    func finish()
    func inProcess(scale: CGFloat)
}

final class ParentTouchResultHolder {
    weak var delegate: ParentTouchResultHolderDelegate?
    
    private init() { }
    
    static let shared = ParentTouchResultHolder()
    
    func set(_ value: ParentTouchResult) {
        switch value {
        case .noTouch:
            delegate?.finish()
        case let .touch(scale: scale, state: state):
            switch state {
            case .began:
                delegate?.begin()
            case .changed:
                delegate?.inProcess(scale: scale)
            default:
                delegate?.finish()
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
        PinchRecognizer.delegate = context.coordinator
        hView.addGestureRecognizer(PinchRecognizer)
        context.coordinator.pinchGest = PinchRecognizer
    }
    
    func updateUIView(_ uiView: UIHostingView<Content>, context: Context) { uiView.rootView = content }
    
    static func dismantleUIView(_ uiView: UIHostingView<Content>, coordinator: Coordinator) {
        if let pinchGest = coordinator.pinchGest { uiView.removeGestureRecognizer(pinchGest) }
        uiView.removeFromSuperview()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        private let parent: ParentView
        weak var pinchGest: UIGestureRecognizer?
        
        init(parent: ParentView) { self.parent = parent }
        
        @objc
        func handlePinch(sender: UIPinchGestureRecognizer) {
            if sender.state == .began {
                makePoints(scale: sender.scale, state: .began)
            } else if sender.state == .changed {
                makePoints(scale: sender.scale, state: .changed)
            } else if sender.state == .ended || sender.state == .cancelled {
                makePoints(scale: sender.scale, state: .ended)
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        private func makePoints(scale: CGFloat,
                                state: UIGestureRecognizer.State) {
            ParentTouchHolder.set(.touch(scale: scale, state: state))
        }
    }
}
