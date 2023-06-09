//
//  LayersView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//

import SwiftUI

struct LayersView: View {
    @EnvironmentObject private var vm: CanvasEditorViewModel
    @Injected private var images: VDEVImageConfig
    @Injected private var strings: VDEVMediaEditorStrings
    @Injected private var settings: VDEVMediaEditorSettings
    @Injected private var removeLayersService: RemoveLayersService
    
    var body: some View {
        Group {
            if !vm.tools.openLayersList {
                ImageButton(image: images.common.layers,
                            title: strings.layers,
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
                    
                    ImageButton(image: images.common.close,
                                title: strings.close,
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
                        
                        if !vm.data.isEmpty && settings.canRemoveAllLayers {
                            // Удаление всего
                            NoShadowRoundButtonSystem(image: Image(systemName: "rectangle.on.rectangle.slash.fill"),
                                                      size: 40,
                                                      backgroundColor: AppColors.layerButtonsLightBlack,
                                                      tintColor: AppColors.white) {
                                removeLayersService.needToRemoveAllLayers()
                                vm.tools.openLayersList(false)
                                Log.d("Remove all layeres")
                            }.scaleEffect(0.95)
                        }
                        
                        //Рисовалка заднего фона
                        NoShadowRoundButton(image: images.common.bg,
                                            size: 40,
                                            backgroundColor: AppColors.layerButtonsLightBlack,
                                            tintColor: AppColors.white) {
                            vm.tools.openLayersList(false)
                            vm.tools.seletedTool(.backgroundColor)
                            Log.d("Select tool backgroundColor")
                        }.scaleEffect(0.95)
                        
                        if settings.showAspectRatioSettings {
                            //Aspect ratio
                            NoShadowRoundButtonSystem(image: Image(systemName: "aspectratio"),
                                                      size: 40,
                                                      backgroundColor: AppColors.layerButtonsLightBlack,
                                                      tintColor: AppColors.white) {
                                vm.tools.openLayersList(false)
                                vm.tools.seletedTool(.aspectRatio)
                                Log.d("Select tool aspect ratio")
                            }.scaleEffect(0.95)
                        }
                        
                        if settings.showCommonSettings {
                            //Format
                            NoShadowRoundButtonSystem(image: Image(systemName: "gearshape"),
                                                      size: 40,
                                                      backgroundColor: AppColors.layerButtonsLightBlack,
                                                      tintColor: AppColors.white) {
                                vm.tools.openLayersList(false)
                                vm.tools.seletedTool(.settings)
                                Log.d("Select tool settings")
                            }.scaleEffect(0.95)
                        }
                    }
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(BlurView(style: .systemChromeMaterialDark))
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

