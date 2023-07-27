//
//  ToolSelectorHorizontalView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//

import SwiftUI
import Combine

enum PasteboardModel {
    case image(UIImage)
    case text(String)
}

struct ToolSelectorHorizontalView: View {
    @Injected private var strings: VDEVMediaEditorStrings
    @Injected private var images: VDEVImageConfig
    @Injected private var pasteboardService: PasteboardService
    @InjectedOptional private var imageResultChecker: ImageResultChecker?
    @State private var isLoading: Bool = false
    @State private var isOpen: Bool = false
    
    private let tools: [ToolItem]
    
    private var onSelect: (ToolItem) -> Void
    private var onClose: () -> Void
    
    private let buttonSize: CGFloat = 40
    private let backButtonSize: CGFloat = 35
    private let horizontalPadding: CGFloat = 15
    private let buttonSpacing: CGFloat = 20
    private let canPasteOnlyImages: Bool
    
    private var onPasteImageFromGeneralPasteboard: (PasteboardModel) -> Void
    
    init(tools: [ToolItem],
         canPasteOnlyImages: Bool = false,
         onClose: @escaping () -> Void,
         onSelect: @escaping (ToolItem) -> Void,
         onPasteImageFromGeneralPasteboard: @escaping (PasteboardModel) -> Void) {
        self.tools = tools
        self.canPasteOnlyImages = canPasteOnlyImages
        self.onClose = onClose
        self.onSelect = onSelect
        self.onPasteImageFromGeneralPasteboard = onPasteImageFromGeneralPasteboard
    }
    
    var body: some View {
        HStack(alignment: .center) {
            ImageButton(image: images.common.backArrow,
                        size: .init(width: backButtonSize, height: backButtonSize),
                        tintColor: AppColors.white) {
                onClose()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: buttonSpacing) {
                    PasteButton()
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.5, anchor: .center)
                
                    ForEach(0..<tools.count , id: \.self) { i in
                        ToolRow(tool: tools[i])
                        .opacity(isOpen ? 1.0 : 0.0)
                        .scaleEffect(isOpen ? 1.0 : 0.5, anchor: .trailing)
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
        .onReceive(
            (imageResultChecker?.state ??
                .single(ImageResultChecker.State.notStarted))
            .receiveOnMain()
        ) { value in
            switch value {
            case .inProgress: isLoading = true
            default: isLoading = false
            }
        }
    }
    
    @ViewBuilder func ToolRow(tool: ToolItem) -> some View {
        ImageButton(image: tool.image,
                    title: tool.title,
                    fontSize: 12,
                    size: .init(width: buttonSize, height: buttonSize),
                    tintColor: AppColors.whiteWithOpacity) {
            onSelect(tool)
        }.overlay(alignment: .topTrailing) {
            if isLoading, case .promptImageGenerator = tool {
                Circle().fill(AppColors.whiteWithOpacity1)
                    .frame(.init(width: 18, height: 18))
                    .overlay {
                        ActivityIndicator(isAnimating: true,
                                          style: .medium,
                                          color: AppColors.black.uiColor)
                    }
            } else {
                EmptyView()
            }
        }
    }
    
    @ViewBuilder func PasteButton() -> some View {
        switch pasteboardService.tryPaste(canPasteOnlyImages: canPasteOnlyImages) {
        case .text(let text):
            ImageButton(image: images.typed.typePaste,
                        title: strings.paste,
                        fontSize: 12,
                        size: .init(width: buttonSize, height: buttonSize),
                        tintColor: AppColors.whiteWithOpacity) {
                defer { pasteboardService.clear() }
                onPasteImageFromGeneralPasteboard(.text(text))
            }
        case .image(let image):
            ImageButton(image: images.typed.typePaste,
                        title: strings.paste,
                        fontSize: 12,
                        size: .init(width: buttonSize, height: buttonSize),
                        tintColor: AppColors.whiteWithOpacity) {
                defer { pasteboardService.clear() }
                onPasteImageFromGeneralPasteboard(.image(image))
            }
        default: EmptyView()
        }
    }
}
