//
//  TextTools.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import UIKit

struct TextTools {
    static func textBackgroundColor(foregroundColor: UIColor) ->  UIColor {
        if foregroundColor.hexString == "#ffffff".uppercased() {
            return AppColors.white.uiColor.withAlphaComponent(0.3)
        }

        if foregroundColor.hexString == "#000000".uppercased()  {
            return AppColors.black.uiColor.withAlphaComponent(0.3)
        }
        
        let ciColor = CIColor(color: foregroundColor)
        let compRed: CGFloat = 1.0 - ciColor.red
        let compGreen: CGFloat = 1.0 - ciColor.green
        let compBlue: CGFloat = 1.0 - ciColor.blue
        
        return UIColor(
            red: compRed,
            green: compGreen,
            blue: compBlue,
            alpha: 1.0
        )
    }
    
    static func makeLabelImage(
        naturalContainerWidth: CGFloat,
        scale: CGFloat,
        text: String,
        textAlignment: NSTextAlignment,
        textStyle: CanvasTextStyle,
        fontSize: CGFloat,
        textColor: UIColor,
        needTextBG: Bool
    ) -> CIImage {
        let attributes = attributes(
            textAlignment: textAlignment,
            textStyle: textStyle,
            fontSize: fontSize,
            textColor: textColor
        )

        return makeLabelImage(
            string: textStyle.uppercased ? text.uppercased() : text,
            attributes: attributes,
            edgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            container: CGSize(width: naturalContainerWidth / scale, height: .greatestFiniteMagnitude),
            containerBGColor: .clear,
            textBGColor: needTextBG ? textColor.complementary : nil,
            scale: scale
        )
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

    static private func makeLabelImage(
        string: String,
        attributes: [NSAttributedString.Key: Any],
        edgeInsets: UIEdgeInsets,
        container: CGSize,
        containerBGColor: UIColor,
        textBGColor: UIColor?,
        scale: CGFloat
    ) -> CIImage {
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let textContainer = NSTextContainer(
            size: CGSize(
                width: container.width - edgeInsets.left - edgeInsets.right,
                height: container.height - edgeInsets.top - edgeInsets.bottom
            )
        )
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        let textStorage = NSTextStorage(attributedString: attributedString)
        textStorage.addLayoutManager(layoutManager)

        let glyphRange = layoutManager.glyphRange(for: textContainer)
        let boundingRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)

        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: boundingRect.maxX, height: boundingRect.maxY),
            false,
            scale
        )
        defer { UIGraphicsEndImageContext() }
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return CIImage(color: CIColor(color: containerBGColor))
                .cropped(to: CGRect(origin: .zero, size: .init(width: 1, height: 1)))
        }
        layoutManager.drawGlyphs(forGlyphRange: glyphRange, at: .zero)

        guard let image = currentContext.makeImage() else {
            return CIImage(color: CIColor(color: containerBGColor))
                .cropped(to: CGRect(origin: .zero, size: .init(width: 1, height: 1)))
        }

        let textImage = CIImage(cgImage: image).originCropped(to: boundingRect * scale)
        let containerRect = CGRect(
            origin: .zero,
            size: CGSize(
                width: edgeInsets.left * scale + textImage.extent.width + edgeInsets.right * scale,
                height: edgeInsets.top * scale + textImage.extent.height + edgeInsets.bottom * scale
            )
        )
        var containerImage = CIImage(color: CIColor(color: containerBGColor))

        if let textBGColor = textBGColor {
            layoutManager.enumerateLineFragments(
                forGlyphRange: glyphRange
            ) { rect, usedRect, textContainer, glyphRange, stop in
                var usedRect = usedRect
                usedRect.origin.x += edgeInsets.left - boundingRect.origin.x
                usedRect.origin.y += edgeInsets.top - boundingRect.origin.y

                let rectFilter = CIFilter.roundedRectangleGenerator()
                rectFilter.color = CIColor(color: textBGColor)
                rectFilter.extent = (usedRect * scale).insetBy(dx: -3 * scale, dy: -3 * scale)
                rectFilter.radius = Float(5 * scale)
                containerImage = rectFilter.outputImage?
                    .composited(over: containerImage) ?? containerImage
            }

        }
        containerImage = containerImage.cropped(to: containerRect)
            .transformed(by: .init(scaleX: 1, y: -1))
            .transformed(by: .init(translationX: 0, y: containerRect.height))

        return textImage
            .transformed(by: .init(translationX: edgeInsets.left * scale, y: edgeInsets.top * scale))
            .composited(over: containerImage)
    }
}

extension TextTools {
    final class TextView: UITextView {
        private var textBGColor: UIColor?
        
        func update(textBGColor: UIColor?) {
            self.textBGColor = textBGColor
            setNeedsDisplay()
        }

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
                let path = UIBezierPath(
                    roundedRect: usedRect.insetBy(dx: -5, dy: -5),
                    cornerRadius: 5
                )
                ctx.addPath(path.cgPath)
            }
            ctx.fillPath()
        }
    }
}
