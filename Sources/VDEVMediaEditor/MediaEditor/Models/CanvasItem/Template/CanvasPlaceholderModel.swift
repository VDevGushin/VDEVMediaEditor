//
//  CanvasPlaceholderModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 17.02.2023.
//

import SwiftUI
import Combine


// MARK: - Image
final class CanvasPlaceholderModel: CanvasItemModel {
    @Published private(set) var url: URL?
    @Published private(set) var inProgress: Bool = false
    
    private(set) var filters: [EditorFilter]

    private(set) weak var imageModel: CanvasImagePlaceholderModel?
    private(set) weak var videoModel: CanvasVideoPlaceholderModel?

    var isMovable: Bool { filters.isEmpty }
    
    init(url: URL?,
         bounds: CGRect = .zero,
         offset: CGSize = .zero,
         filters: [EditorFilter],
         blendingMode: BlendingMode = .normal) {

        self.url = url
        self.filters = filters

        super.init(
            offset: offset,
            bounds: bounds,
            type: .placeholder,
            blendingMode: blendingMode)
    }

    deinit {
        Log.d("❌ Deinit[TEMPLATE]: CanvasPlaceholderModel")
    }

    func update(imageModel: CanvasImagePlaceholderModel?) {
        self.imageModel = imageModel
    }

    func update(videoModel: CanvasVideoPlaceholderModel?) {
        self.videoModel = videoModel
    }
}
