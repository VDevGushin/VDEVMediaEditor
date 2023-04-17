//
//  ToolsConcreteItemHorizontal.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 06.04.2023.
//

import SwiftUI
import Resolver

extension ToolsConcreteItemHorizontal {
    enum Strings {
        static let mask = "MASK"
        static let filter = "FILTER"
        static let texture = "TEXTURE"
        static let adjustments = "ADJUSTMENTS"
        static let crop = "CROP"
        static let removeBack = "REMOVE BG"
        static let editText = "EDIT"
        static let dublicate = "DUBLICATE"
        static let reset = "RESET"
        static let remove = "REMOVE"
        static let up = "UP"
        static let down = "DOWN"
        static let bringToTop = "TOP"
        static let bringToBottom = "BOTTOM"
    }
}

struct ToolsConcreteItemHorizontal: View {
    @EnvironmentObject private var vm: CanvasEditorViewModel
    @Injected private var images: VDEVImageConfig
    
    private weak var item: CanvasItemModel?
    
    private var onClose: () -> Void
    private var onBringToFront: (CanvasItemModel) -> Void
    private var onBringToBack: (CanvasItemModel) -> Void
    private var onDelete: (CanvasItemModel) -> Void
    private var onCropImage: (CanvasItemModel) -> Void
    private var onAdjustments: (CanvasItemModel) -> Void
    private var onEditText: (CanvasItemModel) -> Void
    private var onColorFilter: (CanvasItemModel) -> Void
    private var onTextureFilter: (CanvasItemModel) -> Void
    private var onMaskFilter: (CanvasItemModel) -> Void
    private var onReset: (CanvasItemModel) -> Void
    private var onBack: (CanvasItemModel) -> Void
    private var onUp: (CanvasItemModel) -> Void
    private var onDublicate: (CanvasItemModel) -> Void
    private var removeBackgroundML: (CanvasItemModel) -> Void
    
    private let buttonSize: CGFloat = 40
    private let lineHeight: CGFloat = 60
    private let backButtonSize: CGFloat = 35
    private let horizontalPadding: CGFloat = 15
    private let buttonSpacing: CGFloat = 20
    
    init(item: CanvasItemModel,
         onClose: @escaping () -> Void,
         onBringToFront: @escaping (CanvasItemModel) -> Void,
         onBringToBack: @escaping (CanvasItemModel) -> Void,
         onDelete: @escaping (CanvasItemModel) -> Void,
         onCropImage: @escaping (CanvasItemModel) -> Void,
         onAdjustments: @escaping (CanvasItemModel) -> Void,
         onEditText: @escaping (CanvasItemModel) -> Void,
         onColorFilter: @escaping (CanvasItemModel) -> Void,
         onTextureFilter: @escaping (CanvasItemModel) -> Void,
         onMaskFilter: @escaping (CanvasItemModel) -> Void,
         onReset: @escaping (CanvasItemModel) -> Void,
         onUp: @escaping(CanvasItemModel) -> Void,
         onBack: @escaping (CanvasItemModel) -> Void,
         onDublicate: @escaping (CanvasItemModel) -> Void,
         removeBackgroundML: @escaping (CanvasItemModel) -> Void) {
        self.item = item
        self.onClose = onClose
        self.onBringToBack = onBringToBack
        self.onBringToFront = onBringToFront
        self.onDelete = onDelete
        self.onCropImage = onCropImage
        self.onAdjustments = onAdjustments
        self.onEditText = onEditText
        self.onColorFilter = onColorFilter
        self.onTextureFilter = onTextureFilter
        self.onMaskFilter = onMaskFilter
        self.onReset = onReset
        self.onUp = onUp
        self.onBack = onBack
        self.onDublicate = onDublicate
        self.removeBackgroundML = removeBackgroundML
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
                    if let item = item {
                        switch item.type {
                        case .image:
                            
                            ToolRow(image: images.currentItem.currentItemMask,
                                    title: Strings.mask) { onMaskFilter(item) }
                            
                            ToolRow(image: images.currentItem.currentItemFilter, title: Strings.filter) { onColorFilter(item) }
                            
                            ToolRow(image: images.currentItem.currentItemTexture, title: Strings.texture) { onTextureFilter(item) }
                            
                            ToolRow(image: images.currentItem.currentItemAdjustments, title: Strings.adjustments) { onAdjustments(item) }
                            
                            ToolRow(image: images.currentItem.currentItemCrop, title: Strings.crop) { onCropImage(item) }
                            
                            ToolRow(image: images.currentItem.currentItemRMBack, title: Strings.removeBack) { removeBackgroundML(item) }
                            
                        case .video:
                            ToolRow(image: images.currentItem.currentItemMask, title: Strings.mask) { onMaskFilter(item) }
                            
                            ToolRow(image: images.currentItem.currentItemTexture, title: Strings.texture) { onTextureFilter(item) }
                            
                            ToolRow(image: images.currentItem.currentItemFilter, title: Strings.filter) { onColorFilter(item) }
                            
                            ToolRow(image: images.currentItem.currentItemAdjustments, title: Strings.adjustments) { onAdjustments(item) }
                        case .text:
                            ToolRow(image: images.currentItem.currentItemEditText, title: Strings.editText) { onEditText(item) }
                        default: EmptyView()
                        }
                        
                        switch item.type {
                        case .image, .video, .text, .sticker, .drawing:
                            ToolRow(image: images.currentItem.currentIteDublicate, title: Strings.dublicate) { onDublicate(item) }
                        default: EmptyView()
                        }
                        
                        if vm.data.canReset(item: item) {
                            ToolRow(image: images.currentItem.currentItemReset,
                                    title: Strings.reset,
                                    tintColor: AppColors.greenWithOpacity) { onReset(item) }
                        }
                        
                        ToolRow(image: images.currentItem.currentItemRM,
                                title: Strings.remove,
                                tintColor: AppColors.redWithOpacity) { onDelete(item) }
                        
                        Rectangle()
                            .fill(AppColors.whiteWithOpacity)
                            .frame(height: lineHeight)
                            .frame(width: 1)
                        
                        if item.type != .template {
                            ToolRow(image: images.currentItem.currentItemUp, title: Strings.up) {
                                onUp(item)
                            }
                            
                            ToolRow(image: images.currentItem.currentItemDown, title: Strings.down) {
                                onBack(item)
                            }
                        }
                        
                        ToolRow(image: images.currentItem.currentItemBringToTop, title: Strings.bringToTop) {
                            onBringToFront(item)
                        }
                        
                        ToolRow(image: images.currentItem.currentItemBringToBottom, title: Strings.bringToBottom) {
                            onBringToBack(item)
                        }
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
