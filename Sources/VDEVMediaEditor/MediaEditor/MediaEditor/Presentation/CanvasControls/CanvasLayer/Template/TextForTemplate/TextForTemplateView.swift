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
    
    @State private var size: CGSize = .zero
    
    init(item: CanvasTextForTemplateItemModel, delegate: CanvasEditorDelegate?) {
        _vm = .init(wrappedValue: .init(item: item, delegate: delegate))
    }
    
    var body: some View {
        FancyTextView(
            text:.constant(vm.text.textStyle.uppercased ?
                           vm.text.text.uppercased() :
                            vm.text.text),
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
        .overlay(
            AppColors.black.opacity(0.0001)
        )
        .blendMode(vm.text.blendingMode.swiftUI)
        .onTapGesture {
            haptics(.light)
            vm.editText()
        }
        .fetchSize($size)
        .onChange(of: size) { value in vm.updateSize(value) }
    }
}
