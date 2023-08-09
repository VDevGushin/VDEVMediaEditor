//
//  TemplateBuilderSimplePack.swift
//  
//
//  Created by Vladislav Gushin on 12.06.2023.
//

import Foundation

// Обычные шаблоны
final class TemplateBuilderSimplePack: TemplateBuilder {
    
    @MainActor
    func buildTemplate(canvasSize: CGSize) -> TemplatePack {
        let variant1 = variantType1(canvasSize)
        let variant2 = variantType2(canvasSize)
        let variant3 = variantType3(canvasSize)
        let variant4 = variantType4(canvasSize)
        let variant5 = variantType5(canvasSize)
        let variant6 = variantType6(canvasSize)
        let variant7 = variantType7(canvasSize)
        let variant8 = variantType8(canvasSize)
        let variant9 = variantType9(canvasSize)
        let variant10 = variantType10(canvasSize)
        let variant11 = variantType11(canvasSize)
        let variant12 = variantType12(canvasSize)
        
        let variants: [TemplatePack.Variant] = [variant1,
                                                variant2,
                                                variant12,
                                                variant3,
                                                variant4,
                                                variant5,
                                                variant6,
                                                variant7,
                                                variant8,
                                                variant9,
                                                variant10,
                                                variant11]
      
        let result = TemplatePack(id: "SimpleTemplates",
                     name: "Simple",
                     cover: URL.getLocal(fileName: "simpleTemplateCover", ofType: "jpg"),
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
                                    id: "variantType1",
                                    cover: URL.getLocal(fileName: "simpleVariant1", ofType: "jpg"))
    }
    
    // 2 фотки (Вертикаль)
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
                                    id: "variantType2",
                                    cover: URL.getLocal(fileName: "simpleVariant2", ofType: "jpg"))
    }
    
    // 2 фотки (Горизонталь)
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
                                    cover: URL.getLocal(fileName: "simpleVariant3", ofType: "jpg"))
    }
    
    private func variantType12(_ canvasSize: CGSize) -> TemplatePack.Variant {
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
                                      rect: .init(x: 0.0,
                                                  y: canvasSize.height / 2,
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
                                                  y: canvasSize.height / 2,
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height / 2),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL.getLocal(fileName: "simpleVariant12", ofType: "jpg"))
    }
    
    // 3 фотки (вертикаль) / 2 фотки вертикаль
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
                                    cover: URL.getLocal(fileName: "simpleVariant5", ofType: "jpg"))
    }
    
    // 2 фотки (вертикаль) / 3 фотки вертикаль
    private func variantType5(_ canvasSize: CGSize) -> TemplatePack.Variant {
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
                                                  height: canvasSize.height / 2),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: 0.0,
                                                  y: canvasSize.height / 2,
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
                                      rect: .init(x: canvasSize.width / 2,
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
                                      rect: .init(x: canvasSize.width / 2,
                                                  y: (canvasSize.height / 3 * 2),
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height / 3),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL.getLocal(fileName: "simpleVariant4", ofType: "jpg"))
    }
    
    // 1 фотка  / 3 фотки вертикаль
    private func variantType6(_ canvasSize: CGSize) -> TemplatePack.Variant {
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
                                      rect: .init(x: canvasSize.width / 2,
                                                  y: (canvasSize.height / 3 * 2),
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height / 3),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL.getLocal(fileName: "simpleVariant6", ofType: "jpg"))
    }
    
    // 3 фотки (вертикаль) / 1 фотки вертикаль
    private func variantType7(_ canvasSize: CGSize) -> TemplatePack.Variant {
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
                                                  height: canvasSize.height),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL.getLocal(fileName: "simpleVariant7", ofType: "jpg"))
    }
    
    // 1 фотки (вертикаль) / 2 фотки вертикаль
    private func variantType8(_ canvasSize: CGSize) -> TemplatePack.Variant {
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
                                    cover: URL.getLocal(fileName: "simpleVariant8", ofType: "jpg"))
    }
    
    // 2 фотки (вертикаль) / 1 фотки вертикаль
    private func variantType9(_ canvasSize: CGSize) -> TemplatePack.Variant {
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
                                                  height: canvasSize.height / 2),
                                      fontPreset: nil),
            
            TemplatePack.Variant.Item(blendingMode: .sourceOver,
                                      filters: [],
                                      isLocked: false,
                                      isMovable: false,
                                      text: "",
                                      placeholderText: "",
                                      url: URL(string: "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"),
                                      rect: .init(x: 0.0,
                                                  y: canvasSize.height / 2,
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
                                                  y: 0.0,
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL.getLocal(fileName: "simpleVariant9", ofType: "jpg"))
    }
    
    // 1 фотки (горизонталь) / 2 фотки горизонталь
    private func variantType10(_ canvasSize: CGSize) -> TemplatePack.Variant {
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
                                      rect: .init(x: 0.0,
                                                  y: canvasSize.height / 2,
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
                                                  y: canvasSize.height / 2,
                                                  width: canvasSize.width / 2,
                                                  height: canvasSize.height/2),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL.getLocal(fileName: "simpleVariant10", ofType: "jpg"))
    }
    
    // 2 фотки (горизонталь) / 1 фотки горизонталь
    private func variantType11(_ canvasSize: CGSize) -> TemplatePack.Variant {
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
                                      rect: .init(x: 0.0,
                                                  y: canvasSize.height / 2,
                                                  width: canvasSize.width,
                                                  height: canvasSize.height / 2),
                                      fontPreset: nil)
        ]
        
        return TemplatePack.Variant(items: items,
                                    id: "0616f0e9-a9d0-45e5-8965-ec92040e0cb4",
                                    cover: URL.getLocal(fileName: "simpleVariant11", ofType: "jpg"))
    }
}
