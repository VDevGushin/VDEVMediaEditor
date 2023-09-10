//
//  ToolsConcreteItemHorizontal.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 06.04.2023.
//

import SwiftUI
import Combine

struct ToolsConcreteItemHorizontal: View {
    @EnvironmentObject private var vm: CanvasEditorViewModel
    @Injected private var images: VDEVImageConfig
    @Injected private var strings: VDEVMediaEditorStrings
    @Injected private var settings: VDEVMediaEditorSettings
    @State private var isOpen = false
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
    private var onMerge: ([CanvasItemModel]) -> Void
    private var onVolume: (CanvasItemModel, Float) -> Void
    private var onNeuralFilter: (CanvasItemModel) -> Void
    
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
         removeBackgroundML: @escaping (CanvasItemModel) -> Void,
         onMerge: @escaping ([CanvasItemModel]) -> Void,
         onVolume: @escaping (CanvasItemModel, Float) -> Void,
         onNeuralFilter: @escaping (CanvasItemModel) -> Void) {
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
        self.onMerge = onMerge
        self.onVolume = onVolume
        self.onNeuralFilter = onNeuralFilter
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ImageButton(
                image: images.common.backArrow,
                size: .init(
                    width: backButtonSize,
                    height: backButtonSize
                ),
                tintColor: AppColors.white
            ) {
                onClose()
            }
            
            ScrollView(
                .horizontal,
                showsIndicators: false
            ) {
                HStack(
                    alignment: .center,
                    spacing: buttonSpacing
                ) {
                    if let item = item {
                        switch item.type {
                        case .image:
                            OrView(item.isNeuralProgress) {
                                ActivityIndicator(
                                    isAnimating: true,
                                    style: .medium,
                                    color: UIColor(AppColors.whiteWithOpacity))
                                .frame(
                                    width: buttonSize,
                                    height: buttonSize
                                )
                            } secondView: {
                                if settings.showNeuralFilters {
                                    ToolRow(
                                        image: images.currentItem.currentItemAIFilter,
                                        title: strings.neuralFilter
                                    ) {
                                        onNeuralFilter(item)
                                    }
                                    .opacity(isOpen ? 1.0 : 0.0)
                                    .scaleEffect(
                                        isOpen ? 1.0 : 0.001,
                                        anchor: .trailing
                                    )
                                }
                                
                                ToolRow(
                                    image: images.currentItem.currentItemFilter,
                                    title: strings.filter
                                ) {
                                    onColorFilter(item)
                                    
                                }
                                .opacity(isOpen ? 1.0 : 0.0)
                                .scaleEffect(
                                    isOpen ? 1.0 : 0.001,
                                    anchor: .trailing
                                )
                                
                                ToolRow(
                                    image: images.currentItem.currentItemMask,
                                    title: strings.mask
                                ) {
                                    onMaskFilter(item)
                                    
                                }
                                .opacity(isOpen ? 1.0 : 0.0)
                                .scaleEffect(
                                    isOpen ? 1.0 : 0.001,
                                    anchor: .trailing
                                )
                                
                                ToolRow(
                                    image: images.currentItem.currentItemTexture,
                                    title: strings.texture
                                ) {
                                    onTextureFilter(item)
                                    
                                }
                                .opacity(isOpen ? 1.0 : 0.0)
                                .scaleEffect(
                                    isOpen ? 1.0 : 0.001,
                                    anchor: .trailing
                                )
                                
                                ToolRow(
                                    image: images.currentItem.currentItemAdjustments,
                                    title: strings.adjustments
                                ) {
                                    onAdjustments(item)
                                }
                                .opacity(isOpen ? 1.0 : 0.0)
                                .scaleEffect(
                                    isOpen ? 1.0 : 0.001,
                                    anchor: .trailing
                                )
                                
                                ToolRow(
                                    image: images.currentItem.currentItemCrop,
                                    title: strings.crop
                                ) {
                                    onCropImage(item)
                                    
                                }
                                .opacity(isOpen ? 1.0 : 0.0)
                                .scaleEffect(
                                    isOpen ? 1.0 : 0.001,
                                    anchor: .trailing
                                )
                            }
                        case .audio:
                            let video: CanvasAudioModel? = CanvasItemModel.toTypeOptional(model: item)
                            if let volume = video?.volume {
                                if volume <= 0.0 {
                                    ToolRow(
                                        image: images.currentItem.currentItemSoundON,
                                        title: strings.sound
                                    ) {
                                        onVolume(item, 1.0)
                                        
                                    }
                                    .opacity(isOpen ? 1.0 : 0.0)
                                    .scaleEffect(
                                        isOpen ? 1.0 : 0.001,
                                        anchor: .trailing
                                    )
                                } else {
                                    ToolRow(
                                        image: images.currentItem.currentItemSoundOFF,
                                        title: strings.sound
                                    ) {
                                        onVolume(item, 0.0)
                                        
                                    }
                                    .opacity(isOpen ? 1.0 : 0.0)
                                    .scaleEffect(
                                        isOpen ? 1.0 : 0.001,
                                        anchor: .trailing
                                    )
                                }
                            }
                            
                        case .video:
                            if settings.canTurnOnSoundInVideos {
                                let video: CanvasVideoModel? = CanvasItemModel.toTypeOptional(model: item)
                                if let volume = video?.volume {
                                    if volume <= 0.0 {
                                        ToolRow(
                                            image: images.currentItem.currentItemSoundON,
                                            title: strings.sound) {
                                                onVolume(item, 1.0)
                                            }
                                            .opacity(isOpen ? 1.0 : 0.0)
                                            .scaleEffect(isOpen ? 1.0 : 0.001, anchor: .trailing)
                                    } else {
                                        ToolRow(image: images.currentItem.currentItemSoundOFF,
                                                title: strings.sound
                                        ) {
                                            onVolume(item, 0.0)
                                            
                                        }
                                        .opacity(isOpen ? 1.0 : 0.0)
                                        .scaleEffect(
                                            isOpen ? 1.0 : 0.001,
                                            anchor: .trailing
                                        )
                                    }
                                }
                            }
                            
                            ToolRow(
                                image: images.currentItem.currentItemMask,
                                    title: strings.mask
                            ) {
                                onMaskFilter(item)
                                
                            }
                                .opacity(isOpen ? 1.0 : 0.0)
                                .scaleEffect(
                                    isOpen ? 1.0 : 0.001,
                                    anchor: .trailing
                                )
                            
                            ToolRow(
                                image: images.currentItem.currentItemTexture,
                                title: strings.texture
                            ) {
                                onTextureFilter(item)
                                
                            }
                            .opacity(isOpen ? 1.0 : 0.0)
                            .scaleEffect(
                                isOpen ? 1.0 : 0.001,
                                anchor: .trailing
                            )
                            
                            ToolRow(
                                image: images.currentItem.currentItemFilter,
                                title: strings.filter
                            ) {
                                onColorFilter(item)
                            }
                            .opacity(isOpen ? 1.0 : 0.0)
                            .scaleEffect(
                                isOpen ? 1.0 : 0.001,
                                anchor: .trailing
                            )
                            
                            ToolRow(
                                image: images.currentItem.currentItemAdjustments,
                                title: strings.adjustments
                            ) {
                                onAdjustments(item)
                            }
                            .opacity(isOpen ? 1.0 : 0.0)
                            .scaleEffect(
                                isOpen ? 1.0 : 0.001,
                                anchor: .trailing
                            )
                        case .text:
                            ToolRow(
                                image: images.currentItem.currentItemEditText,
                                title: strings.editText
                            ) {
                                onEditText(item)
                            }
                            .opacity(isOpen ? 1.0 : 0.0)
                            .scaleEffect(
                                isOpen ? 1.0 : 0.001,
                                anchor: .trailing
                            )
                        default: EmptyView()
                        }
                        
                        OrViewWithEmpty(!item.isNeuralProgress) {
                            if !vm.data.isLimit {
                                switch item.type {
                                case .image, .video, .text, .sticker, .drawing:
                                    ToolRow(
                                        image: images.currentItem.currentIteDublicate,
                                        title: strings.dublicate
                                    ) {
                                        onDublicate(item)
                                        
                                    }
                                    .opacity(isOpen ? 1.0 : 0.0)
                                    .scaleEffect(
                                        isOpen ? 1.0 : 0.001,
                                        anchor: .trailing
                                    )
                                default: EmptyView()
                                }
                            }
                            
                            if item.canReset {
                                ToolRow(
                                    image: images.currentItem.currentItemReset,
                                    title: strings.reset,
                                    tintColor: AppColors.greenWithOpacity
                                ) {
                                    onReset(item)
                                }
                                .opacity(isOpen ? 1.0 : 0.0)
                                .scaleEffect(
                                    isOpen ? 1.0 : 0.001,
                                    anchor: .trailing
                                )
                            }
                            
                            ToolRow(
                                image: images.currentItem.currentItemRM,
                                title: strings.remove,
                                tintColor: AppColors.redWithOpacity
                            ) {
                                onDelete(item)
                            }
                            .opacity(isOpen ? 1.0 : 0.0)
                            .scaleEffect(
                                isOpen ? 1.0 : 0.001,
                                anchor: .trailing
                            )
                        }
                        
                        Rectangle()
                            .fill(AppColors.whiteWithOpacity)
                            .frame(height: lineHeight)
                            .frame(width: 1)
                        
                        OrViewWithEmpty(item.type != .template) {
                            ToolRow(
                                image: images.currentItem.currentItemUp,
                                title: strings.up
                            ) {
                                onUp(item)
                            }
                            .opacity(isOpen ? 1.0 : 0.0)
                            .scaleEffect(
                                isOpen ? 1.0 : 0.001,
                                anchor: .trailing
                            )
                            
                            ToolRow(
                                image: images.currentItem.currentItemDown,
                                title: strings.down
                            ) {
                                onBack(item)
                            }
                            .opacity(isOpen ? 1.0 : 0.0)
                            .scaleEffect(
                                isOpen ? 1.0 : 0.001,
                                anchor: .trailing
                            )
                        }
                        
                        ToolRow(
                            image: images.currentItem.currentItemBringToTop,
                            title: strings.bringToTop
                        ) {
                            onBringToFront(item)
                        }
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(
                            isOpen ? 1.0 : 0.001,
                            anchor: .trailing
                        )
                        
                        ToolRow(
                            image: images.currentItem.currentItemBringToBottom,
                            title: strings.bringToBottom
                        ) {
                            onBringToBack(item)
                        }
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(
                            isOpen ? 1.0 : 0.001,
                            anchor: .trailing
                        )
                        
                        OrViewWithEmpty(!item.isNeuralProgress) {
                            if let withItem = vm.data.canMerge(item: item),
                               !withItem.isNeuralProgress {
                                ToolRow(
                                    image: images.currentItem.currentItemMerge,
                                    title: strings.merge
                                ) {
                                    onMerge([withItem, item])
                                }
                                .opacity(isOpen ? 1.0 : 0.0)
                                .scaleEffect(
                                    isOpen ? 1.0 : 0.001,
                                    anchor: .trailing
                                )
                            }
                        }
                    }
                }
                .background(item?.isNeuralProgress ?? false){
                    AnimatedGradientViewVertical(
                        color: AppColors.whiteWithOpacity2,
                        duration: 3
                    )
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
    func ToolRow(
        image: UIImage,
        title: String,
        tintColor: Color = AppColors.whiteWithOpacity,
        action: @escaping () -> Void
    ) -> some View {
        ImageButton(
            image: image,
            title: title,
            fontSize: 12,
            size: .init(width: buttonSize, height: buttonSize),
            tintColor: AppColors.whiteWithOpacity
        ) {
            action()
        }
    }
}
