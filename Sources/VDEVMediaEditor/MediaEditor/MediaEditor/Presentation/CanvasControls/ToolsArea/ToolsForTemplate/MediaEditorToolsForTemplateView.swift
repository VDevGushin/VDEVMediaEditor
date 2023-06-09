//
//  MediaEditorOverlayView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 22.02.2023.
//

import SwiftUI


struct MediaEditorToolsForTemplateView: View {
    @Injected private var strings: VDEVMediaEditorStrings
    @ObservedObject private var vm: CanvasEditorToolsForTemplateViewModel
    @Binding private var mainBackgroundColor: Color
    
    init(vm: CanvasEditorToolsForTemplateViewModel, backColor: Binding<Color>) {
        self.vm = vm
        self._mainBackgroundColor = backColor
    }
    
    var body: some View {
        let _ = Self._printChanges()
        ZStack{
            switch vm.state {
            case .mediaPick:
                PickMediaContainer()
                    .bottomTool()
                    .transition(.trailingTransition)
                    .environmentObject(vm)
            case .editVariants(let item):
                EditVariants(item: item)
                    .bottomTool()
                    .transition(.trailingTransition)
                    .environmentObject(vm)
            case .adjustments(let item):
                adjustment(item)
                    .bottomTool()
                    .transition(.bottomTransition)
            case .texture(let item):
                textureTool(item)
                    .transition(.bottomTransition)
            case .filter(let item):
                filterTool(item)
                    .bottomTool()
                    .transition(.bottomTransition)
            case .editText(item: let item):
                textTool(item)
                    .transition(.bottomTransition)
            case .empty: EmptyView()
            }
        }
        .fullScreenCover(isPresented: $vm.showPhotoPicker) {
            PhotoPickerView(type: .image) { result in
                vm.set(showPhotoPicker: false)
                vm.hideMediaPicker()
                if let result = result {
                    vm.pickSelector?(result)
                }
            }
        }
        .fullScreenCover(isPresented: $vm.showVideoPicker) {
            PhotoPickerView(type: .video) { result in
                vm.set(showVideoPicker: false)
                vm.hideMediaPicker()
                if let result = result {
                    vm.pickSelector?(result)
                }
            }
        }
    }
}

// MARK: - Edit text
fileprivate extension MediaEditorToolsForTemplateView {
    @ViewBuilder
    func textTool(_ item: CanvasTextModel?) -> some View {
        ZStack {
            Color.clear
            
            TextTool(textItem: item,
                     labelContainerToCanvasWidthRatio: 0.8,
                     fromTemplate: true) { newModel in
                vm.editText?(newModel)
                vm.hideAllOverlayViews()
            } deleteAction: {
                vm.hideAllOverlayViews()
            }
        }
    }
}

// MARK: - Photo and Video Picker
private struct PickMediaContainer: View {
    @EnvironmentObject private var vm: CanvasEditorToolsForTemplateViewModel
    
    var body: some View {
        MediaPicker {
            vm.hideMediaPicker()
        } pasteImage: { result in
            vm.hideAllOverlayViews()
            vm.pickSelector?(result)
        } pickPhoto: {
            vm.set(showPhotoPicker: true)
        } pickVideo: {
            vm.set(showVideoPicker: true)
        }
    }
    
    @ViewBuilder
    func MediaPicker(onClose: @escaping () -> Void,
                     pasteImage: @escaping (PickerMediaOutput) -> Void,
                     pickPhoto: @escaping () -> Void,
                     pickVideo: @escaping () -> Void) ->  some View {
        let toolVideo = ToolItem.videoPicker
        let toolImage = ToolItem.photoPicker
       
        ToolSelectorHorizontalView(tools: [toolImage, toolVideo],
                                   canPasteOnlyImages: true, onClose: onClose) { item in
            switch item {
            case .photoPicker: pickPhoto()
            case .videoPicker: pickVideo()
            default: break
            }
        } onPasteImageFromGeneralPasteboard: { model in
            switch model {
            case .image(let image):
                pasteImage(PickerMediaOutput(with: image, asset: nil))
            default: break
            }
        }
    }
}

// MARK: - Item edit variants
fileprivate extension MediaEditorToolsForTemplateView {
    @ViewBuilder
    func adjustment(_ item: CanvasItemModel) -> some View {
        ToolWrapperWithBinding(title: strings.adjustments, fullScreen: false, withBackground: false) {
            vm.endWorkWithItem?()
            vm.hideAllOverlayViews()
        } tool: { state in
            ToolAdjustments(item, state: state)
                .padding(.horizontal)
        }
    }
    
    // добавление фильтров
    @ViewBuilder
    func filterTool(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: strings.colorFilter, fullScreen: false) {
            vm.endWorkWithItem?()
            vm.hideAllOverlayViews()
        } tool: {
            ColorFilterTool(layerModel: item,
                            challengeId: vm.baseChallengeId)
        }
    }
    
    // добалвение текстуры
    @ViewBuilder
    func textureTool(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: strings.texture, fullScreen: true) {
            vm.endWorkWithItem?()
            vm.hideAllOverlayViews()
        } tool: {
            GridPickTool(
                dataSource: TextureDataSource(challengeId: vm.baseChallengeId, item: item)
            ) { texture in
                haptics(.light)
                vm.endWorkWithItem?()
                vm.hideAllOverlayViews()
                item.apply(textures: texture)
            }
            .padding(.horizontal)
        }
    }
}

