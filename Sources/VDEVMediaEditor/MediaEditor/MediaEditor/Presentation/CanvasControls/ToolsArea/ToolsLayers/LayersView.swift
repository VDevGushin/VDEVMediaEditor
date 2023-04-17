//
//  LayersView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//

import SwiftUI

extension LayersView {
    enum Strings {
        static let close = "CLOSE"
        static let layers = "LAYERS"
    }
}


struct LayersView: View {
    @EnvironmentObject private var vm: CanvasEditorViewModel
    
    var body: some View {
        Group {
            if !vm.tools.openLayersList {
                ImageButton(imageName: "Layers",
                            title: Strings.layers,
                            fontSize: 9,
                            size: .init(width: 44, height: 44),
                            tintColor: AppColors.whiteWithOpacity,
                            resizeImage: true) {
                    vm.tools.openLayersList(true)
                    Log.d("Show layers menu")
                }.transition(.leadingTransition)
            } else {
                VStack(alignment: .center) {
                    Layers()
                    
                    ImageButton(imageName: "Close",
                                title: Strings.close,
                                fontSize: 9,
                                size: .init(width: 44, height: 44),
                                tintColor: AppColors.whiteWithOpacity,
                                resizeImage: true) {
                        vm.tools.openLayersList(false)
                        Log.d("Hide layers menu")
                    }.padding(.top, 10)
                }
                .transition(.leadingTransition)
            }
        }
        .frame(width: 55)
    }
    
    @ViewBuilder
    private func Layers() -> some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Spacer()
                    
                    VStack(alignment: .center) {
                        ReorderableForEach($vm.data.layers, allowReordering: .constant(true)) { item, isDragged in
                            Button(action: {
                                vm.tools.seletedTool(.concreteItem(item))
                            }) {
                                CanvasItemPreiviewViewBuilder(item, size: 40)
                                    .frame(width: 40,
                                           height: 40, alignment: .center)
                                    .background(AppColors.layerButtonsLightGray)
                                    .cornerRadius(3)
                                    .setLayerScale(item, vm: vm.tools)
                                    .clipShape(Rectangle())
                                    .overlay(isDragged ? AppColors.white.opacity(0.2) : AppColors.clear)
                            }
                            .animation(.interactiveSpring(), value: vm.data.layers)
                        }
                        
                        //Рисовалка заднего фона
                        NoShadowRoundButton(imageName: "Bg",
                                            size: 40,
                                            backgroundColor: AppColors.layerButtonsLightBlack,
                                            tintColor: AppColors.white) {
                            vm.tools.openLayersList(false)
                            vm.tools.seletedTool(.backgroundColor)
                            Log.d("Select tool backgroundColor")
                        }.scaleEffect(0.95)
                    }
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(
                        BlurView(style: .systemChromeMaterialDark)
                    )
                    //.background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .frame(minHeight: proxy.size.height)
            }
        }
    }
}

fileprivate extension View {
    @ViewBuilder
    func setLayerScale(_ item: CanvasItemModel, vm: CanvasToolsViewModel) -> some View {
        let disabled = vm.needDisableIfNotCurrent(item: item)
        self.opacity(disabled ? 0.4 : 1.0)
            .scaleEffect(disabled ? 0.8 : 0.95)
    }
}

