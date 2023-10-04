//
//  TemplateStaticTextView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 17.02.2023.
//

import SwiftUI

struct TemplateStaticTextView: View {
    private var text: String
    private let fontSize: CGFloat
    private let textColor: UIColor
    private let textAlignment: NSTextAlignment
    private let textStyle: CanvasTextStyle
    private let needTextBG: Bool
    private let backgroundColor: UIColor
    private let rect: CGSize
    
    init(
        text: String,
        fontSize: CGFloat,
        textColor: UIColor,
        textAlignment: NSTextAlignment,
        textStyle: CanvasTextStyle,
        needTextBG: Bool,
        backgroundColor: UIColor,
        rect: CGSize
    ) {
        self.text = text
        self.fontSize = fontSize
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.textStyle = textStyle
        self.needTextBG = needTextBG
        self.backgroundColor = backgroundColor
        self.rect = rect
    }

    var body: some View {
        StaticTextView(
            text: .constant(text),
            isEditing: .constant(false),
            fontSize: fontSize,
            textColor: textColor,
            textAlignment: textAlignment,
            textStyle: textStyle,
            needTextBG: needTextBG,
            backgroundColor: backgroundColor)
        .frame(rect)
    }
}

private struct StaticTextView: UIViewRepresentable {
    @Binding private var text: String
    @Binding private var isEditing: Bool
    
    private let fontSize: CGFloat
    private let textColor: UIColor
    private let textAlignment: NSTextAlignment
    private let textStyle: CanvasTextStyle
    private let needTextBG: Bool
    private let backgroundColor: UIColor
    
    init(text: Binding<String>,
         isEditing: Binding<Bool>,
         fontSize: CGFloat,
         textColor: UIColor,
         textAlignment: NSTextAlignment,
         textStyle: CanvasTextStyle,
         needTextBG: Bool,
         backgroundColor: UIColor
    ) {
        self._text = text
        self._isEditing = isEditing
        self.fontSize = fontSize
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.textStyle = textStyle
        self.needTextBG = needTextBG
        self.backgroundColor = backgroundColor
    }
    
    func makeCoordinator() -> Coordinator {
        .init(parent: self)
    }

    func makeUIView(context: Context) -> UITextView {
        let view = TextTools.TextView()
        defer { DispatchQueue.main.async { view.setNeedsDisplay() } }
        view.autocorrectionType = UITextAutocorrectionType.no
        view.spellCheckingType = UITextSpellCheckingType.no
        view.autocapitalizationType = UITextAutocapitalizationType.none
        view.textContainerInset = .init(
            top: 8,
            left: 8,
            bottom: 8,
            right: 8
        )
        view.contentInsetAdjustmentBehavior = .never
        view.delegate = context.coordinator
        view.update(textBGColor: needTextBG ? TextTools.textBackgroundColor(foregroundColor: textColor) : nil)
        return view
    }

    func updateUIView(
        _ uiView: UITextView,
        context: Context
    ) {
        uiView.textAlignment = textAlignment
        uiView.font = textStyle.font(ofSize: fontSize)
        
        let attributes = context.coordinator.attributes(
            textAlignment: textAlignment,
            textStyle: textStyle,
            fontSize: fontSize,
            textColor: textColor
        )
        
        uiView.attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
        
        uiView.backgroundColor = backgroundColor
        
        (uiView as? TextTools.TextView)?
            .update(textBGColor: needTextBG ? TextTools.textBackgroundColor(foregroundColor: textColor) : nil)
        
        if isEditing {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        private let parent: StaticTextView

        init(parent: StaticTextView) {
            self.parent = parent
        }

        public func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textView.text
            }
        }
        
        func attributes(
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
}
