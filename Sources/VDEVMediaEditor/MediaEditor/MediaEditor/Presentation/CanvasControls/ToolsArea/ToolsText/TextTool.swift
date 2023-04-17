//
//  TextTool.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.02.2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import Combine

let kDefaultPlaceholder = "Write here"

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

    private var backgroundColor: Color = AppColors.black
    private var textItem: CanvasTextModel?
    private let fromTemplate: Bool

    private let labelContainerToCanvasWidthRatio: CGFloat
    private let doneAction: (CanvasTextModel) -> ()
    private let deleteAction: () -> ()

    private var textViewPaddingRatio: CGFloat { (1 - labelContainerToCanvasWidthRatio) / 2 }

    @MainActor
    init(
        textItem: CanvasTextModel? = nil,
        backgroundColor: Color,
        labelContainerToCanvasWidthRatio: CGFloat,
        fromTemplate: Bool = false,
        doneAction: @escaping (CanvasTextModel) -> (),
        deleteAction: @escaping () -> ()
    ) {
        self.fromTemplate = fromTemplate
        self.backgroundColor = backgroundColor
        self.textItem = textItem
        self.labelContainerToCanvasWidthRatio = labelContainerToCanvasWidthRatio
        self.doneAction = doneAction
        self.deleteAction = deleteAction

        guard let item = textItem else {
            self.text = ""
            self.placeholder = kDefaultPlaceholder
            self.fontSize = 32
            self.textColor = UIColor(backgroundColor).contrast
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
        ZStack {
            Color.clear

            VStack {
                topBar
                    .padding(.horizontal)

                ZStack {
                    AppColors.white.opacity(0.001)
                        .onTapGesture {
                            _ = text.isEmpty ? deletePressed() : donePressed()
                        }

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
                        .frame(width: sliderWidth, height: 300)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
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
        .background(
            backgroundColor.ignoresSafeArea()
        )
    }

    var topBar: some View {
        HStack {
            Group {
                if !fromTemplate {
                    Button {
                        haptics(.light)
                        toggleAlignment()
                    } label: {
                        Image(textAlignmentImageName())
                    }
                }

                Button {
                    haptics(.light)
                    colorPressed()
                } label: {
                    Image("TextEditingColorSelectIcon")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .scaledToFit()
                }

                Button {
                    haptics(.light)
                    textStylePressed()
                } label: {
                    Image("FontSelectIcon")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .scaledToFit()
                }

                if !fromTemplate {
                    Button {
                        haptics(.light)
                        needTextBG.toggle()
                    } label: {
                        Image("FontBGSelectIcon")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                            .scaledToFit()
                            .opacity(needTextBG ? 1 : 0.4)
                    }
                }
            }
            .buttonStyle(BlurButtonStyle(sizeClass: .medium(padding: 0)))

            Spacer()

            Button {
                haptics(.light)
                isEditable = false
                donePressed()
            } label: {
                Text("Done")
                    .font(.gramatika(size: 16))
            }
            .disabled(text.isEmpty && isEditable)
            .buttonStyle(BlurButtonStyle())
        }
    }

    var bottomBar: some View {
        HStack(alignment: .bottom) {
            if isEditable {
                Button {
                    haptics(.light)
                    deletePressed()
                } label: {
                    HStack {
                        Image("TextEditingRemoveText")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .scaledToFit()

                        Text("Delete").font(AppFonts.elmaTrioRegular(14))
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
                Text("Close")
                    .font(.gramatika(size: 16))
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

    private func textAlignmentImageName() -> String {
        if textAlignment == .center {
            return "TextEditingAlignCenter"
        }

        if textAlignment == .left {
            return "TextEditingAlignleft"
        }

        if textAlignment == .right {
            return "TextEditingAlignright"
        }

        return "TextEditingAlignCenter"
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

        let scale = textItem?.scale ?? 1
        let rotation = textItem?.rotation ?? .zero
        let offset = textItem?.offset ?? .zero
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)

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
                                       scale: scale, isMovable: false)
        doneAction(newModel)
    }

    private func deletePressed() {
        guard isEditable else { return }
        deleteAction()
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

private struct BlurButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    enum SizeClass {
        case small
        case medium(padding: CGFloat)
        static let medium = SizeClass.medium(padding: 10)
        case big

        var frame: CGSize {
            switch self {
            case .medium: return CGSize(width: 42, height: 42)
            case .big: return CGSize(width: 50, height: 50)
            case .small: return CGSize(width: 85, height: 30)
            }
        }

        var horPadding: CGFloat {
            switch self {
            case .medium(let padding): return padding
            default: return 10
            }
        }

        var maxHeight: CGFloat? {
            switch self {
            case .small: return 30
            default: return nil
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return 15
            default: return 12
            }
        }
    }

    var sizeClass: SizeClass = .medium
    var tintColor: Color = .clear

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isEnabled ? AppColors.white :
                    AppColors.gray)
            .padding(.horizontal, sizeClass.horPadding)
            .frame(
                minWidth: sizeClass.frame.width,
                minHeight: sizeClass.frame.height,
                maxHeight: sizeClass.maxHeight
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .background(
                ZStack {
                    tintColor
                        .opacity(0.8)

                    BlurView(style: .systemChromeMaterialDark)
                }
                    .cornerRadius(sizeClass.cornerRadius)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
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
                        Rectangle()
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height - self.getPoint(in: geometry).y)
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
