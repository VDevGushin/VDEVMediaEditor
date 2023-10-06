//
//  TextForTemplateView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 17.03.2023.
//

import SwiftUI

// Текст в шаблоне - на который нажимает юзер
struct TextForTemplateView: View {
    @Environment(\.guideLinesColor) private var guideLinesColor
    @StateObject private var vm: TextForTemplateViewModel
    
    init(
        item: CanvasTextForTemplateItemModel,
        delegate: CanvasEditorDelegate?
    ) {
        _vm = .init(
            wrappedValue: .init(
                item: item,
                delegate: delegate
            )
        )
    }
    
    var body: some View {
        let text = vm.text.textStyle.uppercased ? vm.text.text.uppercased() : vm.text.text
        
        TemplateEditableTextView(
            text: .constant(text),
            isEditing: .constant(false),
            textSize: .constant(.zero),
            placeholder: vm.text.placeholder,
            fontSize: vm.text.fontSize,
            textColor: vm.text.color,
            alignment: vm.text.alignment,
            textAlignment: vm.text.textAlignment,
            textStyle: vm.text.textStyle,
            needTextBG: vm.text.needTextBG,
            backgroundColor: .clear
        )
        .overlay(AppColors.black.opacity(0.0001))
        .blendMode(vm.text.blendingMode.swiftUI)
        .onTapGesture {
            haptics(.light)
            vm.editText()
        }
        .background(AppColors.whiteWithOpacity4)
        .clipShape(RoundedCorner(radius: 6))
        .viewDidLoad {
            vm.updateSize(vm.text.bounds.size)
        }
    }
}
