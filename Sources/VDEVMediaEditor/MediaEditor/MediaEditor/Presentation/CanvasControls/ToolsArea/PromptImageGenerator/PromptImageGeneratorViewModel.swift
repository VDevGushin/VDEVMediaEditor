//
//  PromptImageGeneratorViewModel.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import Combine

@available(iOS 16.2, *)
final class PromptImageGeneratorViewModel: ObservableObject {
    @Published private(set) var state: VMState = .initial
    @Injected private var loader: CoreMLLoader
    private var operation: AnyCancellable?
    init() {
        operation = loader
            .mlSate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                switch value {
                case let .ready(url):
                    self.state = .ready(url)
                case let .downloading(progress):
                    self.state = .downloading(progress)
                case .notStarted:
                    self.state = .initial
                case let .failed(error):
                    self.state = .error(error)
                case .notAvailable:
                    self.state = .notAvailable
                case .uncompressing:
                    self.state = .uncompressing
                }
            }
    }
    
    func loadCoreML() {
        loader.load()
    }
    
    func cancelLoadCoreML() {
        loader.cancelLoad()
    }
}

@available(iOS 16.2, *)
extension PromptImageGeneratorViewModel {
    enum VMState {
        case downloading(Double)
        case ready(URL)
        case initial
        case notAvailable
        case error(Error)
        case uncompressing
    }
}
