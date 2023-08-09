//
//  MoveTemplateContentView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 20.02.2023.
//

import SwiftUI
import UIKit

struct MovableContentView<Content: View>: View {
    private let content: () -> Content
    private let size: CGSize
    private unowned let item: CanvasItemModel

    @State private var position: CGSize = .init(width: 0, height: 0)
    @State private var scale: CGFloat = 1
    @State private var startPosition: CGSize!
    @State private var startZoom: CGFloat!
    @State private var contentSize: CGSize = .zero
    @GestureState private var isManipulation: Bool = false
    @GestureState private var showSelection: Bool = false
    
    @Binding var isInManipulation: Bool
    @Binding var isShowSelection: Bool

    private let onTap: () -> Void
    private let onDoubleTap: () -> Void

    init(item: CanvasItemModel,
         size: CGSize,
         isInManipulation: Binding<Bool>,
         isShowSelection: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content,
         onTap: @escaping () -> Void,
         onDoubleTap: @escaping () -> Void) {
        self.item = item
        self.size = size
        self.content = content
        self.onTap = onTap
        self.onDoubleTap = onDoubleTap
        self._isInManipulation = isInManipulation
        self._isShowSelection = isShowSelection
    }

    var body: some View {
        ZStackWithClearColor {
            content()
                .scaleEffect(scale)
                .offset(position)
                .fetchSize($contentSize)
                .gesture(mainGesture.simultaneously(with: tapObserver))
                .onChange(of: isManipulation) {
                    isInManipulation = $0
                }
                .onChange(of: showSelection) {
                    isShowSelection = $0
                }
                .onChange(of: position) { value in
                    item.update(offset: value, scale: scale, rotation: .zero)
                }
                .onChange(of: scale) { value in
                    item.update(offset: position, scale: value, rotation: .zero)
                }
        }
        .frame(width: size.width, height: size.height, alignment: .center)
    }
}

fileprivate extension MovableContentView {
    var tapObserver: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($showSelection, body: { _, out, _ in out = true })
    }
    
    var drugGesture: some Gesture {
        DragGesture(minimumDistance: 3)
            .updating($isManipulation, body: { _, out, _ in out = true })
            .updating($showSelection, body: { _, out, _ in out = true })
            .onChanged { move in
                if startPosition == nil { startPosition = position }
                updateDrag(move)
                //withAnimation(.interactiveSpring()) {  }
            }
            .onEnded { move in
               // withAnimation(.interactiveSpring()) {
                    updateDrag(move)
                    startPosition = nil
               // }
            }
    }

    var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($isManipulation, body: { _, out, _ in out = true })
            .updating($showSelection, body: { _, out, _ in out = true })
            .onChanged { scale in
                if startZoom == nil {
                    startZoom = self.scale
                }
                withAnimation(.interactiveSpring()) {
                    updateZoom(scale)
                }
            }
            .onEnded { scale in
                withAnimation(.interactiveSpring()) {
                    updateZoom(scale)
                    startZoom = nil
                }
            }
    }
    
    private var mainGesture: some Gesture {
        let drugZoomGesture = drugGesture.simultaneously(with: zoomGesture)
        
        let tapDoubleTapGesture = SimultaneousGesture(TapGesture(count: 1), TapGesture(count: 2))
            .updating($showSelection, body: { _, out, _ in out = true })
            .onEnded { gestures in
                guard !isManipulation else { return }
                if gestures.second != nil {
                    onDoubleTap()
                    haptics(.light)
                } else if gestures.first != nil {
                    onTap()
                    haptics(.light)
                }
            }
      
        return drugZoomGesture.exclusively(before: tapDoubleTapGesture)
    }

    private func updateDrag(_ move: DragGesture.Value) {
        guard let startPosition = startPosition else { return }
        position = startPosition + move.translation
        checkLimits()
    }

    private func updateZoom(_ scale: CGFloat) {
        guard let startZoom = startZoom else { return }
        self.scale = startZoom * abs(scale)
        checkLimits()
    }

    private func checkLimits() {
        scale = max(1, scale)
    
        let newSize = contentSize * scale
        // CGSize(width: contentSize.width * scale, height: contentSize.height * scale)

        let minWidth = (-(newSize.width - size.width) / 2)
        let maxWidth = ((newSize.width - size.width) / 2)
        
        let minHeight = -(newSize.height - size.height) / 2
        let maxHeight = (newSize.height - size.height) / 2

        var x: CGFloat = 0
        if newSize.width > size.width {
            if position.width > 0 {
                x = min(maxWidth, position.width)
            } else if position.width < 0 {
                x = max(minWidth, position.width)
            } else {
                x = position.width
            }
//            x = clamp(position.width,
//                       min: minWidth + 1,
//                       max: maxWidth - 1)
        }
        
        var y: CGFloat = 0
        if newSize.height > size.height {
            if position.height > 0 {
                y = min(maxHeight, position.height)
            } else if position.height < 0 {
                y = max(minHeight, position.height)
            } else {
                y = position.height
            }
            
//            y = clamp(position.height,
//                           min: minHeight + 1,
//                           max: maxHeight - 1)
        }

        position = .init(width: x, height: y)
    }
    
    private func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
        if value < min {
            return min
        } else if value > max {
            return max
        } else {
            return value
        }
    }
}
