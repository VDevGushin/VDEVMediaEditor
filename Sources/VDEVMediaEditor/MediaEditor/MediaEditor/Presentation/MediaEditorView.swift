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
    
    init() { vm = .init() }
    
    var body: some View {
        ZStack {
            AppColors.black
            
            VStack(spacing: 0) {
                Content()
                Spacer(minLength: 0)
                AppColors.clear.frame(height: vm.ui.bottomBarHeight)
            }
            .ignoresSafeArea(.keyboard)
        
            ToolsAreaView(rootMV: vm)
         
            LoadingView(inProgress: vm.isLoading, style: .medium, color: vm.ui.guideLinesColor.uiColor)
        }
        .safeOnDrop(of: [.image, .plainText], isTargeted: nil) { providers in
            vm.data.handleDragAndDrop(for: providers, completion: vm.tools.handle(_:))
        }
        .editorPreview(with: $vm.contentPreview)
        .showAlert(with: $vm.alertData)
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
                        Color.clear
                        
                        ForEach(vm.data.layers, id: \.self) { item in
                            CanvasLayerView(item: item) { contentItem in
                                CanvasItemViewBuilder(item: contentItem,
                                                      canvasSize: proxy.size,
                                                      guideLinesColor: vm.ui.guideLinesColor,
                                                      delegate: vm.tools.overlay)
                            } onSelect: { item in
                                if vm.tools.currentToolItem == .empty {
                                    vm.tools.openLayersList(true)
                                    vm.data.bringToFront(item)
                                    vm.tools.seletedTool(.concreteItem(item))
                                } else {
                                    vm.tools.layerInManipulation = item
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
                // .position(x: proxy.frame(in: .local).midX, y: proxy.frame(in: .local).midY)
            }
            .opacity(vm.tools.currentToolItem == .backgroundColor ? 0.5 : 1.0)
            // .cornerRadius(vm.tools.currentToolItem == .backgroundColor ? vm.ui.canvasCornerRadous : 0.0)
            // .scaleEffect(vm.tools.currentToolItem == .backgroundColor ? 0.95 : 1.0)
            // .offset(y: vm.tools.currentToolItem == .backgroundColor ? 44.0 : 0.0)
            .animation(.interactiveSpring(), value: vm.tools.currentToolItem)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(vm.ui.canvasAspectRatio, contentMode: .fit)
        .clipShape(RoundedCorner(radius: vm.ui.canvasCornerRadius))
        .fetchSize($vm.ui.editroSize)
        .overlay(content: CenterAxes)
        .overlay(content: Grids)
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
        ZStack {
            HStack {
                ForEach(0..<9, id: \.self) { _ in
                    Rectangle()
                        .fill(vm.ui.guideLinesColor)
                        .opacity(0.1)
                        .frame(width: 0.5)
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack {
                ForEach(0..<13, id: \.self) { _ in
                    Rectangle()
                        .fill(vm.ui.guideLinesColor)
                        .opacity(0.1)
                        .frame(height: 0.5)
                        .frame(maxHeight: .infinity)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

fileprivate extension MediaEditorView {
    func canvasAspectSize(_ proxy: GeometryProxy) -> CGSize {
        CGSize(width: proxy.size.width,
               height: min(proxy.size.height, (proxy.size.width / vm.ui.canvasAspectRatio).rounded()))
    }
    
    func canvasFullSize(_ proxy: GeometryProxy) -> CGSize {
        CGSize(width: proxy.size.width,
               height: proxy.size.height)
    }
}
