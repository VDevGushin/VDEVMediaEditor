//
//  TemplateLayerView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 17.02.2023.
//

import SwiftUI
import Kingfisher

struct TemplateLayerView: View {
    @StateObject private var vm: TemplateLayerViewModel
    
    init(item: CanvasTemplateModel, delegate: CanvasEditorDelegate?) {
        _vm = .init(wrappedValue: .init(item: item, delegate: delegate))
    }
    
    var body: some View {
        ZStack() {
            ZStack {
                ForEach(vm.templateLayers, id: \.self) { item in
                    ItemBuilder(item, width: vm.item.bounds.size.width, delegate: vm.delegate)
                }
            }
            .frame(vm.item.bounds.size)
            
            LoadingView(inProgress: vm.isLoading, style: .large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func ItemBuilder(_ item: CanvasItemModel,
                             width: CGFloat,
                             delegate: CanvasEditorDelegate?) -> some View {
        switch item.type {
        case .image:
            let item: CanvasImageModel = CanvasItemModel.toType(model: item)
            Image(uiImage: item.image)
                .resizable()
                .aspectRatio(item.image.aspectRatio, contentMode: .fit)
                .blendMode(item.blendingMode.swiftUI)
                .frame(item.bounds.size)
                .offset(item.offset)
                .disabled(true)
                .allowsHitTesting(false)
            
        case .text:
            let item: CanvasTextModel = CanvasItemModel.toType(model: item)
            FullSizeTextView2(
                text: .constant(item.textStyle.uppercased ?
                                item.text.uppercased() :
                                    item.text),
                fontSize: item.fontSize,
                textColor: item.color,
                textAlignment: item.textAlignment,
                textStyle: item.textStyle,
                needTextBG: item.needTextBG,
                backgroundColor: .clear,
                rect: item.bounds.size,
                isEditing: .constant(false)
            )
            .frame(item.bounds.size)
            .offset(item.offset)
            .allowsHitTesting(false)
            
        case .textForTemplate:
            let item: CanvasTextForTemplateItemModel = CanvasItemModel.toType(model: item)
            TextForTemplateView(item: item, delegate: delegate)
                .frame(item.text.bounds.size)
                .offset(item.text.offset)
        case .placeholder:
            // Meсто загрузки медии в темплейт!
            let item: CanvasPlaceholderModel = CanvasItemModel.toType(model: item)
            PlaceholderTemplateView(item: item, delegate: delegate)
                .blendMode(item.blendingMode.swiftUI)
                .frame(item.bounds.size)
                .clipped()
                .contentShape(Rectangle())
                .offset(item.offset)
            
        default:
            EmptyView()
        }
    }
}
