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
        // let _ = Self._printChanges()
        ZStack {
            AppColors.black
            
            VStack(spacing: 0) {
                EditorArea
                    .viewDidLoad(vm.contentViewDidLoad)
                    .padding(.bottom, 4)
                
                AppColors.clear.frame(height: vm.ui.bottomBarHeight)
            }
            
            ToolsAreaView(rootMV: vm)
            
            LoadingView(
                inProgress: vm.isLoading,
                style: .medium,
                color: vm.ui.guideLinesColor.uiColor
            ) {
                vm.onCancelBuildMedia()
            }
        }
        .safeOnDrop(of: [.image, .plainText], isTargeted: nil) { providers in
            vm.data.handleDragAndDrop(for: providers, completion: vm.tools.handle(_:))
        }
        .editorPreview(
            with: $vm.contentPreview.removeDuplicates(),
            cornerRadius: vm.ui.canvasCornerRadius
        ) { model in
            vm.contentPreview = nil
            vm.onPublishResult(output: model)
        } onClose: {
            vm.contentPreview = nil
        }
        .showInnerPhone($vm.showRemoveAllAlert)
        .showRemoveAlert(isPresented: $vm.showRemoveAllAlert) {
            vm.onRemoveAllLayers()
        } onCancel: {
            vm.onCancelRemoveAllLayers()
        }
        .environmentObject(vm)
        .environment(\.guideLinesColor, vm.ui.guideLinesColor)
    }
}

fileprivate extension MediaEditorView {
    @ViewBuilder
    var EditorArea: some View {
        ZStack(alignment: .center) {
            vm.ui.mainLayerBackgroundColor
            
            GeometryReader { proxy in
                let size = proxy.size
                ParentView {
                    ZStack {
                        InvisibleTapZoneView(tapCount: 1) {
                            if vm.tools.currentToolItem != .empty {
                                vm.tools.closeTools(false)
                            }
                        }
                        
                        ForEach(vm.data.layers, id: \.self) { item in
                            CanvasLayerView(item: item,
                                            toolsModel: vm.tools,
                                            dataModel: vm.data) {
                                CanvasItemViewBuilder(item: item,
                                                      canvasSize: vm.ui.editorSize,
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
                .frame(size)
            }
            .opacity(vm.tools.currentToolItem == .backgroundColor ? 0.7 : 1.0)
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
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(
                        AnimatedGradientView(color: AppColors.whiteWithOpacity2, duration: 3)
                    )
                    .clipShape(RoundedCorner(radius: vm.ui.canvasCornerRadius))
            }
        } else {
            EmptyView()
        }
    }
}
