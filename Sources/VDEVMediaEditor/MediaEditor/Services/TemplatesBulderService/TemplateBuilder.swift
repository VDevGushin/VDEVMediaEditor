//
//  TemplateBuilder.swift
//  
//
//  Created by Vladislav Gushin on 12.06.2023.
//

import Foundation


protocol TemplateBuilder {
    @MainActor
    func buildTemplate(canvasSize: CGSize) -> TemplatePack
}

// Обычные шаблоны
final class TemplateBuilderSimplePack: TemplateBuilder {
    @MainActor func buildTemplate(canvasSize: CGSize) -> TemplatePack {
        let variant1 = variantType1(canvasSize)
        let variant2 = variantType2(canvasSize)
        let variant3 = variantType3(canvasSize)
        let variant4 = variantType4(canvasSize)
    
        let variants: [TemplatePack.Variant] = [variant1, variant2, variant3, variant4]
      
        let result = TemplatePack(id: "57d5acf1-d1f0-4bef-897f-e3dd5b4dcea1",
                     name: "Simple templates",
                     cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"),
                     isAttached: true,
                     variants: variants)
        
        return result
    }
    
    // Одна фотка
    private func variantType1(_ canvasSize: CGSize) -> TemplatePack.Variant {
        let items = [
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: 0.0, y: 0.0, width: canvasSize.width, height: canvasSize.height),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"))
    }
    
    // 2 фотки (горизонталь)
    private func variantType2(_ canvasSize: CGSize) -> TemplatePack.Variant {
        let items = [
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: 0.0,
                                                  y: 0.0,
                                                  width: canvasSize.width,
                                                  height: canvasSize.height / 2),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: 0.0, y: canvasSize.height / 2,
                                                  width: canvasSize.width,
                                                  height: canvasSize.height / 2),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"))
    }
    
    // 2 фотки (вертикаль)
    private func variantType3(_ canvasSize: CGSize) -> TemplatePack.Variant {
        let items = [
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: 0.0,
                                                  y: 0.0,
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: canvasSize.width / 2,
                                                  y: 0.0,
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"))
    }
    
    // 2 фотки (вертикаль)
    private func variantType4(_ canvasSize: CGSize) -> TemplatePack.Variant {
        
        let items = [
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: 0.0,
                                                  y: 0.0,
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height / 3),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: 0.0,
                                                  y: canvasSize.height / 3,
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height / 3),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: 0.0,
                                                  y: (canvasSize.height / 3 * 2),
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height / 3),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: canvasSize.width / 2,
                                                  y: 0.0,
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height / 2),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: canvasSize.width / 2,
                                                  y: (canvasSize.height / 2),
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height / 2),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"))
    }
}
