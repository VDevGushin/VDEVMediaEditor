//
//  CanvasTextForTemplateItemModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 17.03.2023.
//

import Foundation

final class CanvasTextForTemplateItemModel: CanvasItemModel {
    @Published var text: CanvasTextModel
    
    init(text: CanvasTextModel) {
        self.text = text
        super.init(type: .textForTemplate)
    }
    
    deinit {
        Log.d("❌ Deinit[TEMPLATE]: CanvasTextForTemplateItemModel")
    }
}
