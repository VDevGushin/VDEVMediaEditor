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
    public var aspect: CGFloat
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
