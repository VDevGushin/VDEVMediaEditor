//
//  Pipeline.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import CoreML
import Combine
import StableDiffusion

@available(iOS 16.2, *)
typealias StableDiffusionProgress = StableDiffusionPipeline.Progress

@available(iOS 16.2, *)
struct GenerationResult {
    var image: CGImage?
    var lastSeed: UInt32
    var interval: TimeInterval?
    var userCanceled: Bool
}

@available(iOS 16.2, *)
final class Pipeline {
    let pipeline: StableDiffusionPipeline
    let maxSeed: UInt32
    
    var progress: StableDiffusionProgress? = nil {
        didSet {
            progressPublisher.value = progress
        }
    }
    lazy private(set) var progressPublisher: CurrentValueSubject<StableDiffusionProgress?, Never> = CurrentValueSubject(progress)
    
    private var canceled = false
    
    init(_ pipeline: StableDiffusionPipeline, maxSeed: UInt32 = UInt32.max) {
        self.pipeline = pipeline
        self.maxSeed = maxSeed
    }
    
    func generate(
        prompt: String,
        negativePrompt: String = "",
        scheduler: StableDiffusionScheduler,
        numInferenceSteps stepCount: Int,
        seed: UInt32?,
        guidanceScale: Float,
        disableSafety: Bool
    ) throws -> GenerationResult {
        let beginDate = Date()
        canceled = false
        print("Generating...")
        
        let theSeed = seed ?? UInt32.random(in: 0...maxSeed)
        var config = StableDiffusionPipeline.Configuration(prompt: prompt)
        config.negativePrompt = negativePrompt
        config.imageCount = 1
        config.stepCount = stepCount
        config.seed = theSeed
        config.guidanceScale = guidanceScale
        config.disableSafety = disableSafety
        config.schedulerType = scheduler
        
        var images: [CGImage?] = []
        try autoreleasepool {
            images = try pipeline.generateImages(configuration: config) { progress in
                handleProgress(progress)
                return !canceled
            }
        }
        
        let interval = Date().timeIntervalSince(beginDate)
        print("Got images: \(images) in \(interval)")
        
        // Unwrap the 1 image we asked for, nil means safety checker triggered
        let image = images.compactMap({ $0 }).first
        
        return  GenerationResult(image: image, lastSeed: theSeed, interval: interval, userCanceled: canceled)
    }
    
    func handleProgress(_ progress: StableDiffusionPipeline.Progress) {
        self.progress = progress
    }
    
    func setCancelled() {
        canceled = true
    }
}

