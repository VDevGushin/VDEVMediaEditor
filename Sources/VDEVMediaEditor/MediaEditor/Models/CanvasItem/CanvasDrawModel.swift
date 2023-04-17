//
//  CanvasDrawModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 15.02.2023.
//

import SwiftUI

// MARK: - Drawing
final class CanvasDrawModel: CanvasItemModel {
    @Published private(set) var image: UIImage

    init(image: UIImage,
         bounds: CGRect,
         offset: CGSize) {
        self.image = image

        super.init(offset: offset, bounds: bounds, type: .drawing)
    }

    deinit {
        Log.d("❌ Deinit: CanvasDrawModel")
    }

    override func copy() -> CanvasItemModel {
        let new = CanvasDrawModel(image: image, bounds: bounds, offset: .zero)
        new.update(offset: offset, scale: scale, rotation: rotation)
        return new
    }
}
