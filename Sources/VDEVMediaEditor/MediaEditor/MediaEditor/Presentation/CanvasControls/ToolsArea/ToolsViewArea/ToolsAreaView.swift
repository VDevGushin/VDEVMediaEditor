//
//  ToolsAreaView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import SwiftUI
import Combine
import Kingfisher
import PhotosUI
import Resolver

struct ToolsAreaView: View {
    @Injected private var strings: VDEVMediaEditorStrings
    @Injected private var images: VDEVImageConfig
    @Injected private var out: VDEVMediaEditorOut
    
    @ObservedObject private var vm: CanvasEditorViewModel
    
    @State private var showPhoroPicker = false
    @State private var showVideoPicker = false
    @State private var showCamera = false
    @State private var showImageCropper = false
    
    init(rootMV: CanvasEditorViewModel) {
        self.vm = rootMV
    }
    
    var body: some View {
        ZStack {
            toolsOverlay()
            
            switch (vm.tools.layersAndAddNewItemIsVisible, vm.tools.showAddItemSelector) {
            case (true, true):
                toolsAddNewLayer()
                    .bottomTool()
                    .transition(.trailingTransition)
            case (true, false):
                ZStack {
                    BackButton {
                        out.onClose()
                    }
                    .padding()
                    .leftTool()
                    .topTool()
                    
                    toolsLayersManager()
                        .bottomTool()
                }
                .transition(.leadingTransition)
            default: EmptyView()
            }
            
            MediaEditorToolsForTemplateView(vm: vm.tools.overlay,
                                            backColor: $vm.ui.mainLayerBackgroundColor)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            switch vm.tools.currentToolItem {
            case .template:
                templatesTool()
                    .transition(.bottomTransition)
                
            case .stickers:
                stickersTool(title: vm.tools.currentToolItem.title)
                    .transition(.bottomTransition)
                
            case .backgroundColor:
                bgTool(title: vm.tools.currentToolItem.title)
                    .transition(.bottomTransition)
                
            case .drawing:
                drawingTool()
                    .transition(.bottomTransition)
                
            case .text(let item):
                textTool(item)
                    .transition(.bottomTransition)
                
            case .concreteItem(let item):
                toolConcrete(item)
                    .bottomTool()
                    .transition(.trailingTransition)
                
            case .adjustment(let item):
                adjustment(item)
                    .transition(.bottomTransition)
                
            case .colorFilter(let item):
                filterTool(item)
                    .transition(.bottomTransition)
                
            case .textureFilter(let item):
                textureTool(item)
                    .transition(.bottomTransition)
                
            case .masksFilter(let item):
                maskTool(item)
                    .transition(.bottomTransition)
                
                // данные тулзы нужно показывать путем оверлеев экрана
            case .empty: EmptyView()
            case .imageCropper: EmptyView()
            case .camera: EmptyView()
            case .photoPicker: EmptyView()
            case .videoPicker: EmptyView()
            }
        }
        .onReceive(vm.tools.$currentToolItem, perform: { value in
            switch value {
            case .imageCropper: showImageCropper = true
            case .camera: showCamera = true
            case .photoPicker: showPhoroPicker = true
            case .videoPicker: showVideoPicker = true
            default:
                showVideoPicker = false
                showPhoroPicker = false
                showCamera = false
                showImageCropper = false
            }
        })
        .fullScreenCover(isPresented: $showCamera) {
            CameraVPView(isLibrary: false, canvasSize: vm.ui.editroSize) { model in
                defer {
                    vm.tools.closeTools(false)
                }
                
                guard let model = model else { return }
                
                switch model.mediaType {
                case .photo:
                    guard let image = model.photo else { return }
                    vm.data.add(CanvasImageModel(image: image, asset: nil))
                case .video:
                    guard let url = model.url else { return }
                    let videoModel = CanvasVideoModel(videoURL: url, thumbnail: model.photo, asset: nil)
                    vm.data.add(videoModel)
                default: break
                }
            }
        }
        .fullScreenCover(isPresented: $showPhoroPicker, content: {
            PhotoPickerView(type: .image) { model in
                vm.tools.closeTools(false)
                guard let model = model else { return }
                switch model.mediaType {
                case .photo:
                    guard let image = model.image else { return }
                    vm.data.add(CanvasImageModel(image: image, asset: model.phAsset))
                default: break
                }
            }
        })
        .fullScreenCover(isPresented: $showVideoPicker, content: {
            PhotoPickerView(type: .video) { model in
                vm.tools.closeTools(false)
                guard let model = model else { return }
                switch model.mediaType {
                case .video:
                    guard let url = model.url else { return }
                    let videoModel = CanvasVideoModel(videoURL: url, thumbnail: model.image, asset: model.phAsset)
                    vm.data.add(videoModel)
                default: break
                }
            }
        })
        .imageCropper(show: $showImageCropper,
                      item: vm.tools.currentToolItem) { new in
            vm.data.delete(vm.tools.currentToolItem.innerCanvasModel)
            vm.data.add(new)
            vm.tools.currentCloseActionFor(new)
        }
    }
    
