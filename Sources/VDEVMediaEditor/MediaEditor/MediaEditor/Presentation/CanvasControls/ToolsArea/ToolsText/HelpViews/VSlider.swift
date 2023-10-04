//
//  VSlider.swift
//  
//
//  Created by Vladislav Gushin on 04.10.2023.
//

import SwiftUI

struct VSlider<V: BinaryFloatingPoint>: View {
    var value: Binding<V>
    @Binding var inManipulation: Bool
    var range: ClosedRange<V> = 0...1
    var step: V.Stride? = nil
    var onEditingChanged: (Bool) -> Void = { _ in }

    private let drawRadius: CGFloat = 13
    private let dragRadius: CGFloat = 25
    private let lineWidth: CGFloat = 20

    @State private var validDrag = false
    
    init(
        value: Binding<V>,
        inManipulation: Binding<Bool>,
        in range: ClosedRange<V> = 0...1,
        step: V.Stride? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self.value = value
        self._inManipulation = inManipulation

        if let step = step {
            self.step = step
            var newUpperbound = range.lowerBound
            while newUpperbound.advanced(by: step) <= range.upperBound{
                newUpperbound = newUpperbound.advanced(by: step)
            }
            self.range = ClosedRange(uncheckedBounds: (range.lowerBound, newUpperbound))
        } else {
            self.range = range
        }

        self.onEditingChanged = onEditingChanged
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Triangle()
                    .fill(Color(.systemGray4))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipShape(Capsule())
                
                Triangle()
                    .fill(AppColors.white.opacity(0.4))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .mask(alignment: .bottom) {
                        let width = geometry.size.width
                        let height = geometry.size.height - self.getPoint(in: geometry).y
                        if width > 0 && height > 0{
                            Rectangle()
                                .frame(width: width,height: height)
                        }
                    }
                    .clipShape(Capsule())
            
                Circle()
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .position(x: geometry.size.width / 2, y: self.getPoint(in: geometry).y)
                    .foregroundColor(AppColors.white)
                    .shadow(radius: 2, y: 2)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onEnded({ _ in
                                haptics(.light)
                                self.inManipulation = false
                                self.validDrag = false
                                self.onEditingChanged(false)
                            })
                            .onChanged(self.handleDragged(in: geometry))
                    )
            }
        }
    }
}

private extension VSlider {
    private func getPoint(in geometry: GeometryProxy) -> CGPoint {
        let x = geometry.size.width / 2
        let location = value.wrappedValue - range.lowerBound
        let scale = V(2 * drawRadius - geometry.size.height) / (range.upperBound - range.lowerBound)
        let y = CGFloat(location * scale) + geometry.size.height - drawRadius
        return CGPoint(x: x, y: y)
    }

    private func handleDragged(in geometry: GeometryProxy) -> (DragGesture.Value) -> Void {
        return { drag in
            self.inManipulation = true
            
            if drag.startLocation.distance(to: self.getPoint(in: geometry)) < self.dragRadius && !self.validDrag {
                self.validDrag = true
                self.onEditingChanged(true)
            }

            if self.validDrag {
                let location = drag.location.y - geometry.size.height + self.drawRadius
                let scale = CGFloat(self.range.upperBound - self.range.lowerBound) / (2 * self.drawRadius - geometry.size.height)
                let newValue = V(location * scale) + self.range.lowerBound
                let clampedValue = max(min(newValue, self.range.upperBound), self.range.lowerBound)

                if self.step != nil {
                    let step = V.zero.advanced(by: self.step!)
                    self.value.wrappedValue = round((clampedValue - self.range.lowerBound) / step) * step + self.range.lowerBound
                } else {
                    self.value.wrappedValue = clampedValue
                }
            }
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: .init(x: rect.maxX, y: rect.minX))
        path.addLine(to: .init(x: rect.midX, y: rect.maxY))
        path.addLine(to: .init(x: rect.minX, y: rect.minY))
        return path
    }
}
