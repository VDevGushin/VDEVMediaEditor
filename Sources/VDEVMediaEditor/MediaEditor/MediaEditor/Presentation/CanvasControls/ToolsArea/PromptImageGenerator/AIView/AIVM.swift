//
//  AIVM.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Combine
import SwiftUI
import CoreML
import StableDiffusion

@available(iOS 16.2, *)
final class AIVM: ObservableObject {
    @Published private(set) var state: VMState = .notStarted
    private let url: URL
    private var pipeline: Pipeline?
    
    init(url: URL) {
        self.url = url
    }
    
    func loadAll() {
        state = .loadCoreML
        do {
            let ml = try loadML(url: url)
            self.pipeline = Pipeline(ml)
            state = .ready
        } catch {
            state = .error(error)
        }
    }
    
    func loadML(url: URL) throws -> StableDiffusionPipeline {
        let beginDate = Date()
        let configuration = MLModelConfiguration()
        configuration.computeUnits = .cpuAndNeuralEngine
        let pipeline = try StableDiffusionPipeline(resourcesAt: url,
                                                   controlNet: [],
                                                   configuration: configuration,
                                                   disableSafety: false,
                                                   reduceMemory: ModelInfo.v2Base.reduceMemory)
        print("Pipeline loaded in \(Date().timeIntervalSince(beginDate))")
        
        return pipeline
    }
    
    enum VMState {
        case notStarted
        case loadCoreML
        case error(Error)
        case ready
    }
}
