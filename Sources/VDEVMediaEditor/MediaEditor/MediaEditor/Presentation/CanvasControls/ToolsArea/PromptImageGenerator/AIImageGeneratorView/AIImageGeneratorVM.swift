//
//  AIImageGeneratorVM.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Combine
import CoreImage
import CoreML
import UIKit
import StableDiffusion

@available(iOS 16.2, *)
final class AIImageGeneratorVM: ObservableObject {
    @Published private(set) var state: GenerationState = .startup
    @Published var positivePrompt = AIConfig.shared.DEFAULT_PROMPT
    @Published var negativePrompt = ""
    
    private let scheduler = AIConfig.shared.scheduler
    private let pipeline: Pipeline
    private var progressSubscriber: Cancellable?
    private let onComplete: (UIImage) -> Void
    
    init(pipeline: Pipeline, onComplete: @escaping (UIImage) -> Void) {
        self.pipeline = pipeline
        self.onComplete = onComplete
        
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
        Task(priority: .high) {
            await set(state: .running(nil))
            do {
                let result = try await generate()
                if result.userCanceled {
                    await set(state: .userCanceled)
                } else {
                    await set(state: .complete(positivePrompt, result.image, result.lastSeed, result.interval))
                    await setComplete(image: result.image)
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
    
    @MainActor
    private func setComplete(image: CGImage?) async {
        guard let image = image else {
            state = .startup
            return
        }
        
        let result = UIImage(cgImage: image)
        onComplete(result)
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
