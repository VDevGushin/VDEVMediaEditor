//
//  CanvasRedactorEditorView.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 30.01.2023.
//

import SwiftUI
import CombineExt
import Combine

struct MediaEditorView: View {
    @ObservedObject private var vm: CanvasEditorViewModel
    
    init(onPublish: (@MainActor (CombinerOutput) -> Void)? = nil,
         onClose: (@MainActor () -> Void)? = nil) {
        vm = .init(onPublish: onPublish, onClose: onClose)
    }
    
    var body: some View {
        ZStack {
            AppColors.black
            
            VStack(spacing: 0) {
                Content()
                    .viewDidLoad(vm.contentViewDidLoad)
                    .padding(.bottom, 4)
                
                AppColors.clear.frame(height: vm.ui.bottomBarHeight)
            }
            
            ToolsAreaView(rootMV: vm)
                .padding(.bottom, 6)
            
            LoadingView(inProgress: vm.isLoading, style: .medium, color: vm.ui.guideLinesColor.uiColor)
        }
        .safeOnDrop(of: [.image, .plainText], isTargeted: nil) { providers in
            vm.data.handleDragAndDrop(for: providers, completion: vm.tools.handle(_:))
        }
        .editorPreview(with: $vm.contentPreview, onPublish: { model in
            vm.contentPreview = nil
            vm.onPublishResult(output: model)
        }, onClose: {
            vm.contentPreview = nil
        })
        .showAlert(with: $vm.alertData)
        .showRemoveAlert(isPresented: $vm.showRemoveAllAlert, onComfirm: {
            vm.removeAllLayers()
        })
        .environmentObject(vm)
        .environment(\.guideLinesColor, vm.ui.guideLinesColor)
    }
}

fileprivate extension MediaEditorView {
    @ViewBuilder
    func Content() -> some View {
        ZStack(alignment: .center) {
            vm.ui.mainLayerBackgroundColor
            
            GeometryReader { proxy in
                ParentView {
                    ZStack {
                        InvisibleTapZoneView(tapCount: 2) {
                            if vm.tools.currentToolItem != .empty {
                                haptics(.light)
                                vm.tools.closeTools(false)
                            }
                        }
                        
                        ForEach(vm.data.layers, id: \.self) { item in
                            CanvasLayerView(item: item) { contentItem in
                                CanvasItemViewBuilder(item: contentItem,
                                                      canvasSize: proxy.size,
                                                      guideLinesColor: vm.ui.guideLinesColor,
                                                      delegate: vm.tools.overlay)
                            } onSelect: { item in
                                if vm.tools.currentToolItem == .empty {
                                    // Выбрать конкретный итем
                                    vm.tools.openLayersList(true)
                                    vm.data.bringToFront(item)
                                    vm.tools.seletedTool(.concreteItem(item))
                                } else {
                                    // Отменить выборку
                                    vm.tools.closeTools(false)
                                    //vm.tools.layerInManipulation = item
                                }
                            } onDelete: { item in
                                vm.data.delete(item)
                            } onShowCenterV: { value in
                                vm.ui.showVerticalCenter = value
                            } onShowCenterH: { value in
                                vm.ui.showHorizontalCenter = value
                            } onManipulated: { item in
                                vm.tools.layerInManipulation = item
                            } onEndManipulated: { item in
                                vm.tools.layerInManipulation = nil
                            } onEdit: { item in
                                if vm.tools.tryToEdit(item) {
                                    vm.tools.layerInManipulation = nil
                                } else {
                                    vm.tools.layerInManipulation = item
                                }
                            }
                        }
                    }
                }
                .frame(proxy.size)
            }
            .opacity(vm.tools.currentToolItem == .backgroundColor ? 0.5 : 1.0)
            .animation(.interactiveSpring(), value: vm.tools.currentToolItem)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .with(aspectRatio: vm.ui.aspectRatio)
        .clipShape(RoundedCorner(radius: vm.ui.canvasCornerRadius))
        .fetchSize($vm.ui.editorSize)
        .overlay(content: CenterAxes)
        .overlay(content: Grids)
        .overlay(content: AddMediaButton)
        .onChange(of: vm.ui.showHorizontalCenter) {
            if $0 { haptics(.light) }
        }
        .onChange(of: vm.ui.showVerticalCenter) {
            if $0 { haptics(.light) }
        }
    }
    
    @ViewBuilder
    func CenterAxes() -> some View {
        ZStack {
            if vm.ui.showVerticalCenter {
                Rectangle()
                    .foregroundColor(vm.ui.guideLinesColor.opacity(0.6))
                    .frame(width: 1.5)
                    .frame(maxHeight: .infinity)
            }
            
            if vm.ui.showHorizontalCenter {
                Rectangle()
                    .foregroundColor(vm.ui.guideLinesColor.opacity(0.6))
                    .frame(height: 1.5)
                    .frame(maxWidth: .infinity)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
    
    @ViewBuilder
    func Grids() -> some View {
        if vm.ui.needGuideLinesGrid {
            ZStack {
                HStack {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle()
                            .fill(vm.ui.guideLinesColor)
                            .opacity(0.05)
                            .frame(width: 0.5)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                VStack {
                    ForEach(0..<3, id: \.self) { _ in
                        Rectangle()
                            .fill(vm.ui.guideLinesColor)
                            .opacity(0.05)
                            .frame(height: 0.5)
                            .frame(maxHeight: .infinity)
                    }
                }
            }
            .allowsHitTesting(false)
        }
    }
    
    @ViewBuilder
    func AddMediaButton() -> some View {
        if vm.addMediaButtonVisible {
            Button(action: {
                makeHaptics()
                vm.tools.openLayersList(false)
                vm.tools.showAddItemSelector(true)
                Log.d("Add new layer")
            }) {
                Text(vm.addMediaButtonTitle)
                    .font(AppFonts.elmaTrioRegular(13))
                    .foregroundColor(AppColors.whiteWithOpacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: vm.ui.canvasCornerRadius)
                            .strokeBorder(AppColors.whiteWithOpacity,lineWidth: 1.0)
                            .shadow(color: AppColors.whiteWithOpacity, radius: vm.ui.canvasCornerRadius)
                    )
                    .background(
                        AnimatedGradientView(color: AppColors.whiteWithOpacity, duration: 3)
                    )
                    .clipShape(RoundedCorner(radius: vm.ui.canvasCornerRadius))
                    .padding(20.0)
            }
        } else {
            EmptyView()
        }
    }
}
