//
//  TemplateSelectorView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 16.02.2023.
//

import SwiftUI
import Resolver

struct TemplateSelectorView: View {
    @StateObject private var vm: TemplateSelectorViewModel
    @State private var size: CGSize

    init(_ size: CGSize,
         challengeId: String,
         onClose: @escaping ([TemplatePack.Variant.Item]) -> Void) {
        self.size = size
        
        self._vm = .init(wrappedValue: .init(fitCanvasSize: size, challengeId: challengeId, onClose: onClose))
    }

    var body: some View {
        ZStack(alignment: .top) {
            if !vm.isLoading {
                AppColors.black.opacity(0.6)
                    .transition(.opacity)
            }

            Color.clear
                .frame(size)
                .clipShape(RoundedCorner(radius: 12))

            if !vm.isLoading { tools }
            
        }.overlay(alignment: .center) {
            LoadingView(inProgress: vm.isLoading, style: .large)
        }
        .animation(.interactiveSpring(), value: vm.isLoading)
    }

    var tools: some View {
        ToolWrapper(title: vm.templatePackForPreview == nil ? Resolver.resolve(VDEVEditorStrings.self).templatePack : vm.templatePackForPreview!.name, fullScreen: false) {
            if vm.templatePackForPreview == nil {
                vm.clearSelectedTool()
                vm.select()
            } else {
                vm.clearSelectedTool()
            }
        } tool: {
            TemplateSelector(
                dataSource: vm.templatesDataSource,
                selectedTemplatePack: $vm.templatePackForPreview,
                selectedVariant: vm.selectedVariant
            ) { templatePack, variantIdx in
                vm.setTemplatePack(templatePack, variantIdx: variantIdx)
            }
        }
    }
}
