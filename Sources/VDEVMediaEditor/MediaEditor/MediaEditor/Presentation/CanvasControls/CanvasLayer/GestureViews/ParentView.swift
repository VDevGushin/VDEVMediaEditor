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
    case touch(points: [CGPoint], scale: CGFloat, state: UIGestureRecognizer.State)
}

struct ParentView<Content: View>: UIViewRepresentable {
    let content: Content
    @Binding private var touchLocation: ParentTouchResult
    
    init(touchLocation: Binding<ParentTouchResult>,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._touchLocation = touchLocation
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
        let LongPressRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPress(sender:)))
        let PinchRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
        PinchRecognizer.delegate = context.coordinator
        LongPressRecognizer.delegate = context.coordinator
        LongPressRecognizer.minimumPressDuration = 0.0
        //hView.addGestureRecognizer(LongPressRecognizer)
        hView.addGestureRecognizer(PinchRecognizer)
        context.coordinator.longPressGest = LongPressRecognizer
        context.coordinator.pinchGest = PinchRecognizer
    }
    
    func updateUIView(_ uiView: UIHostingView<Content>, context: Context) { uiView.rootView = content }
    
    static func dismantleUIView(_ uiView: UIHostingView<Content>, coordinator: Coordinator) {
        if let longPressGest = coordinator.longPressGest { uiView.removeGestureRecognizer(longPressGest) }
        if let pinchGest = coordinator.pinchGest { uiView.removeGestureRecognizer(pinchGest) }
        uiView.removeFromSuperview()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        private let parent: ParentView
        weak var longPressGest: UIGestureRecognizer?
        weak var pinchGest: UIGestureRecognizer?
        
        init(parent: ParentView) { self.parent = parent }
        
        @objc
        func handlePinch(sender: UIPinchGestureRecognizer) {
            guard let view = sender.view?.superview else { return }
            if sender.state == .began {
                makePoints(sender, scale: sender.scale, view: view, state: .began)
            } else if sender.state == .changed {
                makePoints(sender, scale: sender.scale, view: view, state: .changed)
            } else if sender.state == .ended || sender.state == .cancelled {
                parent.touchLocation = .touch(points: [], scale: sender.scale, state: .ended)
            }
        }
        
        @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
            guard let view = sender.view?.superview else { return }
            if sender.state == .began {
                makePoints(sender, scale: 1.0, view: view, state: .began)
            } else if sender.state == .changed {
                makePoints(sender, scale: 1.0, view: view, state: .changed)
            } else if sender.state == .ended || sender.state == .cancelled {
                parent.touchLocation = .touch(points: [], scale: 1.0, state: .ended)
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
        private func makePoints(_ sender: UIGestureRecognizer,
                                scale: CGFloat,
                                view: UIView,
                                state: UIGestureRecognizer.State) {
            var points: [CGPoint] = []
            for touchNumber in 0..<sender.numberOfTouches {
                let _location = sender.location(ofTouch: touchNumber, in: view)
                let location = CGPoint(x: _location.x - view.bounds.midX,
                                          y: _location.y - view.bounds.midY)
                points.append(location)
            }
            
            parent.touchLocation = .touch(points: points, scale: scale, state: state)
        }
    }
}
