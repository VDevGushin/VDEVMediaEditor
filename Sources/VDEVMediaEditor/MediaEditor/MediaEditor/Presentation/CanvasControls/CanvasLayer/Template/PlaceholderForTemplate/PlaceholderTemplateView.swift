//
//  MediaSelectorTemplateView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 18.02.2023.
//

import SwiftUI

struct PlaceholderTemplateView: View {
    @Environment(\.guideLinesColor) private var guideLinesColor
    @StateObject private var vm: PlaceholderTemplateViewModel
    @Injected private var images: VDEVImageConfig
    //для того, чтобы узнать манипулируем мы с картинкой или видосом
    @State private var isInManipulation: Bool = false
    @State private var isShowSelection: Bool = false
    
    init(
        item: CanvasPlaceholderModel,
        delegate: CanvasEditorDelegate?
    ) {
        _vm = .init(
            wrappedValue: .init(
                item: item,
                delegate: delegate
            )
        )
    }
    
    var body: some View {
        ZStackWithClearColor {
            OrView(vm.isEmpty) {
                AddMediaButton()
                    .transition(.opacityTransition(withAnimation: true, speed: 0.2))
            } secondView: {
                Item()
                    .transition(.opacityTransition(withAnimation: true, speed: 0.2))
            }
        }
        .overlay {
            NeuralLoader(
                progresOperationType: vm.inProgress,
                guideLinesColor: guideLinesColor
            )
        }
    }
}

// MARK: - Item view
private extension PlaceholderTemplateView {
    @ViewBuilder
    func Item() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            vm.imageModel.map { imageModel in
                MovableContentView(item: imageModel,
                                   size: size,
                                   isInManipulation: $isInManipulation,
                                   isShowSelection: $isShowSelection) {
                    let size = imageModel.imageSize.aspectFill(minimumSize: size).rounded(.up)
                    Image(uiImage: imageModel.image)
                        .resizable()
                        .frame(size)
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
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { value in
                                        let location = value.location
                                        print("==>", location)
                                    }
                            )
                    }
                )
                .overlay {
                    if imageModel.inProgress {
                        ActivityIndicator(isAnimating: imageModel.inProgress,
                                          style: .medium,
                                          color: .init(guideLinesColor))
                    }
                }
                .frame(size)
            }
            
            vm.videoModel.map { videoModel in
                let binding = Binding(
                    get: { videoModel.volume },
                    set: { videoModel.update(volume: $0) }
                )
                
                MovableContentView(item: videoModel,
                                   size: size,
                                   isInManipulation: $isInManipulation,
                                   isShowSelection: $isShowSelection) {
                    let size = videoModel.size.aspectFill(minimumSize: size).rounded(.up)
                    VideoPlayerViewForTempates(assetURL: videoModel.videoURL,
                                               videoComposition: videoModel.avVideoComposition,
                                               thumbnail: videoModel.thumbnail,
                                               volume: binding)
                    .frame(size)
                } onTap: {
                    haptics(.light)
                    vm.hideAllOverlayViews()
                    // vm.openMediaSelector()
                } onDoubleTap: {
                    haptics(.light)
                    vm.openEditVariants()
                }.modifier(
                    TemplateMask(itemForShow: videoModel.maskVideoComposition) {
                        VideoPlayerViewForTempates(assetURL: videoModel.videoURL,
                                                   videoComposition: $0,
                                                   thumbnail: videoModel.thumbnail,
                                                   volume: .constant(0.0))
                        .frame(videoModel.size.aspectFill(minimumSize: size))
                    }
                )
                .overlay {
                    if videoModel.inProgress {
                        ActivityIndicator(isAnimating: videoModel.inProgress,
                                          style: .medium,
                                          color: .init(guideLinesColor))
                    }
                }
                .frame(size)
            }
        }
        .overlay {
            if vm.showSelection || isShowSelection {
                Selection()
            }
        }
        .background($isShowSelection) {
            AnimatedGradientView(color: guideLinesColor.opacity(0.3))
        }
    }
}

// MARK: - AddItem Button
private extension PlaceholderTemplateView {
    @ViewBuilder
    private func AddMediaButton() -> some View {
        Button {
            haptics(.light)
            vm.openMediaSelector()
        } label: {
            if let placholderURL = vm.item.url {
                AsyncImageView(url: placholderURL) { img in
                    Image(uiImage: img).resizable()
                } placeholder: {
                    LoadingView(
                        inProgress: true,
                        color: AppColors.white.uiColor,
                        cornerRadius: 0
                    )
                }
            } else {
                addButton()
            }
        }
        .foregroundColor(AppColors.black)
        .opacity(vm.inProgress != nil ? 0.1 : 1.0)
        .overlay {
            if vm.showSelection {
                Selection()
            }
        }
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
            content.mask {
                maskContent(iShow)
            }
        } else {
            content
        }
    }
}

private struct Selection: View {
    @Environment(\.guideLinesColor) private var guideLinesColor
    
    @State private var phase = 0.0
    
    var body: some View {
        Rectangle()
            .inset(by: 1)
            .stroke(guideLinesColor.opacity(0.8), style:
                        StrokeStyle(lineWidth: 1,
                                    dash: [4, 4],
                                    dashPhase: phase)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(
                Animation.linear(duration: 15)
                    .repeatForever(autoreverses: true),
                value: phase)
            .onAppear {
                phase -= 100
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