    @ViewBuilder
    private func toolsOverlay() -> some View {
        switch vm.tools.currentToolItem {
        case .concreteItem:
            CloseButton {
                vm.tools.closeTools(false)
            }
            .padding()
            .rightTool()
            .topTool()
            .transition(.opacity)
        default: EmptyView()
        }
    }
    
    @ViewBuilder
    func toolsAddNewLayer() -> some View {
        ToolSelectorHorizontalView(tools: vm.tools.toolsItems) {
            vm.tools.closeTools(false)
        } onSelect: { tool in
            vm.tools.showAddItemSelector(false)
            vm.tools.openLayersList(false)
            vm.tools.seletedTool(tool)
        } onPasteImageFromGeneralPasteboard: { model in
            switch model {
            case .image(let image):
                let newItem = CanvasImageModel(image: image, asset: nil)
                vm.data.add(newItem)
                vm.tools.closeTools(false)
                
            case .text(let text):
                let newItem = CanvasTextModel.with(text: text)
                vm.data.add(newItem)
                vm.tools.closeTools(false)
                vm.tools.seletedTool(.text(newItem))
            }
        }
    }
    
    @ViewBuilder
    func toolsLayersManager() -> some View {
        HStack(alignment: .bottom) {
            LayersView()
                .padding(.leading, 10)
            
            if !vm.data.isLimit {
                ImageButton(image: images.common.add,
                            title: strings.addMedia,
                            fontSize: 9,
                            size: .init(width: 44, height: 44),
                            tintColor: AppColors.white,
                            resizeImage: true) {
                    vm.tools.openLayersList(false)
                    vm.tools.showAddItemSelector(true)
                    Log.d("Add new layer")
                }.padding(.trailing, 15)
            }
            
            Spacer()
            
            PublishButton {
                vm.onBuildMedia()
            }
            .hidden(vm.data.layers.isEmpty)
            .padding()
        }
    }
    
    // что можно сделать с конктетным слоем канваса
    @ViewBuilder
    func toolConcrete(_ item: CanvasItemModel) ->  some View {
        ToolsConcreteItemHorizontal(item: item) {
            vm.tools.closeTools(false)
        } onBringToFront: { item in
            vm.data.bringToFront(item)
        } onBringToBack: { item in
            vm.data.bringToBack(item)
        } onDelete: { item in
            vm.tools.closeTools()
            vm.data.delete(item)
        } onCropImage: { item in
            vm.tools.closeTools()
            let image: CanvasImageModel = CanvasItemModel.toType(model: item)
            vm.tools.seletedTool(.imageCropper(image))
        } onAdjustments: { item in
            vm.tools.closeTools()
            vm.tools.seletedTool(.adjustment(item))
        } onEditText: { item in
            vm.tools.closeTools()
            let item: CanvasTextModel = CanvasItemModel.toType(model: item)
            vm.tools.seletedTool(.text(item))
        } onColorFilter: { item in
            vm.tools.closeTools()
            vm.tools.seletedTool(.colorFilter(item))
        } onTextureFilter: { item in
            vm.tools.closeTools()
            vm.tools.seletedTool(.textureFilter(item))
        } onMaskFilter: { item in
            vm.tools.closeTools()
            vm.tools.seletedTool(.masksFilter(item))
        } onReset: { item in
            let resetItem = vm.data.reset(item)
            vm.tools.currentCloseActionFor(resetItem)
        } onUp: { item in
            vm.data.up(item)
        } onBack: { item in
            vm.data.back(item)
        } onDublicate: { item in
            let copyItem = item.copy()
            vm.data.add(copyItem)
            vm.tools.closeTools()
        } removeBackgroundML: { item in
            vm.removeBackground(on: item) { newItem in
                vm.tools.showAddItemSelector(false)
                vm.tools.openLayersList(false)
                vm.tools.seletedTool(.concreteItem(newItem))
            }
        }
    }
}

