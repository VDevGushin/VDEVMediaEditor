//
//  ImageProcessingController.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 26.02.2023.
//

import UIKit
import BackgroundRemoval
import SwiftUI
import CoreML

final class ImageProcessingController {
    func removeBackground(on item: CanvasItemModel,
                          completion: @escaping (CanvasImageModel) -> Void) {
        
        DispatchQueue.global(qos: .utility).async {
            let item: CanvasImageModel = CanvasItemModel.toType(model: item)
            
            let newImage = BackgroundRemoval().removeBackground(image: item.image)
            
            let newItem = CanvasImageModel(image: newImage, asset: nil)
            
            newItem.update(offset: item.offset, scale: item.scale, rotation: item.rotation)
            
            DispatchQueue.main.async {
                completion(newItem)
            }
        }
    }
}
