//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 30.05.2023.
//

import SwiftUI
import SwiftUIX

enum ParentTouchResult: Equatable {
    case noTouch
    case touch(points: [CGPoint],
               scale: CGFloat,
               state: UIGestureRecognizer.State,
               gesture: UIGestureRecognizer)
}

let ParentTouchHolder = ParentTouchResultHolder.shared

protocol ParentTouchResultHolderDelegate: AnyObject {
    func begin()
    func finish()
    func inProcess()
}

final class ParentTouchResultHolder {
    weak var delegate: ParentTouchResultHolderDelegate?
    private(set) var value: ParentTouchResult
    
    private init() {
        value = .noTouch
    }
    
    func set(_ value: ParentTouchResult) {
        switch value {
        case .noTouch:
            print("===> Parent gesture finish")
            delegate?.finish()
        case let .touch(points: _, scale: _, state: state, gesture: gesture):
            switch state {
            case .began:
                print("===> Parent gesture begin")
                delegate?.begin()
            case .changed:
                print("===> Parent gesture inProcess")
                delegate?.inProcess()
            default:
                print("===> Parent gesture finish")
                gesture.cancel()
                delegate?.finish()
            }
        }
        self.value = value
    }
    
    func reset() {
        self.value = .noTouch
    }
    
    static let shared = ParentTouchResultHolder()
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
            guard let view = sender.view?.superview else { return }
            if sender.state == .began {
                makePoints(sender, scale: sender.scale, view: view, state: .began, gesture: sender)
            } else if sender.state == .changed {
                makePoints(sender, scale: sender.scale, view: view, state: .changed, gesture: sender)
            } else if sender.state == .ended || sender.state == .cancelled {
                ParentTouchHolder.set(.touch(points: [], scale: sender.scale, state: .ended, gesture: sender))
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        private func makePoints(_ sender: UIGestureRecognizer,
                                scale: CGFloat,
                                view: UIView,
                                state: UIGestureRecognizer.State,
                                gesture: UIGestureRecognizer) {
            var points: [CGPoint] = []
            for touchNumber in 0..<sender.numberOfTouches {
                let _location = sender.location(ofTouch: touchNumber, in: view)
                let location = CGPoint(x: _location.x - view.bounds.midX,
                                          y: _location.y - view.bounds.midY)
                points.append(location)
            }
            
            ParentTouchHolder.set(
                .touch(points: points, scale: scale, state: state, gesture: gesture)
            )
        }
    }
}

fileprivate extension UIGestureRecognizer {
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
}
