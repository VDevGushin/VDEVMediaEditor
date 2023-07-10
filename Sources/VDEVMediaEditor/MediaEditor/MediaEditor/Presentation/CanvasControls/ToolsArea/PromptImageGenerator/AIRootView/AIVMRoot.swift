//
//  AIVMRoot.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Combine
import SwiftUI
import CoreML
import StableDiffusion

@available(iOS 16.2, *)
final class AIVMRoot: ObservableObject {
    @Published private(set) var state: VMState = .notStarted
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    @MainActor
    private func set(state: VMState) async {
        self.state = state
    }
    
    func prepareML() {
        Task {
            await set(state: .loadCoreML)
            do {
                let ml = try await loadML(url: url)
                let pipeline = Pipeline(ml)
                await set(state: .ready(pipeline))
            } catch {
                await set(state: .error(error))
            }
        }
    }
    
    func loadML(url: URL) async throws -> StableDiffusionPipeline {
        let beginDate = Date()
        var pipeline: StableDiffusionPipeline!
        try autoreleasepool {
            pipeline = try StableDiffusionPipeline(resourcesAt: url,
                                                       controlNet: [],
                                                       configuration: AIConfig.shared.mlModelConfiguration,
                                                       disableSafety: AIConfig.shared.disableSafety,
                                                       reduceMemory: AIConfig.shared.mlVariant.modelInfo.reduceMemory)
            try pipeline.loadResources()
            print("Pipeline loaded in \(Date().timeIntervalSince(beginDate))")
        }
        return pipeline!
    }
    
    enum VMState {
        case notStarted
        case loadCoreML
        case error(Error)
        case ready(Pipeline)
    }
}
