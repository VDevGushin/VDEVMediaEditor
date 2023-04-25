//
//  MediaSelectorTemplateView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 18.02.2023.
//

import SwiftUI
import Resolver

struct PlaceholderTemplateView: View {
    @StateObject private var vm: PlaceholderTemplateViewModel
    @Environment(\.guideLinesColor) private var guideLinesColor
    @Injected private var images: VDEVImageConfig

    //для того, чтобы узнать манипулируем мы с картинкой или видосом
    @State private var isInManipulation: Bool = false

    init(item: CanvasPlaceholderModel, delegate: CanvasEditorDelegate?) {
        _vm = .init(wrappedValue: .init(item: item, delegate: delegate))
    }

    var body: some View {
        ZStack {
            Color.clear
            if !vm.isEmpty {
                Item()
            } else {
                AddMediaButton()
            }
        }
        .overlay(content: {
            if vm.inProgress {
                ActivityIndicator(isAnimating: vm.inProgress,
                                  style: .medium,
                color: .init(guideLinesColor))
            }
        })
    }
}

// MARK: - Item view
private extension PlaceholderTemplateView {
    @ViewBuilder
    func Item() -> some View {
        ZStack {
            Color.clear
            GeometryReader { proxy in
                vm.imageModel.map { imageModel in
                    MovableContentView(item: imageModel, size: proxy.size,
                                       isInManipulation: $isInManipulation) {
                        Image(uiImage: imageModel.image)
                            .resizable()
                            .frame(imageModel.imageSize.aspectFill(minimumSize: proxy.size))
                    } onTap: {
                        haptics(.light)
                        vm.hideAllOverlayViews()
                        // vm.openMediaSelector()
                    } onDoubleTap: {
                        haptics(.light)
                        vm.openEditVariants()
                    }.modifier (
                        TemplateMask(itemForShow: imageModel.templatedImage) {
                            Image(uiImage: $0)
                                .resizable()
                                .aspectRatio(imageModel.aspectRatio, contentMode: .fill)
                                .allowsHitTesting(false)
                        }
                    )
                    .overlay {
                        if imageModel.inProgress {
                            ActivityIndicator(isAnimating: imageModel.inProgress,
                                              style: .medium,
                                              color: .init(guideLinesColor))
                        }
                    }
                }

                vm.videoModel.map { videoModel in
                    MovableContentView(item: videoModel, size: proxy.size,
                                       isInManipulation: $isInManipulation) {
                        VideoPlayerView(assetURL: videoModel.videoURL,
                                        videoComposition: videoModel.avVideoComposition,
                                        volume: 0.0,
                                        thumbnail: videoModel.thumbnail)
                        .frame(videoModel.size.aspectFill(minimumSize: proxy.size))
                    } onTap: {
                        haptics(.light)
                        vm.hideAllOverlayViews()
                        // vm.openMediaSelector()
                    } onDoubleTap: {
                        haptics(.light)
                        vm.openEditVariants()
                    }.modifier(
                        TemplateMask(itemForShow: videoModel.maskVideoComposition) {
                            VideoPlayerView(assetURL: videoModel.videoURL,
                                            videoComposition: $0,
                                            volume: 0.0,
                                            thumbnail: videoModel.thumbnail)
                            .frame(videoModel.size.aspectFill(minimumSize: proxy.size))
                        }
                    )
                    .overlay {
                        if videoModel.inProgress {
                            ActivityIndicator(isAnimating: videoModel.inProgress,
                                              style: .medium,
                                              color: .init(guideLinesColor))
                        }
                    }
                }
            }
        }
    }
}

// MARK: - AddItem Button
private extension PlaceholderTemplateView {
    @ViewBuilder
    private func AddMediaButton() -> some View {
        Button {
            vm.openMediaSelector()
            haptics(.light)
        } label: {
            if let placholderURL = vm.item.url {
                AsyncImageView(url: placholderURL) { img in
                    Image(uiImage: img)
                        .resizable()
                } placeholder: {
                    LoadingView(inProgress: true, style: .medium, color: AppColors.white.uiColor)
                }
            } else {
                addButton()
            }
        }
        .foregroundColor(AppColors.black)
        .opacity(vm.inProgress ? 0.1 : 1.0)
    }
    
    @ViewBuilder
    private func addButton(withBackground: Bool = true, frame: CGSize = .init(width: 40, height: 40)) -> some View {
        if withBackground {
            Image(uiImage: images.common.addMediaM)
                .resizable()
                .frame(frame)
                .scaledToFit()
                .padding()
                .clipShape(Rectangle())
                .background(BlurView(style: .systemChromeMaterialLight))
                .cornerRadius(8)
        } else {
            Image(uiImage: images.common.addMediaM)
                .resizable()
                .frame(frame)
                .scaledToFit()
                .padding()
        }
    }
}

// Маска в которой мы можем двигать контент (картинку или видео)
private struct TemplateMask<T, MaskContent: View>: ViewModifier {
    private let maskContent: (T) -> MaskContent
    private let itemForShow: T?

    init(itemForShow: T?,
         @ViewBuilder maskContent: @escaping (T) -> MaskContent) {
        self.itemForShow = itemForShow
        self.maskContent = maskContent
    }

    func body(content: Content) -> some View {
        if let iShow = itemForShow {
            content.mask { maskContent(iShow) }
        } else {
            content
        }
    }
}
