//
//  CanvasTemplateModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 15.02.2023.
//

import UIKit
import IdentifiedCollections

final class CanvasTemplateModel: CanvasItemModel {
    private(set) var variants: [TemplatePack.Variant.Item]

    private(set) var layerItems: [CanvasItemModel] = []

    init(variants: [TemplatePack.Variant.Item], editorSize: CGSize) {
        self.variants = variants
        super.init(bounds: editorSize.rect, type: .template)
    }

    func update(layerItems: IdentifiedArrayOf<CanvasItemModel>) {
        self.layerItems = layerItems.elements
    }

    deinit { Log.d("❌ Deinit: CanvasTemplateModel") }

    override func copy() -> CanvasTemplateModel {
        return CanvasTemplateModel(variants: variants, editorSize: bounds.size)
    }
}
