//
//  CanvasTextModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.02.2023.
//

import SwiftUI

// MARK: - Sticker
final class CanvasTextModel: CanvasItemModel {
    static func with(text: String) -> CanvasTextModel {
        CanvasTextModel(text: text,
                        placeholder: DI.resolve(VDEVMediaEditorStrings.self).defaultPlaceholder,
                        fontSize: 32,
                        color: AppColors.white.uiColor,
                        alignment: .center,
                        textAlignment: .center,
                        textStyle: .basicText,
                        needTextBG: false,
                        textFrameSize: .zero,
                        offset: .zero,
                        rotation: .zero,
                        scale: 1, isMovable: false)
    }
    
    private(set) var text: String
    private(set) var placeholder: String
    private(set) var fontSize: CGFloat
    private(set) var color: UIColor
    private(set) var alignment: Alignment
    private(set) var textAlignment: NSTextAlignment
    private(set) var textStyle: CanvasTextStyle
    private(set) var needTextBG: Bool
    private(set) var isMovable: Bool

    init(
        text: String,
        placeholder: String,
        fontSize: CGFloat,
        color: UIColor,
        alignment: Alignment,
        textAlignment: NSTextAlignment,
        textStyle: CanvasTextStyle,
        needTextBG: Bool,
        textFrameSize: CGSize,
        offset: CGSize,
        rotation: Angle,
        scale: CGFloat,
        isMovable: Bool) {
            self.text = text
            self.placeholder = placeholder
            self.fontSize = fontSize
            self.color = color
            self.alignment = alignment
            self.textAlignment = textAlignment
            self.textStyle = textStyle
            self.needTextBG = needTextBG
            self.isMovable = isMovable
            
            super.init(offset: offset,
                       rotation: rotation,
                       bounds: textFrameSize.rect,
                       scale: scale,
                       type: .text)
        }

    deinit { Log.d("❌ Deinit: CanvasTextModel") }

    override func copy() -> CanvasTextModel {
        let new = CanvasTextModel(text: text,
                                  placeholder: placeholder,
                                  fontSize: fontSize,
                                  color: color,
                                  alignment: alignment,
                                  textAlignment: textAlignment,
                                  textStyle: textStyle,
                                  needTextBG: needTextBG,
                                  textFrameSize: bounds.size,
                                  offset: .zero,
                                  rotation: .zero,
                                  scale: 1,
                                  isMovable: isMovable)
        
        new.update(offset: offset, scale: scale, rotation: rotation)
        
        return new
    }
}
