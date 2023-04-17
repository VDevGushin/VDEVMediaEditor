//
//  MediaEditorOverlayView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 22.02.2023.
//

import SwiftUI

struct MediaEditorToolsForTemplateView: View {
    @ObservedObject private var vm: CanvasEditorToolsForTemplateViewModel
    @Binding private var mainBackgroundColor: Color
    
    init(vm: CanvasEditorToolsForTemplateViewModel, backColor: Binding<Color>) {
        self.vm = vm
        self._mainBackgroundColor = backColor
    }
    
    var body: some View {
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
                vm.showPhotoPicker = false
                vm.hideMediaPicker()
                vm.pickSelector?(result)
            }
        }
        .fullScreenCover(isPresented: $vm.showVideoPicker) {
            PhotoPickerView(type: .video) { result in
                vm.showVideoPicker = false
                vm.hideMediaPicker()
                vm.pickSelector?(result)
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
                     backgroundColor: mainBackgroundColor,
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
    enum Strings {
        static let selectMedia = "Select Media"
    }
    
    @EnvironmentObject private var vm: CanvasEditorToolsForTemplateViewModel
    
    var body: some View {
        MediaPicker {
            vm.hideMediaPicker()
        } pasteImage: { result in
            vm.hideAllOverlayViews()
            vm.pickSelector?(result)
        } pickPhoto: {
            vm.showPhotoPicker = true
        } pickVideo: {
            vm.showVideoPicker = true
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
    enum Strings {
        static let adjustments = "ADJUSTMENTS"
        static let colorFilter = "COLOR FILTER"
        static let texture = "TEXTURE"
    }
    
    @ViewBuilder
    func adjustment(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: Strings.adjustments, fullScreen: false) {
            vm.hideAllOverlayViews()
        } tool: {
            ToolAdjustments(item)
                .padding(.horizontal)
        }
    }
    
    // добавление фильтров
    @ViewBuilder
    func filterTool(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: Strings.colorFilter, fullScreen: false) {
            vm.hideAllOverlayViews()
        } tool: {
            ColorFilterTool(layerModel: item,
                            challengeId: vm.baseChallengeId)
        }
    }
    
    // добалвение текстуры
    @ViewBuilder
    func textureTool(_ item: CanvasItemModel) -> some View {
        ToolWrapper(title: Strings.texture, fullScreen: true) {
            vm.hideAllOverlayViews()
        } tool: {
            GridPickTool(
                dataSource: TextureDataSource(challengeId: vm.baseChallengeId, item: item)
            ) { texture in
                haptics(.light)
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
            vm.hideAllOverlayViews()
        } onDelete: { item in
            vm.onDeleteItem(item: item)
        } onAdjustments: { item in
            vm.showAdjustments(item: item)
        } onColorFilter: { item in
            vm.showFilters(item: item)
        } onTextureFilter: { item in
            vm.showTexture(item: item)
        }
    }
}

private struct ItemEditVariantsView: View {
    enum Strings {
        static let filter = "FILTER"
        static let texture = "TEXTURE"
        static let adjustments = "ADJUSTMENTS"
        static let remove = "REMOVE"
    }
    
    enum Images {
        static let mask = "CurrentItemMask"
        static let filter = "CurrentItemFilter"
        static let texture = "CurrentItemTexture"
        static let adjustments = "CurrentItemAdjustments"
        static let crop = "CurrentItemCrop"
        static let removeBack = "CurrentItemRMBack"
        static let editText = "CurrentItemEditText"
        static let dublicate = "CurrentIteDublicate"
        static let reset = "CurrentItemReset"
        static let remove = "CurrentItemRM"
        static let up = "CurrentItemUp"
        static let down = "CurrentItemDown"
        static let bringToTop = "CurrentItemBringToTop"
        static let bringToBottom = "CurrentItemBringToBottom"
    }
    
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
    
    init(item: CanvasItemModel,
         onClose: @escaping () -> Void,
         onDelete: @escaping (CanvasItemModel) -> Void,
         onAdjustments: @escaping (CanvasItemModel) -> Void,
         onColorFilter: @escaping (CanvasItemModel) -> Void,
         onTextureFilter: @escaping (CanvasItemModel) -> Void) {
        self.item = item
        self.onClose = onClose
        self.onDelete = onDelete
        self.onAdjustments = onAdjustments
        self.onColorFilter = onColorFilter
        self.onTextureFilter = onTextureFilter
    }
    
    var body: some View {
        HStack(alignment: .center) {
            ImageButton(imageName: "BackArrow",
                        size: .init(width: backButtonSize,
                                    height: backButtonSize),
                        tintColor: AppColors.white) {
                onClose()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: buttonSpacing) {
                    switch item.type {
                    case .image:
                        ToolRow(image: Images.filter, title: Strings.filter) {
                            onColorFilter(item)
                        }
                        
                        ToolRow(image: Images.texture, title: Strings.texture) {
                            onTextureFilter(item)
                        }
                        
                        ToolRow(image: Images.adjustments, title: Strings.adjustments) { onAdjustments(item)
                        }
                        
                        ToolRow(image: Images.remove, title: Strings.remove) {
                            onDelete(item)
                        }
                    case .video:
                        ToolRow(image: Images.texture, title: Strings.texture) {
                            onTextureFilter(item)
                        }
                        
                        ToolRow(image: Images.filter, title: Strings.filter) {
                            onColorFilter(item)
                        }
                        
                        ToolRow(image: Images.adjustments, title: Strings.adjustments) { onAdjustments(item)
                        }
                        
                        ToolRow(image: Images.remove, title: Strings.remove) {
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
    func ToolRow(image: String,
                 title: String,
                 tintColor: Color = AppColors.whiteWithOpacity,
                 action: @escaping () -> Void) -> some View {
        
        ImageButton(imageName: image,
                    title: title,
                    fontSize: 12,
                    size: .init(width: buttonSize, height: buttonSize),
                    tintColor: AppColors.whiteWithOpacity) {
            action()
        }
    }
}
