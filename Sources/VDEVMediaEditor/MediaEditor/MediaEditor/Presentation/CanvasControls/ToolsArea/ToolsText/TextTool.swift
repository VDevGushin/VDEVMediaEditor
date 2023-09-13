//
//  TextTool.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.02.2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import Combine

struct TextTool: View {
    @State private var text: String
    @State private var placeholder: String
    @State private var fontSize: CGFloat
    @State private var textColor: UIColor
    @State private var alignment: Alignment
    @State private var textAlignment: NSTextAlignment
    @State private var textStyle: CanvasTextStyle
    @State private var needTextBG: Bool
    @State private var isEditing = true
    @State private var colorSelectorOpen = false
    @State private var scale: CGFloat
    @State private var rot: Angle
    @State private var offset: CGSize
    @State private var isEditable: Bool
    @State private var textFrameSize: CGSize = .zero
    @State private var sliderInManipulation: Bool = false
    @State private var backColor: Color

    private var textItem: CanvasTextModel?
    private let fromTemplate: Bool
    
    private let labelContainerToCanvasWidthRatio: CGFloat
    private let doneAction: (CanvasTextModel) -> ()
    private let deleteAction: () -> ()
    private var textViewPaddingRatio: CGFloat { (1 - labelContainerToCanvasWidthRatio) / 2 }

    init(
        textItem: CanvasTextModel? = nil,
        labelContainerToCanvasWidthRatio: CGFloat,
        fromTemplate: Bool = false,
        doneAction: @escaping (CanvasTextModel) -> (),
        deleteAction: @escaping () -> ()
    ) {
        self.fromTemplate = fromTemplate
        self.textItem = textItem
        self.labelContainerToCanvasWidthRatio = labelContainerToCanvasWidthRatio
        self.doneAction = doneAction
        self.deleteAction = deleteAction
        guard let item = textItem else {
            self.text = ""
            self.placeholder = DI.resolve(VDEVMediaEditorStrings.self).defaultPlaceholder
            self.fontSize = 32
            self.textColor = AppColors.black.uiColor.contrast
            self.backColor = AppColors.black.uiColor.contrast.isDarkColor ? AppColors.whiteWithOpacity : AppColors.blackWithOpacity
            self.alignment = .center
            self.textAlignment = .center
            self.textStyle = CanvasTextStyle.basicText
            self.needTextBG = false
            self.scale = 1
            self.rot = .zero
            self.offset = .zero
            self.isEditable = true
            return
        }

        self.text = item.text
        self.placeholder = item.placeholder
        self.fontSize = item.fontSize
        self.textColor = item.color
        self.backColor = item.color.isDarkColor ? AppColors.whiteWithOpacity : AppColors.blackWithOpacity
        self.alignment = item.alignment
        self.textAlignment = item.textAlignment
        self.textStyle = item.textStyle
        self.needTextBG = item.needTextBG

        self.scale = item.scale
        self.rot = item.rotation
        self.offset = item.offset

        self.isEditable = true
    }

