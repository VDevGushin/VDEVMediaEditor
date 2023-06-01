//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 30.05.2023.
//

import SwiftUI
import SwiftUIX

struct ParentView<Content: View>: UIViewRepresentable {
    @Binding private var inTouch: Bool
    let content: Content
    @Binding private var touchLocation: CGPoint?
    
    init(inTouch: Binding<Bool>,
         touchLocation: Binding<CGPoint?>,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._inTouch = inTouch
        self._touchLocation = touchLocation
    }
    
    func makeUIView(context: Context) -> UIHostingView<Content> {
        let view = _UIContainerHostingView(rootView: content)
        view.isOpaque = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.delegate = context.coordinator
        setupGest(for: view, context: context)
        return view
    }
    
    private func setupGest(for hView: UIView, context: Context) {
        let Pangesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(sender:)))
        
        let LongPressRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleLongPress(sender:)))
        
        let PinchRecognizer = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
        

        Pangesture.delegate = context.coordinator
        PinchRecognizer.delegate = context.coordinator
        LongPressRecognizer.delegate = context.coordinator
        LongPressRecognizer.minimumPressDuration = 0.0
        hView.addGestureRecognizer(Pangesture)
        hView.addGestureRecognizer(LongPressRecognizer)
        hView.addGestureRecognizer(PinchRecognizer)
        context.coordinator.panGest = Pangesture
        context.coordinator.longPressGest = LongPressRecognizer
        context.coordinator.pinchGest = PinchRecognizer
    }
    
    func updateUIView(_ uiView: UIHostingView<Content>, context: Context) {
        uiView.rootView = content
    }
    
    static func dismantleUIView(_ uiView: UIHostingView<Content>, coordinator: Coordinator) {
        if let panGest = coordinator.panGest {
            uiView.removeGestureRecognizer(panGest)
        }
        
        if let longPressGest = coordinator.longPressGest {
            uiView.removeGestureRecognizer(longPressGest)
        }
        
        if let pinchGest = coordinator.pinchGest {
            uiView.removeGestureRecognizer(pinchGest)
        }
        
        uiView.removeFromSuperview()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UIGestureRecognizerDelegate, _UIContainerViewDelegate {
        private let parent: ParentView
        weak var panGest: UIGestureRecognizer?
        weak var longPressGest: UIGestureRecognizer?
        weak var pinchGest: UIGestureRecognizer?
        
        init(parent: ParentView) {
            self.parent = parent
        }
        
        func touches(inProgress: Bool) {
            parent.inTouch = inProgress
        }
        
        @objc
        func handlePinch(sender: UIPinchGestureRecognizer) {
            guard let view = sender.view?.superview else {
                return
            }
            
            if sender.state == .began {
                parent.touchLocation = sender.location(in: view)
            } else if sender.state == .changed {
                parent.touchLocation = sender.location(in: view)
            } else if sender.state == .ended || sender.state == .cancelled {
                parent.touchLocation = nil
            }
        }
        
        @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
            guard let view = sender.view?.superview else {
                return
            }
            
            if sender.state == .began {
                parent.touchLocation = sender.location(in: view)
            } else if sender.state == .changed {
                parent.touchLocation = sender.location(in: view)
            } else if sender.state == .ended || sender.state == .cancelled {
                parent.touchLocation = nil
            }
        }
        
        @objc func handlePan(sender: UIPanGestureRecognizer) {
            guard let view = sender.view?.superview else {
                return
            }
            
            if sender.state == .began {
                parent.touchLocation = sender.location(in: view)
            } else if sender.state == .changed {
                parent.touchLocation = sender.location(in: view)
            } else if sender.state == .ended || sender.state == .cancelled {
                parent.touchLocation = nil
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
