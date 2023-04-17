//
//  CombinerOutput.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import SwiftUI

struct CombinerOutput {
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

    let cover: URL
    let url: URL
    var featuresUsageData: FeaturesUsageData?
}
