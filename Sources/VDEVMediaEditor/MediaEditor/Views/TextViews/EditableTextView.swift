//
//  EditableTextView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.02.2023.
//

import SwiftUI

struct EditableTextView: View {
    @State private var frameSize: CGSize = .zero
    
    @Binding var text: String
    @Binding var isEditing: Bool
    @Binding var textSize: CGSize
    
    let placeholder: String
    let fontSize: CGFloat
    let textColor: UIColor
    let alignment: Alignment
    let textAlignment: NSTextAlignment
    let textStyle: CanvasTextStyle
    let needTextBG: Bool
    let backgroundColor: UIColor

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: alignment) {
                DynamicTextView(
                    text: $text,
                    isEditing: $isEditing,
                    contentSize: $frameSize,
                    textSize: $textSize,
                    fontSize: fontSize,
                    textColor: textColor,
                    textAlignment: textAlignment,
                    textStyle: textStyle,
                    needTextBG: needTextBG,
                    backgroundColor: backgroundColor,
                    isScrollEnabled: false
                )
                .frame(height: frameSize.height)

                if text.isEmpty {
                    Text(placeholder)
                        .multilineTextAlignment(textAlignment.textAlignment)
                        .font(Font(uiFont: textStyle.font(ofSize: fontSize)))
                        .foregroundColor(Color(textColor.withAlphaComponent(0.5)))
                        .frame(maxWidth: .infinity, alignment: textAlignment.horizontalAlignment)
                        .padding(.horizontal, 8)
                        .onTapGesture {
                            isEditing = true
                        }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: alignment)
            .scaleEffect(scaleFactor(forContainer: geo.size), anchor: .center)
        }
    }

    private func scaleFactor(forContainer container: CGSize) -> CGFloat {
        let textSize = CGSize(width: container.width, height: frameSize.height)
        let scaledTextSize = textSize.aspectFit(boundingSize: container)
        let scaleFactor = scaledTextSize.height / frameSize.height
        return scaleFactor.isNaN ? 1 : scaleFactor
    }
}
