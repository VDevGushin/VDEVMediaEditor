//
//  TextForTemplateView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 17.03.2023.
//

import SwiftUI

struct TextForTemplateView: View {
    @StateObject private var vm: TextForTemplateViewModel
    
    @Environment(\.guideLinesColor) private var guideLinesColor
    
    init(item: CanvasTextForTemplateItemModel, delegate: CanvasEditorDelegate?) {
        _vm = .init(wrappedValue: .init(item: item, delegate: delegate))
    }
    
    var body: some View {
        let item: CanvasTextModel = vm.text
        
        FancyTextView(
            text:.constant(item.textStyle.uppercased ?
                           item.text.uppercased() :
                            item.text),
            isEditing: .constant(false),
            textSize: .constant(.zero),
            placeholder: item.placeholder,
            fontSize: item.fontSize,
            textColor: item.color,
            alignment: item.alignment,
            textAlignment: item.textAlignment,
            textStyle: item.textStyle,
            needTextBG: item.needTextBG,
            backgroundColor: .clear
        )
        .overlay(
            AppColors.black.opacity(0.0001)
        )
        .blendMode(item.blendingMode.swiftUI)
        .onTapGesture { vm.editText() }
    }
}
