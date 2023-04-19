//
//  CombinerOutput.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import SwiftUI

public protocol VDEVMediaEditorOut {
    var output: (@MainActor (CombinerOutput) -> ()) { get }
    var close: (@MainActor () -> ()) { get }
}

public struct CombinerOutput {
    public let cover: URL
    public let url: URL
    public var featuresUsageData: FeaturesUsageData?
}

public extension CombinerOutput {
    struct FeaturesUsageData {
        let usedMasks: Bool
        let usedTextures: Bool
        let usedFilters: Bool
        let usedTemplates: Bool
        let usedVideo: Bool
        let usedVideoSound: Bool
        let usedMusic: Bool
        let usedStickers: Bool
    }
}
