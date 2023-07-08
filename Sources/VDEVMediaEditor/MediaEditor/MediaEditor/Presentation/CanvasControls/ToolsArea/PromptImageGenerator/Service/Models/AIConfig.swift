//
//  AIConfig.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import SwiftUI
import CoreML
import StableDiffusion

@available(iOS 16.2, *)
final class AIConfig {
    let computeUnits: MLComputeUnits
    let modelInfo: ModelInfo
    let mlModelConfiguration: MLModelConfiguration
    let disableSafety: Bool
    
    private init() {
        computeUnits = .cpuOnly
        modelInfo = ModelInfo.v21Base
        mlModelConfiguration = MLModelConfiguration()
        mlModelConfiguration.computeUnits = computeUnits
        disableSafety = false
    }
    
    static let shared = AIConfig()
}
