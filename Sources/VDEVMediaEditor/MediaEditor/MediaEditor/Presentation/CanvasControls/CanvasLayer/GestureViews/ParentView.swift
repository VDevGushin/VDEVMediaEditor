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
    
    init(inTouch: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._inTouch = inTouch
    }
    
    func makeUIView(context: Context) -> UIHostingView<Content> {
        let view = _UIContainerHostingView(rootView: content)
        view.isOpaque = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.delegate = context.coordinator
        return view
    }
    
    func updateUIView(_ uiView: UIHostingView<Content>, context: Context) {
        uiView.rootView = content
    }
    
    static func dismantleUIView(_ uiView: UIHostingView<Content>, coordinator: ()) {
        uiView.removeFromSuperview()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UIGestureRecognizerDelegate, _UIContainerViewDelegate {
        private let parent: ParentView
        
        init(parent: ParentView) {
            self.parent = parent
        }
        
        func touches(inProgress: Bool) {
            parent.inTouch = inProgress
        }
    }
}
