//
//  CombinerOutput.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import SwiftUI

protocol VDEVMediaEditorOut {
    var onComplete: (@MainActor (CombinerOutput) -> ())? { get }
    var onClose: (@MainActor () -> ())? { get }
}

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
    }
}
