//
//  LayersView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//

import SwiftUI
import Combine
import IdentifiedCollections

final class LayersViewVM: ObservableObject {
    @Injected private var settings: VDEVMediaEditorSettings
    @Published private(set) var canMergeLayers: Bool = false
    private var storage = Cancellables()
    
    var canMergeAllLayers: Bool {
        settings.canMergeAllLayers
    }
    
    var canRemoveAllLayers: Bool {
        settings.canRemoveAllLayers
    }
    
    var showAspectRatioSettings: Bool {
        settings.showAspectRatioSettings
    }
    
    var showCommonSettings: Bool {
        settings.showCommonSettings
    }
    
    init(layers: Published<IdentifiedArrayOf<CanvasItemModel>>.Publisher) {
        
        let hasVideos = layers
            .flatMap { result -> AnyPublisher<Bool, Never> in
                result.elements.withVideoAsync()
            }
        
        let moreThenOne = layers.map { result -> Bool in result.count > 1 }
        
        moreThenOne.combineLatest(hasVideos)
            .map { moreThenOne, hasVideos in
                moreThenOne && !hasVideos
            }
            .removeDuplicates()
            .sink(
                on: .main,
                object: self
            ) { wSelf, value in
                wSelf.canMergeLayers = value
            }
            .store(in: &storage)
    }
}

struct LayersView: View {
    @Injected private var images: VDEVImageConfig
    @Injected private var strings: VDEVMediaEditorStrings
    @Injected private var removeLayersService: RemoveLayersService
    
    @ObservedObject private var vm: CanvasEditorViewModel
    @StateObject private var innerVM: LayersViewVM
    
    private var mementoObject: MementoObject? { vm.data }
    
    init(vm: CanvasEditorViewModel) {
        self.vm = vm
        _innerVM = .init(wrappedValue: .init(layers: vm.data.$layers))
    }
    
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
                        } completion: {
                            mementoObject?.forceSave()
                        }
                        
                        if innerVM.canMergeAllLayers &&
                            innerVM.canMergeLayers {
                            // Мерж всех слоев
                            NoShadowRoundButtonSystem(
                                image: Image(systemName: "photo.fill.on.rectangle.fill"),
                                size: 40,
                                backgroundColor: AppColors.layerButtonsLightBlack,
                                tintColor: AppColors.white
                            ) {
                                Log.d("Merge all layeres")
                                mementoObject?.forceSave()
                                vm.tools.openLayersList(false)
                                vm.onMergeAllLayers()
                            }.scaleEffect(0.95)
                        }
                        
                        if !vm.data.isEmpty && innerVM.canRemoveAllLayers {
                            // Удаление всего
                            NoShadowRoundButtonSystem(
                                image: Image(systemName: "rectangle.on.rectangle.slash.fill"),
                                size: 40,
                                backgroundColor: AppColors.layerButtonsLightBlack,
                                tintColor: AppColors.white
                            ) {
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
                        
                        if innerVM.showAspectRatioSettings {
                            //Aspect ratio
                            NoShadowRoundButtonSystem(image: Image(systemName: "aspectratio"),
                                                      size: 40,
                                                      backgroundColor: AppColors.layerButtonsLightBlack,
                                                      tintColor: AppColors.white) {
                                vm.tools.openAspectRatio()
                            }.scaleEffect(0.95)
                        }
                        
                        if innerVM.showCommonSettings {
                            //Format
                            NoShadowRoundButtonSystem(image: Image(systemName: "gearshape"),
                                                      size: 40,
                                                      backgroundColor: AppColors.layerButtonsLightBlack,
                                                      tintColor: AppColors.white) {
                                vm.tools.openSettings()
                            }.scaleEffect(0.95)
                        }
                    }
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .transparentBlurBackground(
                        radius: 12,
                        blurStyle: .regular
                    )
                    .background {
                        AnimatedGradientViewVertical(
                            color: AppColors.whiteWithOpacity,
                            duration: 2
                        )
                    }
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

