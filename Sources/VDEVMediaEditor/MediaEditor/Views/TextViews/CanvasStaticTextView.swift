//
//  CanvasStaticTextView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 15.02.2023.
//

import SwiftUI

struct CanvasStaticTextView: UIViewRepresentable {
    let text: String
    let fontSize: CGFloat
    let textColor: UIColor
    let textAlignment: NSTextAlignment
    let textStyle: CanvasTextStyle
    let needTextBG: Bool
    let backgroundColor: UIColor

    func makeUIView(context: Context) -> UITextView {
        let view = TextTools.TextView()
        view.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        view.contentInsetAdjustmentBehavior = .never
        view.update(textBGColor: needTextBG ? TextTools.textBackgroundColor(foregroundColor: textColor) : nil)
        view.isScrollEnabled = false
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.textAlignment = textAlignment
        uiView.font = textStyle.font(ofSize: fontSize)
        uiView.isEditable = false
        uiView.isUserInteractionEnabled = false

        let attributes = makeAttributes(
            textAlignment: textAlignment,
            textStyle: textStyle,
            fontSize: fontSize,
            textColor: textColor
        )

        uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
        uiView.backgroundColor = backgroundColor

        (uiView as? TextTools.TextView)?
            .update(textBGColor: needTextBG ? TextTools.textBackgroundColor(foregroundColor: textColor) : nil)
    }

    private func makeAttributes(
        textAlignment: NSTextAlignment,
        textStyle: CanvasTextStyle,
        fontSize: CGFloat,
        textColor: UIColor
    ) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineHeightMultiple = textStyle.lineHeightMultiple

        var attributes: [NSAttributedString.Key: Any] = [
            .font: textStyle.font(ofSize: fontSize),
            .foregroundColor: textColor,
            .kern: textStyle.kern,
            .paragraphStyle: paragraphStyle
        ]
        if let shadowCfg = textStyle.shadow {
            let shadow = NSShadow()
            shadow.shadowOffset = shadowCfg.offset
            shadow.shadowBlurRadius = shadowCfg.blur
            shadow.shadowColor = shadowCfg.color

            attributes[.shadow] = shadow
        }
        return attributes
    }
}
