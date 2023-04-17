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

struct PlaceholdersKeys {
    let challengeTitle = "challenge.title"
    fileprivate init() {}
}
let kPlaceholders = PlaceholdersKeys()

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

    init(id: String, name: String, cover: URL?, isAttached: Bool, variants: [Variant]) {
        self.id = id
        self.name = name
        self.cover = cover
        self.isAttached = isAttached
        self.variants = variants
    }

    struct Variant {
        struct Item {
            struct FontPreset {
                let fontSize: CGFloat
                let textStyle: CanvasTextStyle
                let verticalAlignment: Int
                let textAlignment: Int
                let color: UIColor
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
        }

        let items: [Item]
        let id: String
        let cover: URL?
    }

    func makeVariantLayers(variantIdx: Int) -> [TemplatePack.Variant.Item] {
        guard variantIdx >= 0, variantIdx < variants.count else { return [] }
        return variants[variantIdx].items
    }
}
