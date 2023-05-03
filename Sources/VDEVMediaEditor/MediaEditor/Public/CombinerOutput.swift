//
//  CombinerOutput.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import SwiftUI

public struct CombinerOutput {
    public let cover: URL
    public let url: URL
    public var featuresUsageData: FeaturesUsageData?
}

public extension CombinerOutput {
    struct FeaturesUsageData {
        public let usedMasks: Bool
        public let usedTextures: Bool
        public let usedFilters: Bool
        public let usedTemplates: Bool
        public let usedVideo: Bool
        public let usedVideoSound: Bool
        public let usedMusic: Bool
        public let usedStickers: Bool
        
        init(from layers: [CanvasItemModel]) {
            usedVideoSound = false
            usedMusic = false
            usedMasks = layers.hasMasks
            usedTextures = layers.hasTextures
            usedFilters = layers.hasColorFilters
            usedTemplates = layers.hasTemplates
            usedVideo =  layers.hasVideos
            usedStickers = layers.hasStickers
        }
    }
}

// MARK: - Helpers
fileprivate extension Array where Element == CanvasItemModel {
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

