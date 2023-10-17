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
    @State private var textForEdit: CanvasTextModel?
    
    init(
        vm: CanvasEditorToolsForTemplateViewModel,
        backColor: Binding<Color>
    ) {
        self.vm = vm
        self._mainBackgroundColor = backColor
    }
    
    var body: some View {
        // let _ = Self._printChanges()
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
            case .editText: EmptyView()
            case .empty: EmptyView()
            }
        }
        .onReceive(vm.$state.removeDuplicates(), perform: { value in
            switch value {
            case .editText(item: let text): textForEdit = text
            default:
                textForEdit = nil
            }
        })
        .fullScreenCover(item: $textForEdit, onDismiss: {
            vm.hideAllOverlayViews()
            textForEdit = nil
        }, content: { item in
            TextTool(
                textItem: item,
                fromTemplate: true
            ) { newModel in
                guard let newModel else {
                    vm.hideAllOverlayViews()
                    textForEdit = nil
                    return
                }
                vm.editText?(newModel)
                vm.hideAllOverlayViews()
                textForEdit = nil
            }
        })
        .fullScreenCover(item: $vm.showMediaPicker) { value in
            switch value {
            case .compressed:
                MediaPickerView(needOriginal: false) { result in
                    vm.set(showMediaPicker: nil)
                    vm.hideMediaPicker()
                    if let result = result {
                        vm.pickSelector?(result)
                    }
                }
            case .neural:
                MediaPickerView(
                    pickerType: .image,
                    needOriginal: true
                ) { result in
                    vm.set(showMediaPicker: nil)
                    vm.hideMediaPicker()
                    if let result = result {
                        vm.pickSelector?(result)
                    }
                }
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
        } pickMedia: {
            vm.set(showMediaPicker: .compressed)
        }
    }
    
    @ViewBuilder
    func MediaPicker(
        onClose: @escaping () -> Void,
        pasteImage: @escaping (PickerMediaOutput) -> Void,
        pickMedia: @escaping () -> Void
    ) ->  some View {
        ToolSelectorHorizontalView(
            tools: [ToolItem.mediaPicker],
            canPasteOnlyImages: true,
            onClose: onClose
        ) { item in
            switch item {
            case .mediaPicker: pickMedia()
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
        } tool: { state, titleState in
            ToolAdjustmentsDetail(
                item,
                state: state,
                titleState: titleState,
                fromTemplate: true
            )
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
    
    @State private var isOpen = false
    
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
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                        
                        ToolRow(image: images.currentItem.currentItemTexture, title: strings.texture) {
                            onTextureFilter(item)
                        }
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                        
                        ToolRow(image: images.currentItem.currentItemAdjustments, title: strings.adjustments) { onAdjustments(item)
                        }
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                        
                        ToolRow(image: images.currentItem.currentItemRM, title: strings.remove) {
                            onDelete(item)
                        }
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                    case .video:
                        
                        if settings.canTurnOnSoundInVideos {
                            let video: CanvasVideoPlaceholderModel? = CanvasItemModel.toTypeOptional(model: item)
                            
                            if let videoTemplate = video {
                                if videoTemplate.volume <= 0.0 {
                                    ToolRow(image: images.currentItem.currentItemSoundON,
                                            title: strings.sound) {
                                        onVolume(videoTemplate, 1.0)
                                    }
                                            .opacity(isOpen ? 1.0 : 0.0)
                                            .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                                } else {
                                    ToolRow(image: images.currentItem.currentItemSoundOFF,
                                            title: strings.sound) {
                                        onVolume(videoTemplate, 0.0)
                                    }
                                            .opacity(isOpen ? 1.0 : 0.0)
                                            .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                                }
                            }
                        }
                        
                        ToolRow(image: images.currentItem.currentItemTexture, title: strings.texture) {
                            onTextureFilter(item)
                        }
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                        
                        ToolRow(image: images.currentItem.currentItemFilter, title: strings.filter) {
                            onColorFilter(item)
                        }
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                        
                        ToolRow(image: images.currentItem.currentItemAdjustments, title: strings.adjustments) { onAdjustments(item)
                        }
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                        
                        ToolRow(image: images.currentItem.currentItemRM, title: strings.remove) {
                            onDelete(item)
                        }
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                    default: EmptyView()
                    }
                }
                .padding(.horizontal, horizontalPadding)
            }
        }
        .padding(.bottom, 6)
        .viewDidLoad {
            withAnimation(.myInteractiveSpring) {
                isOpen = true
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
