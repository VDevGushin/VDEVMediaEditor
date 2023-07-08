//
//  AIImageGeneratorVM.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import Combine
import StableDiffusion
import CoreImage
import CoreML

@available(iOS 16.2, *)
final class AIImageGeneratorVM: ObservableObject {
    @Published private(set) var state: GenerationState = .startup
    @Published var positivePrompt = AIConfig.shared.DEFAULT_PROMPT
    @Published var negativePrompt = ""
    
    private let scheduler = AIConfig.shared.scheduler
    private let pipeline: Pipeline
    private var progressSubscriber: Cancellable?
    
    init(pipeline: Pipeline) {
        self.pipeline = pipeline
        
        progressSubscriber = pipeline
            .progressPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                guard let progress = progress else { return }
                self?.state = .running(progress)
            }
    }
    
    deinit {
        cancelGeneration()
    }
    
    func submit() {
        if case .running = state { return }
        Task {
            await set(state: .running(nil))
            do {
                let result = try await generate()
                if result.userCanceled {
                    await set(state: .userCanceled)
                } else {
                    await set(state: .complete(positivePrompt, result.image, result.lastSeed, result.interval))
                }
            } catch {
                await set(state: .failed(error))
            }
        }
    }
    
    func cancelGeneration() {
        pipeline.setCancelled()
    }
}

@available(iOS 16.2, *)
private extension AIImageGeneratorVM {
    @MainActor
    private func set(state: GenerationState) async {
        self.state = state
    }
    
    func generate() async throws -> GenerationResult {
        let speed = AIConfig.shared.seed
        let seed = speed >= 0 ? UInt32(speed) : nil
        let steps = AIConfig.shared.steps
        let disableSafety = AIConfig.shared.disableSafety
        let guidanceScale = AIConfig.shared.guidanceScale
        
        return try pipeline.generate(
            prompt: positivePrompt,
            negativePrompt: negativePrompt,
            scheduler: scheduler,
            numInferenceSteps: Int(steps),
            seed: seed,
            guidanceScale: Float(guidanceScale),
            disableSafety: disableSafety
        )
    }
}

@available(iOS 16.2, *)
extension AIImageGeneratorVM {
    enum GenerationState {
        case startup
        case running(StableDiffusionProgress?)
        case complete(String, CGImage?, UInt32, TimeInterval?)
        case userCanceled
        case failed(Error)
    }
}
