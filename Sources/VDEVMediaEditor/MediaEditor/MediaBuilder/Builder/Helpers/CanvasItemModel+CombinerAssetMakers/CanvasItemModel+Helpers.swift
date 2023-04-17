//
//  CanvasItemModel+Helpers.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 25.03.2023.
//

import UIKit
import Foundation

extension Array where Element == CanvasItemModel {
    func getTotalCount() -> Int {
        var result = 1 // (bgColor)
        
        for element in self {
            if element.type == .template {
                let templated: CanvasTemplateModel = CanvasItemModel.toType(model: element)
                
                result += templated.layerItems.count
                continue
            }
            result += 1
        }
        return result
    }
}
