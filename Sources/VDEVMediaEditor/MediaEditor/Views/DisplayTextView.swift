//
//  DisplayTextView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 15.02.2023.
//

import SwiftUI

struct DisplayTextView: UIViewRepresentable {
    let text: String
    let fontSize: CGFloat
    let textColor: UIColor
    let textAlignment: NSTextAlignment
    let textStyle: CanvasTextStyle
    let needTextBG: Bool
    let backgroundColor: UIColor

    private var bgC: UIColor {
        if textColor.hexString == "#ffffff".uppercased() {
            return AppColors.white.uiColor.withAlphaComponent(0.3)
        }

        if textColor.hexString == "#000000".uppercased()  {
            return AppColors.black.uiColor.withAlphaComponent(0.3)
        }

        let ciColor = CIColor(color: textColor)
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        return UIColor(red: compRed, green: compGreen, blue: compBlue, alpha: 1.0)
    }

    func makeUIView(context: Context) -> UITextView {
        let view = _UITextView()
        view.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        view.contentInsetAdjustmentBehavior = .never
        view.textBGColor = needTextBG ? bgC : nil
        DispatchQueue.main.async { view.setNeedsDisplay() }
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.textAlignment = textAlignment
        uiView.font = textStyle.font(ofSize: fontSize)
        uiView.isEditable = false
        uiView.isUserInteractionEnabled = false

        let attributes = DisplayTextView.attributes(
            textAlignment: textAlignment,
            textStyle: textStyle,
            fontSize: fontSize,
            textColor: textColor
        )

        uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
        uiView.backgroundColor = backgroundColor

        if let _uiView = uiView as? _UITextView {
            _uiView.textBGColor = needTextBG ? bgC : nil
            DispatchQueue.main.async { _uiView.setNeedsDisplay() }
        }
    }

    private class _UITextView: UITextView {
        var textBGColor: UIColor?

        override func draw(_ rect: CGRect) {
            guard let ctx = UIGraphicsGetCurrentContext(),
                  let textBGColor = textBGColor else {
                super.draw(rect)
                return
            }

            ctx.setFillColor(textBGColor.cgColor)

            let glyphRange = layoutManager.glyphRange(for: textContainer)
            layoutManager.enumerateLineFragments(
                forGlyphRange: glyphRange
            ) { [textContainerInset] rect, usedRect, textContainer, glyphRange, stop in
                var usedRect = usedRect
                usedRect.origin.y += textContainerInset.top
                usedRect.origin.x += textContainerInset.left
                let path = UIBezierPath(roundedRect: usedRect.insetBy(dx: -5, dy: -5), cornerRadius: 5)
                ctx.addPath(path.cgPath)
            }
            ctx.fillPath()
        }
    }

    static private func attributes(
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
