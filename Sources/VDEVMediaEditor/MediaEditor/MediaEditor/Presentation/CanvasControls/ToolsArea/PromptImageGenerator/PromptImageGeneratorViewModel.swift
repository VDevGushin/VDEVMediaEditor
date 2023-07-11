//
//  PromptImageGeneratorViewModel.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import Combine
import UIKit

final class PromptImageGeneratorViewModel: ObservableObject {
    @Published private(set) var state: VMState = .notStarted
    private var operation: AnyCancellable?
    private let generateImageFromTextService = GenerateImageFromTextService()
    private let onComplete: (UIImage) -> Void
    
    init(onComplete: @escaping (UIImage) -> Void) {
        self.onComplete = onComplete
        
        operation = generateImageFromTextService.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case.loading:
                    self?.state = .loading
                case .notStarted:
                    self?.state = .notStarted
                case .success(image: let image):
                    self?.onComplete(image)
                case .error(error: let error):
                    self?.state = .error(error: error)
                case .inProgress(progress: let progress):
                    self?.state = .inProgress(progress: progress)
                }
            }
    }
    
    func submit(message: String) {
        generateImageFromTextService.execute(message: message)
    }
    
    func cancelLoadCoreML() {
        generateImageFromTextService.cancel()
    }
}

extension PromptImageGeneratorViewModel {
    enum VMState {
        case loading
        case notStarted
        case error(error: Error? = nil)
        case inProgress(progress: Int)
    }
}

extension String: Error {}
