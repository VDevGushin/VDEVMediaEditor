//
//  TemplateBuilderSimpleMarginPack.swift
//  
//
//  Created by Vladislav Gushin on 12.06.2023.
//

import Foundation


// Обычные шаблоны
final class TemplateBuilderSimpleMarginPack: TemplateBuilder {
    let margin: CGFloat = 8
    @MainActor func buildTemplate(canvasSize: CGSize) -> TemplatePack {
        let variant1 = variantType1(canvasSize)
        let variant2 = variantType2(canvasSize)
        let variant3 = variantType3(canvasSize)
        let variant4 = variantType4(canvasSize)
        let variant5 = variantType5(canvasSize)
        
        let variants: [TemplatePack.Variant] = [variant1, variant2, variant3, variant4, variant5]
        
        let result = TemplatePack(id: "57d5acf1-d1f0-4bef-897f-e3dd5b4dcea1",
                                  name: "Simple frame",
                                  cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"),
                                  isAttached: true,
                                  variants: variants)
        
        return result
    }
}

fileprivate extension TemplateBuilderSimpleMarginPack {
    // Одна фотка
    private func variantType1(_ canvasSize: CGSize) -> TemplatePack.Variant {
        let width = canvasSize.width - (margin * 2)
        let height = canvasSize.height - (margin * 2)
        
        let items = [
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: margin,
                                                  y: margin,
                                                  width: width,
                                                  height: height),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"))
    }
    
    // 2 фотки (горизонталь)
    private func variantType2(_ canvasSize: CGSize) -> TemplatePack.Variant {
        let width = canvasSize.width - (margin * 2)
        let height = canvasSize.height / 2 - (margin + margin / 2)
        
        let items = [
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: margin,
                                                  y: margin,
                                                  width: width,
                                                  height: height),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: margin,
                                                  y: height + margin + margin,
                                                  width: width,
                                                  height: height),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"))
    }
    
    // 2 фотки (вертикаль)
    private func variantType3(_ canvasSize: CGSize) -> TemplatePack.Variant {
        let width = canvasSize.width / 2 - (margin + margin / 2)
        let height = canvasSize.height - (margin * 2)
        
        let items = [
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: margin,
                                                  y: margin,
                                                  width: width,
                                                  height: height),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: width + margin + margin,
                                                  y: margin,
                                                  width: width,
                                                  height: height),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"))
    }
    
    // 2 фотки (вертикаль) / 3 фотки вертикаль
    private func variantType4(_ canvasSize: CGSize) -> TemplatePack.Variant {
        let width = canvasSize.width / 2 - (margin + margin / 2)
        let height1 = canvasSize.height / 3 - (margin + margin / 3)
        let height2 = canvasSize.height / 2 - (margin + margin / 2)
        
        let items = [
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: margin,
                                                  y: margin,
                                                  width: width,
                                                  height: height1),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: margin,
                                                  y: height1 + margin + margin,
                                                  width: width,
                                                  height: height1),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: margin,
                                                  y: height1 + height1 + margin + margin + margin,
                                                  width: width,
                                                  height: height1),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: width + margin + margin,
                                                  y: margin,
                                                  width: width,
                                                  height: height2),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: width + margin + margin,
                                                  y: height2 + margin + margin,
                                                  width: width,
                                                  height: height2),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"))
    }
    
    // 3 фотки (вертикаль) / 2 фотки вертикаль
    private func variantType5(_ canvasSize: CGSize) -> TemplatePack.Variant {
        let width = canvasSize.width / 2 - (margin + margin / 2)
        let height1 = canvasSize.height / 3 - (margin + margin / 3)
        let height2 = canvasSize.height / 2 - (margin + margin / 2)
        
        let items = [
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: margin,
                                                  y: margin,
                                                  width: width,
                                                  height: height2),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: margin,
                                                  y: height2 + margin + margin,
                                                  width: width,
                                                  height: height2),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: width + margin + margin,
                                                  y: margin,
                                                  width: width,
                                                  height: height1),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: width + margin + margin,
                                                  y: height1 + margin + margin,
                                                  width: width,
                                                  height: height1),
                                      fontPreset: nil),

            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: width + margin + margin,
                                                  y: height1 + height1 + margin + margin + margin,
                                                  width: width,
                                                  height: height1),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL(string: "https://ucarecdn.com/b347a275-7869-4db8-ad47-7e4b88a2a4ac/"))
    }
}
