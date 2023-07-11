//
//  PromptImageGeneratorViewModel.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import Combine

final class PromptImageGeneratorViewModel: ObservableObject {
    @Published private(set) var state: VMState = .initial
    private var operation: AnyCancellable?
    private let generateImageFromTextService = GenerateImageFromTextService()
    
    init() {
    }
    
    func submit() {
        generateImageFromTextService.execute()
    }
    
    func cancelLoadCoreML() {
        generateImageFromTextService.cancel()
    }
}

extension PromptImageGeneratorViewModel {
    enum VMState {
        case processing
        case ready
        case initial
        case error(Error)
    }
}

extension String: Error {}
