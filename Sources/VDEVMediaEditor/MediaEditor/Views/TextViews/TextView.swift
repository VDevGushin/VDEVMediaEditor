//
//  TextView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.02.2023.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isEditing: Bool
    
    let fontSize: CGFloat
    let textColor: UIColor
    let textAlignment: NSTextAlignment
    let textStyle: CanvasTextStyle
    let needTextBG: Bool
    let backgroundColor: UIColor
    var contentSizeChange: ((CGSize) -> ())?
    var onFrameSize: ((CGSize) -> Void)?

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

    func makeCoordinator() -> Coordinator { .init(parent: self) }

    func makeUIView(context: Context) -> UITextView {
        let view = _UITextView()
        view.textContainerInset = .init(top: 8, left: 8, bottom: 8, right: 8)
        view.contentInsetAdjustmentBehavior = .never
        view.delegate = context.coordinator
        view.textBGColor = needTextBG ? bgC : nil
        DispatchQueue.main.async { view.setNeedsDisplay() }
        return view
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.textAlignment = textAlignment
        uiView.font = textStyle.font(ofSize: fontSize)

        let attributes = TextView.attributes(
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

        DispatchQueue.main.async {
            let glyphRange = uiView.layoutManager.glyphRange(for: uiView.textContainer)

            let boundingRect = uiView.layoutManager.boundingRect(forGlyphRange: glyphRange, in: uiView.textContainer)

            contentSizeChange?(boundingRect.size.extended(insets: uiView.textContainerInset))

            if isEditing {
                uiView.becomeFirstResponder()
            } else {
                uiView.resignFirstResponder()
            }

            let fixedWidth = uiView.frame.size.width
            let newSize = uiView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
            onFrameSize?(newSize)
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

    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView

        init(parent: TextView) {
            self.parent = parent
        }

        public func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textView.text
            }
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
