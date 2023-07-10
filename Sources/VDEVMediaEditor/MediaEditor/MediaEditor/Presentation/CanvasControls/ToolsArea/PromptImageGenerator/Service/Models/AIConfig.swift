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
    let mlVariant: MLVariant = .v21Base
    let mlRootFolderName = "hf-diffusion-models"
    let mlModelConfiguration: MLModelConfiguration
    
    let scheduler = StableDiffusionScheduler.dpmSolverMultistepScheduler
    let defaultComputeUnits: MLComputeUnits = ModelInfo.defaultComputeUnits
    
    let DEFAULT_PROMPT = "Labrador in the style of Vermeer"
    
    let disableSafety: Bool = false
    let steps = 15.0
    let numImages = 1.0
    let seed = UInt32.max
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
    let modelInfo: ModelInfo
    
    static let v15: MLVariant = .init(
        url: URL(string: "https://huggingface.co/pcuenq/coreml-small-stable-diffusion-v0/resolve/main/coreml-small-stable-diffusion-v0_original_compiled.zip")!,
        computeUnits: MLComputeUnits.cpuOnly,
        zipName: "coreml-small-stable-diffusion-v0_original_compiled.zip",
        pathName: "coreml-small-stable-diffusion-v0_original_compiled",
        modelInfo: ModelInfo.ofaSmall
    )
    
    static let cpuAndNeuralEngine: MLVariant = .init(
        url: URL(string: "https://huggingface.co/pcuenq/coreml-stable-diffusion-2-1-base/resolve/main/coreml-stable-diffusion-2-1-base_split_einsum_compiled.zip")!,
        computeUnits: MLComputeUnits.cpuAndNeuralEngine,
        zipName: "coreml-stable-diffusion-2-1-base_split_einsum_compiled.zip",
        pathName: "coreml-stable-diffusion-2-1-base_split_einsum_compiled",
        modelInfo: ModelInfo.v21Base
    )
    
    static let v21Base: MLVariant = {
        let model = ModelInfo.v21Base
        let url = model.modelURL(for: ModelInfo.defaultAttention)
        let computeUnits = ModelInfo.defaultAttention.defaultComputeUnits
        return MLVariant(
            url: url,
            computeUnits: computeUnits,
            zipName: "coreml-stable-diffusion-2-1-base_split_einsum_compiled.zip",
            pathName: "coreml-stable-diffusion-2-1-base_split_einsum_compiled",
            modelInfo: model
        )
    }()
}
