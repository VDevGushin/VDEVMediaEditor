//
//  TemplatePack.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 16.02.2023.
//

import UIKit
import CollectionConcurrencyKit
import SwiftUI
import Combine

public struct PlaceholdersKeys {
    public let challengeTitle = "challenge.title"
    fileprivate init() {}
}

public let kPlaceholders = PlaceholdersKeys()

@MainActor
public class TemplatePack: ObservableObject {
    var coverUrl: URL? { cover }

    static var cellAspect: CGFloat { 16/9 }
    static var contentMode: UIView.ContentMode { .scaleAspectFill }

    let id: String
    let name: String
    let cover: URL?
    let isAttached: Bool

    let variants: [Variant]

    public init(id: String, name: String, cover: URL?, isAttached: Bool, variants: [Variant]) {
        self.id = id
        self.name = name
        self.cover = cover
        self.isAttached = isAttached
        self.variants = variants
    }

    public struct Variant {
        public struct Item {
            public struct FontPreset {
                let fontSize: CGFloat
                let textStyle: CanvasTextStyle
                let verticalAlignment: Int
                let textAlignment: Int
                let color: UIColor
                
                public init(fontSize: CGFloat, textStyle: CanvasTextStyle, verticalAlignment: Int, textAlignment: Int, color: UIColor) {
                    self.fontSize = fontSize
                    self.textStyle = textStyle
                    self.verticalAlignment = verticalAlignment
                    self.textAlignment = textAlignment
                    self.color = color
                }
            }

            let blendingMode: BlendingMode
            let filters: [EditorFilter]
            let isLocked: Bool
            let isMovable: Bool

            let text: String
            let placeholderText: String
            let url: URL?

            let rect: CGRect

            let fontPreset: FontPreset?
            
            public init(blendingMode: BlendingMode, filters: [EditorFilter], isLocked: Bool, isMovable: Bool, text: String, placeholderText: String, url: URL?, rect: CGRect, fontPreset: FontPreset?) {
                self.blendingMode = blendingMode
                self.filters = filters
                self.isLocked = isLocked
                self.isMovable = isMovable
                self.text = text
                self.placeholderText = placeholderText
                self.url = url
                self.rect = rect
                self.fontPreset = fontPreset
            }
        }

        let items: [Item]
        let id: String
        let cover: URL?
        
        public init(items: [Item], id: String, cover: URL?) {
            self.items = items
            self.id = id
            self.cover = cover
        }
    }

    func makeVariantLayers(variantIdx: Int) -> [TemplatePack.Variant.Item] {
        guard variantIdx >= 0, variantIdx < variants.count else { return [] }
        return variants[variantIdx].items
    }
}