    var body: some View {
        ZClear {
            VStack {
                ZStack {
                    InvisibleTapZoneView(tapCount: 1) {
                        text.isEmpty ? deletePressed() : donePressed()
                    }
                    
                    topBar
                        .padding(.horizontal)
                        .topTool()

                    GeometryReader { geo in
                        FancyTextView(
                            text: Binding {
                                textStyle.uppercased ? text.uppercased() : text
                            } set: { newValue in
                                text = newValue
                            },
                            isEditing: $isEditing,
                            textSize: $textFrameSize,
                            placeholder: placeholder,
                            fontSize: fontSize,
                            textColor: textColor,
                            alignment: .center,
                            textAlignment: textAlignment,
                            textStyle: textStyle,
                            needTextBG: needTextBG,
                            backgroundColor: .clear
                        )
                        .accentColor(AppColors.white)
                        .scaleEffect(scale)
                        .rotationEffect(rot)
                        .offset(offset)
                        .padding(.horizontal, (geo.size.width * textViewPaddingRatio))
                    }

                    let sliderWidth: CGFloat = 40
                    
                    VSlider(value: $fontSize, inManipulation: $sliderInManipulation, in: 16...42)
                        .frame(width: sliderWidth, height: 250)
                        .frame(maxHeight: .infinity, alignment: .center)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical)
                        .offset(x: sliderInManipulation ? 12 : -(sliderWidth / 2))
                        .animation(.interactiveSpring(), value: sliderInManipulation)
                        .isVisible(!fromTemplate)
                }

                bottomBar
                    .padding(.horizontal)

                if colorSelectorOpen {
                    ColorTool(color: Binding {
                        Color(textColor)
                    } set: { newValue in
                        textColor = newValue.uiColor
                    })
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom))
                }
            }
            .onAppear {
                withAnimation(.interactiveSpring()) {
                    scale = 1
                    rot = .zero
                    offset = .zero
                }
            }
        }
        .padding(.vertical, 8)
        .background(backColor)
        .onChange(of: textColor) { value in
            backColor = value.isDarkColor ? AppColors.whiteWithOpacity : AppColors.blackWithOpacity
        }
        .animation(.easeInOut, value: backColor)
        .onChange(of: isEditing) { value in
            if value {
                colorSelectorOpen = false
            }
        }
    }

    @ViewBuilder
    var topBar: some View {
        let images = DI.resolve(VDEVImageConfig.self)
        let doneStr = DI.resolve(VDEVMediaEditorStrings.self).done
        
        HStack {
            Group {
                Button {
                    haptics(.light)
                    toggleAlignment()
                } label: {
                    Image(uiImage: textAlignmentImage())
                }
                .isVisible(!fromTemplate)

                Button {
                    haptics(.light)
                    colorPressed()
                } label: {
                    Image(uiImage: images.textEdit.textEditingColorSelectIcon)
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .scaledToFit()
                }

                Button {
                    haptics(.light)
                    textStylePressed()
                } label: {
                    Image(uiImage: images.common.fontSelect)
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .scaledToFit()
                }

                Button {
                    haptics(.light)
                    needTextBG.toggle()
                } label: {
                    Image(uiImage: images.common.fontBGSelect)
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .scaledToFit()
                        .opacity(needTextBG ? 1 : 0.4)
                }
                .isVisible(!fromTemplate)
                
            }
            .buttonStyle(BlurButtonStyle(sizeClass: .medium(padding: 0)))

            Spacer()

            Button {
                haptics(.light)
                isEditable = false
                donePressed()
            } label: {
                Text(doneStr)
                    .font(AppFonts.gramatika(size: 16))
            }
            .disabled(text.isEmpty && isEditable)
            .buttonStyle(BlurButtonStyle())
        }
    }

    @ViewBuilder
    var bottomBar: some View {
        HStack(alignment: .bottom) {
            let images = DI.resolve(VDEVImageConfig.self)
            let deleteStr = DI.resolve(VDEVMediaEditorStrings.self).delete
            let closeStr = DI.resolve(VDEVMediaEditorStrings.self).close
            
            if isEditable && !fromTemplate {
                Button {
                    haptics(.light)
                    deletePressed()
                } label: {
                    HStack {
                        Image(uiImage: images.textEdit.textEditingRemoveText)
                            .resizable()
                            .frame(width: 35, height: 35)
                            .scaledToFit()

                        Text(deleteStr).font(AppFonts.elmaTrioRegular(14))
                    }
                }
                .buttonStyle(BlurButtonStyle())
            }

            Spacer()

            Button {
                haptics(.light)
                withAnimation(.interactiveSpring()) {
                    colorSelectorOpen = false
                    isEditing = true
                }
            } label: {
                Text(closeStr)
                    .font(AppFonts.gramatika(size: 16))
            }
            .buttonStyle(BlurButtonStyle())
            .opacity(colorSelectorOpen ? 1 : 0)
        }
    }

    private func toggleAlignment() {
        if textAlignment == .center {
            textAlignment = .left
            return
        }

        if textAlignment == .left {
            textAlignment = .right
            return
        }

        if textAlignment == .right {
            textAlignment = .center
            return
        }
    }

    
    private func textAlignmentImage() -> UIImage {
        let images = DI.resolve(VDEVImageConfig.self)
        
        if textAlignment == .center {
            return images.textEdit.textEditingAlignCenter
        }

        if textAlignment == .left {
            return images.textEdit.textEditingAlignLeft
        }

        if textAlignment == .right {
            return images.textEdit.textEditingAlignRight
        }

        return images.textEdit.textEditingAlignCenter
    }

    private func colorPressed() {
        withAnimation(.interactiveSpring()) {
            isEditing.toggle()
            colorSelectorOpen.toggle()
        }
    }

    private func textStylePressed() {
        let currentStyleIndex = (CanvasTextStyle.allCases.firstIndex { $0 == textStyle }) ?? -1
        let newStyleIndex = (currentStyleIndex + 1) % CanvasTextStyle.allCases.count
        textStyle = CanvasTextStyle.allCases[newStyleIndex]
    }

    private func donePressed() {
        defer {
            let scale = textItem?.scale ?? 1
            let rotation = textItem?.rotation ?? .zero
            let offset = textItem?.offset ?? .zero
            let text = text.trimmingCharacters(in: .whitespacesAndNewlines)

            var textFrameSize: CGSize = self.textFrameSize
            if let oldTextFrameSize = textItem?.bounds.size, fromTemplate {
                textFrameSize = oldTextFrameSize
            }
            let newModel = CanvasTextModel(text: text,
                                           placeholder: placeholder,
                                           fontSize: fontSize,
                                           color: textColor,
                                           alignment: alignment,
                                           textAlignment: textAlignment,
                                           textStyle: textStyle,
                                           needTextBG: needTextBG,
                                           textFrameSize: textFrameSize,
                                           offset: offset,
                                           rotation: rotation,
                                           scale: scale,
                                           isMovable: false)
            doneAction(newModel)
        }
        isEditing = false
    }

    private func deletePressed() {
        guard isEditable else { return }
        defer {
            deleteAction()
        }
        isEditing = false
    }
}

