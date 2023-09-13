//
//  ToolItem.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import SwiftUI

enum ToolItem: CaseIterable, Identifiable, Equatable {
    // Тулзы, которые показываем в меню добавления новых слоев
    case template
    case stickers
    case photoPicker // выбор только фоток
    case videoPicker // выбор только видео
    case musicPiker // Выбор музыки
    case camera
    case drawing
    case backgroundColor
    case text(CanvasTextModel?)
    case aspectRatio
    case settings
    
    // Тулзы для редактирования конкретных объектов слоя
    case concreteItem(CanvasItemModel)
    case imageCropper(CanvasImageModel)
    case colorFilter(CanvasItemModel)
    case neuralFilters(CanvasItemModel)
    case textureFilter(CanvasItemModel)
    case masksFilter(CanvasItemModel)
    case adjustment(CanvasItemModel)
    case empty
    
    var id: String { self.title }
    
    // То, что показываем в меню выбора нового слоя
    static var allCases: [ToolItem] {
        let settings = DI.resolve(VDEVMediaEditorSettings.self)
        
        var toolsItems: [ToolItem] = []
        toolsItems.append(.photoPicker)
        toolsItems.append(.videoPicker)
        toolsItems.append(.camera)
        if settings.canAddMusic {
            toolsItems.append(.musicPiker)
        }
        toolsItems.append(.template)
        toolsItems.append(.stickers)
        toolsItems.append(.text(nil))
        toolsItems.append(.drawing)
        return toolsItems
    }
    
    var innerCanvasModel: CanvasItemModel? {
        switch self {
        case .template: return nil
        case .stickers: return nil
        case .photoPicker: return nil
        case .videoPicker: return nil
        case .musicPiker: return nil
        case .camera: return nil
        case .drawing: return nil
        case .backgroundColor: return nil
        case .aspectRatio: return nil
        case .settings: return nil
        case .text(let item): return item
        case .concreteItem(let item): return item
        case .imageCropper(let item): return item
        case .colorFilter(let item): return item
        case .neuralFilters(let item): return item
        case .textureFilter(let item): return item
        case .masksFilter(let item): return item
        case .adjustment(let item): return item
        case .empty: return nil
        }
    }
    
    var title: String {
        let Strings = DI.resolve(VDEVMediaEditorStrings.self)
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
        case .musicPiker:
            return Strings.addMusic
        case .camera:
            return Strings.camera
        case .drawing:
            return Strings.drawing
        case .backgroundColor:
            return Strings.background
        case  .aspectRatio, .settings, .empty, .concreteItem, .imageCropper, .adjustment, .colorFilter, .textureFilter, .masksFilter, .neuralFilters:
            return ""
        }
    }
    
    var image: UIImage {
        let images = DI.resolve(VDEVImageConfig.self)
        switch self {
        case .template:
            return images.typed.typeTemplate
        case .text:
            return images.typed.typeText
        case .stickers:
            return images.typed.typeStickers
        case .photoPicker:
            return images.typed.typePhoto
        case .videoPicker:
            return images.typed.typeVideo
        case .musicPiker:
            return images.typed.typeVideo
        case .camera:
            return images.typed.typeCamera
        case .drawing:
            return images.typed.typeDraw
        case .backgroundColor:
            fatalError("No image")
        case .settings:
            fatalError("No image")
        case .aspectRatio:
            fatalError("No image")
        case .empty, .concreteItem, .imageCropper, .adjustment, .colorFilter, .textureFilter, .masksFilter, .neuralFilters:
            fatalError("No image")
        }
    }
}