// MARK: - Самостоятельные тулзы
fileprivate extension ToolsAreaView {
    // добавление заднего цвета
    @ViewBuilder
    func bgTool(title: String) ->  some View {
        ToolWrapper(title: title, fullScreen: false) {
            vm.tools.closeTools(false)
        } tool: {
            ToolColorView(color: $vm.ui.mainLayerBackgroundColor)
                .padding(.horizontal)
        }
    }
    
    // добавление рисунка
    @ViewBuilder
    func drawingTool() -> some View {
        VStack(spacing: 0) {
            DrawingView(vm.ui.editroSize) { output in
                if let output = output {
                    let newDrawing = CanvasDrawModel(image: output.image,
                                                     bounds: output.bounds,
                                                     offset: output.offset)
                    vm.data.add(newDrawing)
                    
                    vm.tools.currentCloseActionFor(newDrawing)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        vm.tools.closeTools(false)
                    }
                }
            }
            .frame(vm.ui.editroSize)
            .cornerRadius(vm.ui.canvasCornerRadius)
            
            Spacer(minLength: 0)
        }
        .onAppear {
            vm.tools.openLayersList(false)
        }
    }
    
    // добавление стикера
    @ViewBuilder
    func stickersTool(title: String) -> some View {
        ToolWrapper(title: title, fullScreen: true) {
            vm.tools.closeTools(false)
        } tool: {
            GridPickTool(
                dataSource: StickersDataSource(challengeId: vm.tools.baseChallengeId)
            ) { item in
                vm.tools.stickerPreparation(item) {
                    if let image = $0 {
                        vm.tools.closeTools(false)
                        let sticker = CanvasStickerModel(image: image)
                        vm.data.add(sticker)
                    }
                }
            }
            .padding(.horizontal)
            .overlay(alignment: .center) {
                LoadingView(inProgress: vm.tools.isPrepareOjectOperation, style: .large)
            }
        }
    }
    
    // добавление текста
    @ViewBuilder
    func textTool(_ item: CanvasTextModel?) -> some View {
        ZStack {
            Color.clear
            
            TextTool(textItem: item,
                     backgroundColor: vm.ui.mainLayerBackgroundColor,
                     labelContainerToCanvasWidthRatio: 0.8) { newModel in
                if let item = item { vm.data.delete(item) }
                
                vm.data.add(newModel)
                
                vm.tools.closeTools(false)
            } deleteAction: {
                vm.tools.closeTools(false)
            }
        }
    }
    
    // Выбор и добалвение шаблона
    @ViewBuilder
    func templatesTool() -> some View {
        TemplateSelectorView(vm.ui.editroSize, challengeId: vm.tools.baseChallengeId) { variants in
            vm.tools.closeTools(false)
            if variants.isEmpty { return }
            vm.data.addTemplate(CanvasTemplateModel(variants: variants, editorSize: vm.ui.editroSize))
        }
    }
}
// MARK: - Work with concrete element
fileprivate extension ToolsAreaView {
    // добавление фильтров
    @ViewBuilder
    func filterTool(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: strings.colorFilter, fullScreen: false) {
            vm.tools.currentCloseActionFor(item)
        } tool: {
            ColorFilterTool(layerModel: item,
                            challengeId: vm.tools.baseChallengeId)
        }
    }
    
    // добалвение текстуры
    @ViewBuilder
    func textureTool(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: strings.texture, fullScreen: true) {
            vm.tools.currentCloseActionFor(item)
        } tool: {
            GridPickTool(
                dataSource: TextureDataSource(challengeId: vm.tools.baseChallengeId, item: item)
            ) { texture in
                item.apply(textures: texture)
                vm.tools.currentCloseActionFor(item)
            }
            .padding(.horizontal)
        }
    }
    
    // добавление маски
    @ViewBuilder
    func maskTool(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: strings.mask, fullScreen: true) {
            vm.tools.currentCloseActionFor(item)
        } tool: {
            GridPickTool(
                dataSource: MasksDataSource(challengeId: vm.tools.baseChallengeId, item: item)
            ) { masks in
                item.apply(masks: masks)
                vm.tools.currentCloseActionFor(item)
            }
            .padding(.horizontal)
        }
    }
    
    // добавление аджастментов
    @ViewBuilder
    func adjustment(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: strings.adjustments, fullScreen: false) {
            vm.tools.currentCloseActionFor(item)
        } tool: {
            ToolAdjustments(item)
                .padding(.horizontal)
        }
    }
}