private struct ColorTool: View {
    @Binding var color: Color

    private let rowsCount = 10
    private let colsCount = 12

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rowsCount, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<colsCount, id: \.self) { col in
                        let curColor = color(forRow: row, col: col)
                        Button {
                            haptics(.light)
                            color = curColor
                        } label: {
                            Rectangle()
                                .fill(curColor)
                                .overlay(
                                    Rectangle()
                                        .strokeBorder(AppColors.white, lineWidth: 3)
                                        .isVisible(curColor.uiColor == color.uiColor)
                                )
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
        }
        .cornerRadius(15)
    }

    func color(forRow row: Int, col: Int) -> Color {
        let colMult = 1 / Double(colsCount - 1)
        if row < 1 {
            return Color(
                hue: 1,
                saturation: 0,
                brightness: 1 - colMult * Double(col)
            )
        } else {
            let hueStep = (360 / Double(colsCount)) / 360
            let saturation = 0.8
            let baseSaturation = 0.1

            return Color(
                hue: (hueStep * Double(col)),
                saturation: saturation,
                lightness: baseSaturation + (colMult * Double(row))
            )
        }
    }
}

private struct VSlider<V: BinaryFloatingPoint>: View {
    var value: Binding<V>
    @Binding var inManipulation: Bool
    var range: ClosedRange<V> = 0...1
    var step: V.Stride? = nil
    var onEditingChanged: (Bool) -> Void = { _ in }

    private let drawRadius: CGFloat = 13
    private let dragRadius: CGFloat = 25
    private let lineWidth: CGFloat = 20

    @State private var validDrag = false

    init(value: Binding<V>,
         inManipulation: Binding<Bool>,
         in range: ClosedRange<V> = 0...1,
         step: V.Stride? = nil,
         onEditingChanged: @escaping (Bool) -> Void = { _ in }) {
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

extension UIColor {
    var isDarkColor: Bool {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return  lum < 0.50
    }
}
