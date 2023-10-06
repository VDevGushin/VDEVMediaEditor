//
//  TextTool.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.02.2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import Combine

@MainActor
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
    @State private var isEditable: Bool
    @State private var textFrameSize: CGSize = .zero
    @State private var sliderInManipulation: Bool = false
    @State private var backColor: Color
    
    private var textItem: CanvasTextModel?
    private let fromTemplate: Bool
    private let onComplete: (CanvasTextModel?) -> ()
    
    private var textAlignmentImage: UIImage {
        let images = DI.resolve(VDEVImageConfig.self)
        var result: UIImage = images.textEdit.textEditingAlignCenter
        switch textAlignment {
        case .left:
            result = images.textEdit.textEditingAlignLeft
        case .right:
            result = images.textEdit.textEditingAlignRight
        default:
            break
        }
        return result
    }

    init(
        textItem: CanvasTextModel? = nil,
        fromTemplate: Bool = false,
        onComplete: @escaping (CanvasTextModel?) -> ()
    ) {
        self.fromTemplate = fromTemplate
        self.textItem = textItem
        self.onComplete = onComplete
        
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
        self.isEditable = true
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
                .padding(.horizontal)
            
            ZStack {
                InvisibleTapZoneView(tapCount: 1) {
                    text.isEmpty ? deletePressed() : donePressed()
                }
                
                EditableTextView(
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
                .padding(.horizontal, 12)
                
                IF(!fromTemplate) {
                    let sliderWidth: CGFloat = 32
                    VSlider(
                        value: $fontSize,
                        inManipulation: $sliderInManipulation,
                        in: 16...42
                    )
                    .frame(width: sliderWidth, height: 250)
                    .frame(maxHeight: .infinity, alignment: .center)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                    .offset(x: sliderInManipulation ? 12 : -(sliderWidth / 2))
                    .animation(.interactiveSpring(), value: sliderInManipulation)
                }
            }
            
            IF(colorSelectorOpen) {
                ColorTool(color: Binding {
                    Color(textColor)
                } set: { newValue in
                    textColor = newValue.uiColor
                }){
                    withAnimation(.interactiveSpring()) {
                        colorSelectorOpen = false
                        isEditing = true
                    }
                }
                .padding(.horizontal)
                .transition(.bottomTransition)
            }
        }
        .padding(.vertical, 8)
        .background(backColor)
        .background {
            AnimatedGradientViewVertical(
                color: AppColors.whiteWithOpacity2,
                duration: 2,
                blur: 20
            )
        }
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
                IF(!fromTemplate) {
                    Button {
                        haptics(.light)
                        textAlignmentPressed()
                    } label: {
                        Image(uiImage: textAlignmentImage)
                    }
                }

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

                IF(!fromTemplate) {
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
                }
            }
            .buttonStyle(BlurButtonStyle(sizeClass: .medium(padding: 0)))

            Spacer()
            
            IF(isEditable && !fromTemplate) {
                Button {
                    haptics(.light)
                    deletePressed()
                } label: {
                    Image(uiImage: images.textEdit.textEditingRemoveText)
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .scaledToFit()
                }
                .buttonStyle(BlurButtonStyle(sizeClass: .medium(padding: 0)))
            }

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
}

// MARK: - Actions
private extension TextTool {
    func colorPressed() {
        isEditing.toggle()
        colorSelectorOpen.toggle()
    }

    func textStylePressed() {
        let currentStyleIndex = (CanvasTextStyle.allCases.firstIndex { $0 == textStyle }) ?? -1
        let newStyleIndex = (currentStyleIndex + 1) % CanvasTextStyle.allCases.count
        textStyle = CanvasTextStyle.allCases[newStyleIndex]
    }

    func donePressed() {
        isEditing = false
        
        let scale = textItem?.scale ?? 1
        let rotation = textItem?.rotation ?? .zero
        let offset = textItem?.offset ?? .zero
        let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        var textFrameSize: CGSize = textFrameSize
        
        if let oldTextFrameSize = textItem?.bounds.size, fromTemplate {
            textFrameSize = oldTextFrameSize
        }
        
        let newModel = CanvasTextModel(
            text: text,
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
            isMovable: false
        )
        
        onComplete(newModel)
    }

    func textAlignmentPressed() {
        switch textAlignment {
        case .center:
            textAlignment = .left
        case .left:
            textAlignment = .right
        case .right:
            textAlignment = .center
        default:
            textAlignment = .center
        }
    }
    
    func deletePressed() {
        guard isEditable else { return }
        defer { onComplete(nil) }
        isEditing = false
    }
}
