//
//  CanvasLayerPreview.swift
//  
//
//  Created by Vladislav Gushin on 05.07.2023.
//

import SwiftUI

struct CanvasLayerPreview<Content: View>: View {
    private let content: (CanvasItemModel) -> Content
    private let item: CanvasItemModel
    
    init(item: CanvasItemModel,
         @ViewBuilder content: @escaping (CanvasItemModel) -> Content) {
        self.item = item
        self.content = content
    }
    
    var body: some View { content(item) }
}