private struct EditVariants: View {
    @EnvironmentObject private var vm: CanvasEditorToolsForTemplateViewModel
    unowned let item: CanvasItemModel
    
    var body: some View {
        ItemEditVariantsView(item: item) {
            vm.endWorkWithItem?()
            vm.hideAllOverlayViews()
        } onDelete: { item in
            vm.onDeleteItem(item: item)
        } onAdjustments: { item in
            vm.showAdjustments(item: item)
        } onColorFilter: { item in
            vm.showFilters(item: item)
        } onTextureFilter: { item in
            vm.showTexture(item: item)
        } onVolume: { item, sound in
            vm.onChangeSound(for: item, value: sound)
        }
    }
}

private struct ItemEditVariantsView: View {
    @Injected private var images: VDEVImageConfig
    @Injected private var strings: VDEVMediaEditorStrings
    @Injected private var settings: VDEVMediaEditorSettings
    
    private let buttonSize: CGFloat = 40
    private let lineHeight: CGFloat = 60
    private let backButtonSize: CGFloat = 35
    private let horizontalPadding: CGFloat = 15
    private let buttonSpacing: CGFloat = 20
    
    private unowned let item: CanvasItemModel
    private var onClose: () -> Void
    private var onDelete: (CanvasItemModel) -> Void
    private var onAdjustments: (CanvasItemModel) -> Void
    private var onColorFilter: (CanvasItemModel) -> Void
    private var onTextureFilter: (CanvasItemModel) -> Void
    private var onVolume: (CanvasVideoPlaceholderModel, Float) -> Void
    
    init(item: CanvasItemModel,
         onClose: @escaping () -> Void,
         onDelete: @escaping (CanvasItemModel) -> Void,
         onAdjustments: @escaping (CanvasItemModel) -> Void,
         onColorFilter: @escaping (CanvasItemModel) -> Void,
         onTextureFilter: @escaping (CanvasItemModel) -> Void,
         onVolume: @escaping (CanvasVideoPlaceholderModel, Float) -> Void) {
        self.item = item
        self.onClose = onClose
        self.onDelete = onDelete
        self.onAdjustments = onAdjustments
        self.onColorFilter = onColorFilter
        self.onTextureFilter = onTextureFilter
        self.onVolume = onVolume
    }
    
    var body: some View {
        HStack(alignment: .center) {
            ImageButton(image: images.common.backArrow,
                        size: .init(width: backButtonSize,
                                    height: backButtonSize),
                        tintColor: AppColors.white) {
                onClose()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: buttonSpacing) {
                    switch item.type {
                    case .image:
                        ToolRow(image: images.currentItem.currentItemFilter, title: strings.filter) {
                            onColorFilter(item)
                        }
                        
                        ToolRow(image: images.currentItem.currentItemTexture, title: strings.texture) {
                            onTextureFilter(item)
                        }
                        
                        ToolRow(image: images.currentItem.currentItemAdjustments, title: strings.adjustments) { onAdjustments(item)
                        }
                        
                        ToolRow(image: images.currentItem.currentItemRM, title: strings.remove) {
                            onDelete(item)
                        }
                    case .video:
                        
                        if settings.canTurnOnSoundInVideos {
                            let video: CanvasVideoPlaceholderModel? = CanvasItemModel.toTypeOptional(model: item)
                            
                            if let videoTemplate = video {
                                if videoTemplate.volume <= 0.0 {
                                    ToolRow(image: images.currentItem.currentItemSoundON,
                                            title: strings.sound) {
                                        onVolume(videoTemplate, 1.0)
                                    }
                                } else {
                                    ToolRow(image: images.currentItem.currentItemSoundOFF,
                                            title: strings.sound) {
                                        onVolume(videoTemplate, 0.0)
                                    }
                                }
                            }
                        }
                        
                        ToolRow(image: images.currentItem.currentItemTexture, title: strings.texture) {
                            onTextureFilter(item)
                        }
                        
                        ToolRow(image: images.currentItem.currentItemFilter, title: strings.filter) {
                            onColorFilter(item)
                        }
                        
                        ToolRow(image: images.currentItem.currentItemAdjustments, title: strings.adjustments) { onAdjustments(item)
                        }
                        
                        ToolRow(image: images.currentItem.currentItemRM, title: strings.remove) {
                            onDelete(item)
                        }
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }
        }
    }
    
    @ViewBuilder
    func ToolRow(image: UIImage,
                 title: String,
                 tintColor: Color = AppColors.whiteWithOpacity,
                 action: @escaping () -> Void) -> some View {
        
        ImageButton(image: image,
                    title: title,
                    fontSize: 12,
                    size: .init(width: buttonSize, height: buttonSize),
                    tintColor: AppColors.whiteWithOpacity) {
            action()
        }
    }
}
