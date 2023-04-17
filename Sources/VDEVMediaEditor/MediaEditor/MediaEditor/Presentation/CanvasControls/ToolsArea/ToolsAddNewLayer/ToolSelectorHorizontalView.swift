//
//  ToolSelectorHorizontalView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//

import SwiftUI
import Resolver

extension ToolSelectorHorizontalView {
    enum Strings {
        static let paste = "PASTE"
    }
}

enum PasteboardModel {
    case image(UIImage)
    case text(String)
}

struct ToolSelectorHorizontalView: View {
    @Injected private var images: VDEVImageConfig
    @Injected private var pasteboardService: PasteboardService
    
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
                    
                    ForEach(0..<tools.count , id: \.self) { i in
                        ToolRow(tool: tools[i])
                    }
                }
                .padding(.horizontal, horizontalPadding)
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
        }
    }
    
    @ViewBuilder func PasteButton() -> some View {
        switch pasteboardService.tryPaste(canPasteOnlyImages: canPasteOnlyImages) {
        case .text(let text):
            ImageButton(image: images.typed.typePaste,
                        title: Strings.paste,
                        fontSize: 12,
                        size: .init(width: buttonSize, height: buttonSize),
                        tintColor: AppColors.whiteWithOpacity) {
                defer { pasteboardService.clear() }
                onPasteImageFromGeneralPasteboard(.text(text))
            }
        case .image(let image):
            ImageButton(image: images.typed.typePaste,
                        title: Strings.paste,
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
