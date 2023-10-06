//
//  TemplateEditableTextView.swift
//  
//
//  Created by Vladislav Gushin on 06.10.2023.
//

import SwiftUI

struct TemplateEditableTextView: View {
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
                isScrollEnabled: true
            )
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: textAlignment.horizontalAlignment
            )
            
            if text.isEmpty {
                DynamicTextView(
                    text: .constant(placeholder),
                    isEditing: .constant(false),
                    contentSize: $frameSize,
                    textSize: $textSize,
                    fontSize: fontSize,
                    textColor: textColor.withAlphaComponent(0.5),
                    textAlignment: textAlignment,
                    textStyle: textStyle,
                    needTextBG: needTextBG,
                    backgroundColor: backgroundColor,
                    isScrollEnabled: true
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: textAlignment.horizontalAlignment
                )
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: alignment
        )
    }
}
