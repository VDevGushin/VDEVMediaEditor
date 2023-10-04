//
//  DynamicTextView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.02.2023.
//

import SwiftUI

struct DynamicTextView: UIViewRepresentable {
    @Binding private var text: String
    @Binding private var isEditing: Bool
    @Binding private var contentSize: CGSize
    @Binding private var textSize: CGSize
    
    private let fontSize: CGFloat
    private let textColor: UIColor
    private let textAlignment: NSTextAlignment
    private let textStyle: CanvasTextStyle
    private let needTextBG: Bool
    private let backgroundColor: UIColor
    
    init(text: Binding<String>,
         isEditing: Binding<Bool>,
         contentSize: Binding<CGSize>,
         textSize: Binding<CGSize>,
         fontSize: CGFloat,
         textColor: UIColor,
         textAlignment: NSTextAlignment,
         textStyle: CanvasTextStyle,
         needTextBG: Bool,
         backgroundColor: UIColor
    ) {
        self._text = text
        self._isEditing = isEditing
        self._contentSize = contentSize
        self._textSize = textSize
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
        defer {
            context.coordinator.makeResults(with: uiView)
        }
        
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
        uiView.textAlignment = textAlignment
        uiView.font = textStyle.font(ofSize: fontSize)
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
        private let parent: DynamicTextView
        
        init(parent: DynamicTextView) {
            self.parent = parent
        }
        
        public func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async { [weak self] in
                self?.parent.text = textView.text
            }
        }
        
        func makeResults(with uiView: UITextView) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                let glyphRange = uiView
                    .layoutManager
                    .glyphRange(for: uiView.textContainer)
                
                let boundingRect = uiView
                    .layoutManager
                    .boundingRect(
                        forGlyphRange: glyphRange,
                        in: uiView.textContainer
                    )
                
                let fixedWidth = uiView.frame.size.width
                
                self.parent.contentSize = boundingRect
                    .size
                    .extended(insets: uiView.textContainerInset)
                
                self.parent.textSize = uiView.sizeThatFits(
                    CGSize(
                        width: fixedWidth,
                        height: CGFloat.greatestFiniteMagnitude
                    )
                )
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
