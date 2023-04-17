//
//  ToolItem.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import SwiftUI

extension ToolItem {
    enum Strings {
        static let template = "TEMPLATE"
        static let text = "TEXT"
        static let stickersCustom = "STICKER"
        static let addPhoto = "PHOTO"
        static let addVideo = "VIDEO"
        static let camera = "CAMERA"
        static let drawing = "DRAWING"
        static let background = "BG"
    }
}

enum ToolItem: CaseIterable, Identifiable, Equatable {
    // Тулзы, которые показываем в меню добавления новых слоев
    case template
    case stickers
    case photoPicker // выбор только фоток
    case videoPicker // выбор только видео
    case camera
    case drawing
    case backgroundColor
    case text(CanvasTextModel?)

    // Тулзы для редактирования конкретных объектов слоя
    case concreteItem(CanvasItemModel)
    case imageCropper(CanvasImageModel)
    case colorFilter(CanvasItemModel)
    case textureFilter(CanvasItemModel)
    case masksFilter(CanvasItemModel)
    case adjustment(CanvasItemModel)
    case empty

    var id: String { self.title }

    // То, что показываем в меню выбора нового слоя
    static var allCases: [ToolItem] {
        [
            .photoPicker,
            .videoPicker,
            .camera,
            .template,
            .stickers,
            .text(nil),
            .drawing
            //.backgroundColor
        ]
    }
    
    var innerCanvasModel: CanvasItemModel? {
        switch self {
        case .template: return nil
        case .stickers: return nil
        case .photoPicker: return nil
        case .videoPicker: return nil
        case .camera: return nil
        case .drawing: return nil
        case .backgroundColor: return nil
        case .text(let item): return item
        case .concreteItem(let item): return item
        case .imageCropper(let item): return item
        case .colorFilter(let item): return item
        case .textureFilter(let item): return item
        case .masksFilter(let item): return item
        case .adjustment(let item): return item
        case .empty: return nil
        }
    }

    var title: String {
        switch self {
        case .template:
            return Strings.template
        case .text:
            return Strings.text
        case .stickers:
            return Strings.stickersCustom
        case .photoPicker:
            return Strings.addPhoto
        case .videoPicker:
            return Strings.addVideo
        case .camera:
            return Strings.camera
        case .drawing:
            return Strings.drawing
        case .backgroundColor:
            return Strings.background
        case .empty, .concreteItem, .imageCropper, .adjustment, .colorFilter, .textureFilter, .masksFilter:
            return ""
        }
    }
    
    var imageName: String {
        switch self {
        case .template:
            return "TypeTemplate"
        case .text:
            return "TypeText"
        case .stickers:
            return "TypeStickers"
        case .photoPicker:
            return "TypePhoto"
        case .videoPicker:
            return "TypeVideo"
        case .camera:
            return "TypeCamera"
        case .drawing:
            return "TypeDraw"
        case .backgroundColor:
            return ""
        case .empty, .concreteItem, .imageCropper, .adjustment, .colorFilter, .textureFilter, .masksFilter:
            return ""
        }
    }

    var image: Image {
        switch self {
        case .template:
            return Image(systemName: "square.stack.3d.down.right")
        case .text:
            return Image(systemName: "textformat.size")
        case .stickers:
            return Image(systemName: "seal.fill")
        case .photoPicker:
            return Image(systemName: "photo.on.rectangle")
        case .videoPicker:
            return Image(systemName: "film")
        case .camera:
            return Image(systemName: "camera.aperture")
        case .drawing:
            return Image(systemName: "pencil")
        case .backgroundColor:
            return Image(systemName: "paintbrush.fill")
        case .empty, .concreteItem, .imageCropper, .adjustment, .colorFilter, .textureFilter, .masksFilter:
            return Image("")
        }
    }
}
