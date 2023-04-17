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

    private unowned let item: CanvasItemModel

    private let size: CGSize

    @State private var position: CGSize = .zero
    @State private var scale: CGFloat = 1
    @State private var startPosition: CGSize!
    @State private var startZoom: CGFloat!
    @State private var contentSize: CGSize = .zero
    @GestureState private var isManipulation: Bool = false
    @Binding var isInManipulation: Bool

    private let onTap: () -> Void
    private let onDoubleTap: () -> Void

    init(item: CanvasItemModel,
         size: CGSize,
         isInManipulation: Binding<Bool>,
         @ViewBuilder content: @escaping () -> Content,
         onTap: @escaping () -> Void,
         onDoubleTap: @escaping () -> Void) {
        self.item = item
        self.size = size
        self.content = content
        self.onTap = onTap
        self.onDoubleTap = onDoubleTap
        self._isInManipulation = isInManipulation
    }

    var body: some View {
        ZStack {
            Color.clear

            let gestures1 = drugGesture.simultaneously(with: zoomGesture)
            
            let gestures2 = SimultaneousGesture(TapGesture(count: 1), TapGesture(count: 2))
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

            let gestures3 = gestures1.exclusively(before: gestures2)

            content()
                .aspectRatio(contentMode: .fill)
                .scaleEffect(scale)
                .offset(position)
                .fetchSize($contentSize)
                .gesture(gestures3)
                .onChange(of: isManipulation) {
                    isInManipulation = $0
                }

        }
        .frame(size)
        .onChange(of: scale) { value in
            item.update(offset: position, scale: value, rotation: .zero)
        }
        .onChange(of: position) { value in
            item.update(offset: value, scale: scale, rotation: .zero)
        }
    }
}

fileprivate extension MovableContentView {
    var drugGesture: some Gesture {
        DragGesture()
            .updating($isManipulation, body: { _, out, _ in
                out = true
            })
            .onChanged { move in
                if startPosition == nil {
                    startPosition = position
                }
                withAnimation(.interactiveSpring()) {
                    updateDrag(move)
                }
            }
            .onEnded { move in
                withAnimation(.interactiveSpring()) {
                    updateDrag(move)
                    startPosition = nil
                }
            }
    }

    var zoomGesture: some Gesture {
        MagnificationGesture()
            .updating($isManipulation, body: { _, out, _ in
                out = true
            })
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

    private func updateDrag(_ move: DragGesture.Value) {
        guard let startPosition = startPosition else { return }
        position = startPosition + move.translation
        checkLimits()
    }

    private func updateZoom(_ scale: CGFloat) {
        guard let startZoom = startZoom else { return }
        self.scale = startZoom * abs(scale)
        
        if self.scale < 1 { self.scale = 1 }
        
        checkLimits()
    }

    private func checkLimits() {
        scale = max(1, scale)

        let newSize = CGSize(width: contentSize.width * scale, height: contentSize.height * scale)

        let minWidth = -(newSize.width - size.width) / 2
        let maxWidth = (newSize.width - size.width) / 2
        let minHeight = -(newSize.height - size.height) / 2
        let maxHeight = (newSize.height - size.height) / 2

        let x = clamp(position.width,
                      min: minWidth,
                      max: maxWidth)

        let y = clamp(position.height,
                      min: minHeight,
                      max: maxHeight)


        position = .init(width: x, height: y)
    }

    private func clamp<T: Comparable>(_ value: T, min: T, max: T) -> T {
        if value <= min {
            return min
        } else if value >= max {
            return max
        } else {
            return value
        }
    }
}
