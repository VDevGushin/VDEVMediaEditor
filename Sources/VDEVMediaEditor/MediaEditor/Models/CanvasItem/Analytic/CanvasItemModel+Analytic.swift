//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 06.05.2023.
//

import Foundation

extension Array where Element == CanvasItemModel {
    var hasMasks: Bool {
        if contains(where: { $0.masks != nil }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasMasks {
                    result = true
                    break
                }
            }
            
            if let canvasPlaceholderModel = item as? CanvasPlaceholderModel {
                if let videoModel = canvasPlaceholderModel.videoModel  {
                    if videoModel.masks != nil {
                        result = true
                        break
                    }
                }
                
                if let imageModel = canvasPlaceholderModel.imageModel  {
                    if imageModel.masks != nil {
                        result = true
                        break
                    }
                }
            }
        }
        
        return result
    }
    
    var hasTextures: Bool {
        if contains(where: { $0.textures != nil }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasTextures {
                    result = true
                    break
                }
            }
            
            if let canvasPlaceholderModel = item as? CanvasPlaceholderModel {
                if let videoModel = canvasPlaceholderModel.videoModel  {
                    if videoModel.textures != nil {
                        result = true
                        break
                    }
                }
                
                if let imageModel = canvasPlaceholderModel.imageModel  {
                    if imageModel.textures != nil {
                        result = true
                        break
                    }
                }
            }
        }
        
        return result
    }
    
    var hasColorFilters: Bool {
        if contains(where: { $0.colorFilter != nil }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasColorFilters {
                    result = true
                    break
                }
            }
            
            if let canvasPlaceholderModel = item as? CanvasPlaceholderModel {
                if let videoModel = canvasPlaceholderModel.videoModel  {
                    if videoModel.colorFilter != nil {
                        result = true
                        break
                    }
                }
                
                if let imageModel = canvasPlaceholderModel.imageModel  {
                    if imageModel.colorFilter != nil {
                        result = true
                        break
                    }
                }
            }
        }
        
        return result
    }
    
    var hasVideos: Bool {
        if contains(where: { $0.type == .video }) {
            return true
        }

        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasVideos {
                    result = true
                    break
                }
            }
            
            if let canvasPlaceholderModel = item as? CanvasPlaceholderModel {
                if canvasPlaceholderModel.videoModel != nil {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
    
    var hasTemplates: Bool {
        if contains(where: { $0.type == .template }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasTemplates {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
    
    var hasStickers: Bool {
        if contains(where: { $0.type == .sticker }) {
            return true
        }
        
        var result = false
        for item in self {
            if let placeholder = item as? CanvasTemplateModel {
                if placeholder.layerItems.hasStickers {
                    result = true
                    break
                }
            }
        }
        
        return result
    }
}

