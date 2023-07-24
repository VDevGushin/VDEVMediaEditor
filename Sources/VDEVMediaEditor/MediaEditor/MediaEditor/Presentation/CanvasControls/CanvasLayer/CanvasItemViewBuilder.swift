//
//  CanvasItemViewBuilder.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 11.02.2023.
//

import SwiftUI

@ViewBuilder
func CanvasItemViewBuilder(item: CanvasItemModel,
                           canvasSize: CGSize,
                           guideLinesColor: Color,
                           delegate: CanvasEditorDelegate?) -> some View {
    switch item.type {
    case .audio:
        let item: CanvasAudioModel = CanvasItemModel.toType(model: item)
        
        ZStack {
            VideoPlayerViewForLayers(assetURL: item.audioURL,
                                     videoComposition: nil,
                                     thumbnail: item.thumbnail,
                                     volume: item.volume)
            .frame(.init(width: 20, height: 20))
            .opacity(0.0)
            
            if let image = item.thumbnail {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(image.aspectRatio, contentMode: .fit)
                    .blur(radius: 2)
                    .overlay {
                        AppColors.blackWithOpacity
                    }
            } else {
                Rectangle()
                    .fill(AppColors.blackWithOpacity)
                    .aspectRatio(1, contentMode: .fit)
            }
            
            VStack(spacing: 12) {
                item.title.map {
                    Text($0)
                        .font(AppFonts.gramatika(size: 18))
                        .foregroundColor(AppColors.whiteWithOpacity1)
                }
                
                item.albumArtist.map {
                    Text($0)
                        .font(AppFonts.gramatika(size: 16))
                        .foregroundColor(AppColors.whiteWithOpacity)
                }
                
                item.albumTitle.map {
                    Text($0)
                        .font(AppFonts.gramatika(size: 16))
                        .foregroundColor(AppColors.whiteWithOpacity)
                }
            }
        }
        .frame(width: canvasSize.width / 1.2)
        .clipShape(RoundedCorner(radius: 12))
        
    case .video:
        let item: CanvasVideoModel = CanvasItemModel.toType(model: item)
        ZStack {
            VideoPlayerViewForLayers(assetURL: item.videoURL,
                                     videoComposition: item.avVideoComposition,
                                     thumbnail: item.thumbnail,
                                     volume: item.volume)
            .frame(width: canvasSize.width)
            
            if item.inProgress {
                ActivityIndicator(isAnimating: true,
                                  style: .large,
                                  color: .init(guideLinesColor))
            }
        }
        
    case .image:
        let item: CanvasImageModel = CanvasItemModel.toType(model: item)
        Image(uiImage: item.image)
            .resizable()
            .aspectRatio(item.image.aspectRatio, contentMode: .fill)
            .overlay {
                if item.inProgress {
                    ActivityIndicator(
                        isAnimating: true,
                        style: .large,
                        color: .init(guideLinesColor)
                    )
                }
            }
            .frame(item.image.size.aspectFill(minimumSize: canvasSize))
        
    case .sticker:
        let item: CanvasStickerModel = CanvasItemModel.toType(model: item)
        let width = canvasSize.width / 1.2
        
        ZStack {
            Image(uiImage: item.image)
                .resizable()
                .aspectRatio(item.image.aspectRatio, contentMode: .fit)
            
            LoadingView(inProgress: item.inProgress,
                        style: .large,
                        color: .init(guideLinesColor))
        }
        .frame(width: width)
        
    case .drawing:
        let item: CanvasDrawModel = CanvasItemModel.toType(model: item)
        Image(uiImage: item.image)
            .frame(item.bounds.size)
        
    case .text:
        let item: CanvasTextModel = CanvasItemModel.toType(model: item)
        
        DisplayTextView(text: item.textStyle.uppercased ? item.text.uppercased() : item.text,
                        fontSize: item.fontSize,
                        textColor: item.color,
                        textAlignment: item.textAlignment,
                        textStyle: item.textStyle,
                        needTextBG: item.needTextBG,
                        backgroundColor: .clear)
        .frame(item.bounds.size)
        
    case .template:
        // Строитель шаблонов
        // своя viewModel
        // свои view
        // свое поведение
        let item: CanvasTemplateModel = CanvasItemModel.toType(model: item)
        TemplateLayerView(item: item, delegate: delegate)
        
    default:
        AppColors.black
            .frame(width: 44, height: 44)
    }
}

@ViewBuilder
func CanvasItemPreiviewViewBuilder(_ item: CanvasItemModel,
                                   size: CGFloat) -> some View {
    switch item.type {
    case .audio:
        let item: CanvasAudioModel = CanvasItemModel.toType(model: item)
        if let image = item.thumbnail {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipped(antialiased: true)
                .overlay(alignment: .center) {
                    ZStack {
                        AppColors.blackWithOpacity
                        Image(systemName: "music.note")
                            .scaledToFit()
                            .foregroundColor(AppColors.white)
                            .scaleEffect(0.8)
                    }
                }
        } else {
            Image(systemName: "music.quarternote.3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipped(antialiased: true)
                .foregroundColor(AppColors.white)
                .scaleEffect(0.8)
        }
        
    case .video:
        let item: CanvasVideoModel = CanvasItemModel.toType(model: item)
        
        if let image  = item.thumbnail {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipped(antialiased: true)
                .overlay(alignment: .center) {
                    Image(systemName: "play")
                        .scaledToFit()
                        .foregroundColor(AppColors.white)
                        .scaleEffect(0.8)
                }
        } else {
            Image(systemName: "play.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipped(antialiased: true)
                .foregroundColor(AppColors.white)
                .scaleEffect(0.8)
        }
        
    case .image:
        let item: CanvasImageModel = CanvasItemModel.toType(model: item)
        
        Image(uiImage: item.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipped(antialiased: true)
        
    case .sticker:
        let item: CanvasStickerModel = CanvasItemModel.toType(model: item)
        
        Image(uiImage: item.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .clipped(antialiased: true)
            .scaleEffect(0.8)
        
    case .drawing:
        let item: CanvasDrawModel = CanvasItemModel.toType(model: item)
        
        Image(uiImage: item.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .clipped(antialiased: true)
            .scaleEffect(0.8)
        
    case .text:
        let images = DI.resolve(VDEVImageConfig.self)
        Image(uiImage: images.typed.typeText)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .foregroundColor(AppColors.white)
            .clipped(antialiased: true)
            .scaleEffect(0.5)
        
    case .template:
        let images = DI.resolve(VDEVImageConfig.self)
        
        Image(uiImage: images.typed.typeTemplate)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipped(antialiased: true)
            .foregroundColor(AppColors.white)
            .scaleEffect(0.8)
        
    default:
        AppColors.black
    }
}

// MARK: - Helpers
fileprivate extension NSAttributedString {
    func uppercased() -> NSAttributedString {
        
        let result = NSMutableAttributedString(attributedString: self)
        
        result.enumerateAttributes(in: NSRange(location: 0, length: length), options: []) {_, range, _ in
            result.replaceCharacters(in: range, with: (string as NSString).substring(with: range).uppercased())
        }
        
        return result
    }
}
