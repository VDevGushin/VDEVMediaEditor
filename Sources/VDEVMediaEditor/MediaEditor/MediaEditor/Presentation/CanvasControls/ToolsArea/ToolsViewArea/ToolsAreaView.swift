//
//  ToolsAreaView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import SwiftUI
import Combine
import PhotosUI

struct ToolsAreaView: View {
    @Injected private var strings: VDEVMediaEditorStrings
    @Injected private var images: VDEVImageConfig
    @Injected private var settings: VDEVMediaEditorSettings
    @ObservedObject private var vm: CanvasEditorViewModel
    
    private var mementoObject: MementoObject? { vm.data }
    
    @State private var showOnboarding = false
    @State private var showPhoroPicker = false
    @State private var showVideoPicker = false
    @State private var showCamera = false
    @State private var showImageCropper = false
    @State private var showMusicPicker = false
    @State private var textForEdit: CanvasTextModel?
    @State private var showNewTextInput: Bool = false
    @State private var toolsAreaSize: CGSize = .zero
    
    init(rootMV: CanvasEditorViewModel) {
        self.vm = rootMV
    }
    
    var body: some View {
        // let _ = Self._printChanges()
        
        ZStack {
            toolsOverlay()
            
            switch (vm.tools.layersAndAddNewItemIsVisible, vm.tools.showAddItemSelector) {
            case (true, true):
                toolsAddNewLayer()
                    .bottomTool()
                    .transition(.trailingTransition)
            case (true, false):
                if settings.isInternalModule {
                    ZStack {
                        toolsLayersManager()
                            .bottomTool()
                        
                        BackButton { vm.onCloseEditor() }
                        .padding()
                        .leftTool()
                        .topTool()
                    }
                    .transition(.leadingTransition)
                } else {
                    toolsLayersManager()
                        .bottomTool()
                        .transition(.leadingTransition)
                }
            default: EmptyView()
            }
        
            
            MediaEditorToolsForTemplateView(vm: vm.tools.overlay,
                                            backColor: $vm.ui.mainLayerBackgroundColor.removeDuplicates())
            .frame(maxWidth: toolsAreaSize.width, maxHeight: toolsAreaSize.height)
            
            switch vm.tools.currentToolItem {
            case .concreteItem(let item):
                toolConcrete(item)
                    .bottomTool()
                    .transition(.trailingTransition)
                
            case .promptImageGenerator:
                    promptImageGeneratorTool()
                        .transition(.bottomTransition)
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
                
            case .adjustment(let item):
                adjustment(item)
                    .transition(.bottomTransition)
                
            case .colorFilter(let item):
                filterTool(item)
                    .transition(.bottomTransition)
                
            case .neuralFilters(let item):
                neuralFilterTool(item)
                    .transition(.bottomTransition)
                
            case .textureFilter(let item):
                textureTool(item)
                    .transition(.bottomTransition)
                
            case .masksFilter(let item):
                maskTool(item)
                    .transition(.bottomTransition)
                
            case .aspectRatio:
                aspectRatio()
                    .transition(.bottomTransition)
                
            case .settings:
                settingsMenu()
                    .transition(.bottomTransition)
                // данные тулзы нужно показывать путем оверлеев экрана
            case .empty: EmptyView()
            case .imageCropper: EmptyView()
            case .camera: EmptyView()
            case .photoPicker: EmptyView()
            case .videoPicker: EmptyView()
            case .musicPiker: EmptyView()
            case .text: EmptyView()
            }
        }
        .fetchSize($toolsAreaSize)
        .onReceive(vm.tools.$currentToolItem.removeDuplicates(), perform: { value in
            switch value {
            case .imageCropper: showImageCropper = true
            case .camera: showCamera = true
            case .photoPicker: showPhoroPicker = true
            case .videoPicker: showVideoPicker = true
            case .musicPiker: showMusicPicker = true
            case .text(let text):
                if let text = text {
                    textForEdit = text
                    showNewTextInput = false
                } else {
                    textForEdit = nil
                    showNewTextInput = true
                }
            default:
                textForEdit = nil
                showNewTextInput = false
                showVideoPicker = false
                showPhoroPicker = false
                showCamera = false
                showImageCropper = false
                showMusicPicker = false
            }
        })
        .fullScreenCover(isPresented: $showCamera) {
            NativeCameraView { model in
                vm.tools.closeTools(false)
                guard let model = model else { return }
                switch model.mediaType {
                case .photo:
                    guard let image = model.image else { return }
                    vm.data.add(CanvasImageModel(image: image, asset: model.itemAsset))
                case .video:
                    guard let url = model.url else { return }
                    let videoModel = CanvasVideoModel(videoURL: url, thumbnail: model.image, asset: model.itemAsset)
                    vm.data.add(videoModel)
                default: break
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .fullScreenCover(isPresented: $showPhoroPicker, content: {
            PhotoPickerView(type: .image, needOriginal: false) { model in
                vm.tools.closeTools(false)
                guard let model = model else { return }
                switch model.mediaType {
                case .photo:
                    guard let image = model.image else { return }
                    vm.data.add(
                        CanvasImageModel(
                            image: image,
                            asset: model.itemAsset
                        )
                    )
                default: break
                }
            }
            .edgesIgnoringSafeArea(.all)
        })
        .fullScreenCover(isPresented: $showVideoPicker, content: {
            PhotoPickerView(type: .video, needOriginal: false) { model in
                vm.tools.closeTools(false)
                guard let model = model else { return }
                switch model.mediaType {
                case .video:
                    guard let url = model.url else { return }
                    let videoModel = CanvasVideoModel(videoURL: url, thumbnail: model.image, asset: model.itemAsset)
                    vm.data.add(videoModel)
                default: break
                }
            }
            .edgesIgnoringSafeArea(.all)
        })
        .fullScreenCover(isPresented: $showMusicPicker) {
            NativeMusicPicker { model in
                vm.tools.closeTools(false)
                guard let model = model else { return }
                vm.data.add(model)
            }
        }
        .fullScreenCover(item: $textForEdit.removeDuplicates()) { item in
            TextTool(textItem: item,
                     labelContainerToCanvasWidthRatio: 0.8) { newModel in
                vm.data.delete(item)
                textForEdit = nil
                vm.data.add(newModel)
                vm.tools.closeTools(false)
            } deleteAction: {
                textForEdit = nil
                vm.data.delete(item)
                vm.tools.closeTools(false)
            }
        }
        .fullScreenCover(isPresented: $showNewTextInput.removeDuplicates()) {
            TextTool(textItem: nil,
                     labelContainerToCanvasWidthRatio: 0.8) { newModel in
                showNewTextInput = false
                vm.data.add(newModel)
                vm.tools.closeTools(false)
            } deleteAction: {
                showNewTextInput = false
                vm.tools.closeTools(false)
            }
        }
        .imageCropper(show: $showImageCropper,
                      item: vm.tools.currentToolItem) { result in
            mementoObject?.forceSave()
            switch result {
            case let .current(item):
                vm.tools.currentCloseActionFor(item)
            case .new(let canvasImageModel):
                vm.data.delete(vm.tools.currentToolItem.innerCanvasModel, withSave: false)
                vm.data.add(canvasImageModel, withSave: false)
                vm.tools.currentCloseActionFor(canvasImageModel)
            }
            
        }.sheet(isPresented: $showOnboarding) {
            OnboardingView()
        }
        .viewDidLoad {
            showOnboarding = settings.canShowOnboarding
        }
    }
    
    @ViewBuilder
    private func toolsOverlay() -> some View {
        switch vm.tools.currentToolItem {
        case .concreteItem(let item):
            VStack(spacing: 6) {
                CloseButton {
                    vm.tools.closeTools(false)
                }
                
                TrashButton { [item] in
                    delete(item: item)
                }
            }
            .padding()
            .rightTool()
            .topTool()
            .transition(.opacityTransition(withAnimation: false))
        default:
            if vm.canUndo && settings.canUndo {
                UndoButton {
                    vm.tools.closeTools()
                    vm.tools.overlay.hideAllOverlayViews()
                    vm.data.undo()
                }
                .rightTool()
                .topTool()
                .transition(.opacityTransition(withAnimation: false))
            }
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
            
            ContinueButton {
                haptics(.light)
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
            delete(item: item)
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
        } removeBackgroundML: { _ in
        } onMerge: { items in
            vm.onMergeMedia(items)
        } onVolume: { item, volume in
            vm.tools.closeTools(false)
            let itemWithNewSound = vm.data.set(sound: volume, for: item)
            vm.tools.currentCloseActionFor(itemWithNewSound)
        } onNeuralFilter: { item in
            vm.tools.closeTools()
            vm.tools.seletedTool(.neuralFilters(item))
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
        ZStack {
            DrawingView(vm: vm) { output in
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
            .cornerRadius(vm.ui.canvasCornerRadius)
            .onAppear {
                vm.tools.openLayersList(false)
            }
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
                LoadingView(inProgress: vm.tools.isPrepareOjectOperation)
            }
        }
    }
    
    // Выбор и добалвение шаблона
    @ViewBuilder
    func templatesTool() -> some View {
        TemplateSelectorView(vm.ui.roundedEditorSize, challengeId: vm.tools.baseChallengeId) { variants in
            vm.tools.closeTools(false)
            if variants.isEmpty { return }
            vm.data.addTemplate(CanvasTemplateModel(variants: variants, editorSize: vm.ui.roundedEditorSize))
        }
    }
    
    @ViewBuilder
    func promptImageGeneratorTool() -> some View {
        ToolWrapper(title: strings.promptImageGenerate, fullScreen: true) {
            vm.tools.closeTools(false)
        } tool: {
            PromptImageGeneratorView { image in
                vm.tools.closeTools(false)
                vm.data.add(CanvasImageModel(image: image, asset: nil))
                makeHaptics()
            }
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
                            challengeId: vm.tools.baseChallengeId,
                            memento: mementoObject)
        }
    }
    
    // Добавление нейронных фильтров
    @ViewBuilder
    func neuralFilterTool(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: strings.neuralFilter, fullScreen: false) {
            vm.tools.currentCloseActionFor(item)
        } tool: {
            NeuralFilterTool(
                layerModel: item,
                challengeId: vm.tools.baseChallengeId,
                memento: mementoObject
            ) {
                vm.tools.currentCloseActionFor(item)
            }
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
                mementoObject?.forceSave()
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
                mementoObject?.forceSave()
                item.apply(masks: masks)
                vm.tools.currentCloseActionFor(item)
            }
            .padding(.horizontal)
        }
    }
    
    // добавление аджастментов
    @ViewBuilder
    func adjustment(_ item: CanvasItemModel) -> some View {
        ToolWrapperWithBinding(title: strings.adjustments, fullScreen: false, withBackground: false) {
            vm.tools.currentCloseActionFor(item)
        } tool: { state in
            ToolAdjustments(item,
                            state: state,
                            memento: mementoObject)
                .padding(.horizontal)
        }
    }
}

// MARK: - Aspect ratio
extension ToolsAreaView {
    @ViewBuilder
    func aspectRatio() -> some View {
        ToolWrapper(title: strings.aspectRatio, fullScreen: false) {
            vm.tools.closeTools(false)
        } tool: {
            ToolsAspectRatioView { result in
                vm.ui.setAspectRatio(result)
            }
            .padding(.horizontal)
            .environmentObject(vm.ui)
        }
    }
}

// MARK: - Resol
extension ToolsAreaView {
    @ViewBuilder
    func settingsMenu() -> some View {
        ToolWrapper(title: strings.settings, fullScreen: false) {
            vm.tools.closeTools(false)
        } tool: {
            ToolsSettings(vm: vm)
                .padding(.horizontal)
        }
    }
}

extension ToolsAreaView {
    func delete(item: CanvasItemModel) {
        vm.tools.closeTools()
        vm.data.delete(item)
    }
}
