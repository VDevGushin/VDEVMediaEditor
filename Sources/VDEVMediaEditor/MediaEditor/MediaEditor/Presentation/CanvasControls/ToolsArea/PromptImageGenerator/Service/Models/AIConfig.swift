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
    let mlVariant: MLVariant = .cpuAndNeuralEngine
    let mlRootFolderName = "CoreML"
    let modelInfo: ModelInfo = ModelInfo.v21Base
    let mlModelConfiguration: MLModelConfiguration
    
    let scheduler = StableDiffusionScheduler.dpmSolverMultistepScheduler
    let defaultComputeUnits: MLComputeUnits = ModelInfo.defaultComputeUnits
    
    let DEFAULT_PROMPT = "Labrador in the style of Vermeer"
    
    let disableSafety: Bool = false
    let steps = 20.0
    let numImages = 1.0
    let seed = -1.0
    let guidanceScale = 7.5
    
    private init() {
        mlModelConfiguration = MLModelConfiguration()
        mlModelConfiguration.computeUnits = mlVariant.computeUnits
    }
    
    static let shared = AIConfig()
}

@available(iOS 16.2, *)
struct MLVariant {
    let url: URL
    let computeUnits: MLComputeUnits
    let zipName: String
    let pathName: String
    
    static let cpuAndNeuralEngine: MLVariant = .init(
        url: URL(string: "https://huggingface.co/pcuenq/coreml-stable-diffusion-2-1-base/resolve/main/coreml-stable-diffusion-2-1-base_split_einsum_compiled.zip")!,
        computeUnits: MLComputeUnits.cpuAndNeuralEngine,
        zipName: "coreml-stable-diffusion-2-1-base_split_einsum_compiled.zip",
        pathName: "coreml-stable-diffusion-2-1-base_split_einsum_compiled"
    )
    
    static let cpuOnly: MLVariant = .init(
        url: URL(string: "https://huggingface.co/pcuenq/coreml-stable-diffusion-2-1-base/resolve/main/coreml-stable-diffusion-2-1-base_original_compiled.zip")!,
        computeUnits: MLComputeUnits.cpuOnly,
        zipName: "coreml-stable-diffusion-2-1-base_original_compiled.zip",
        pathName: "coreml-stable-diffusion-2-1-base_original_compiled"
    )
}
