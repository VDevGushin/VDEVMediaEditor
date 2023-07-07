//
//  PromptImageGeneratorMLLoader.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import Combine

final class PromptImageGeneratorMLLoader {
    private(set) var mlSate: CurrentValueSubject<LoaderState, Never> = .init(.initial)
    
    init() {
        if checkForExist() {
            mlSate.send(.ready)
            return
        }
    }
    
    func checkForExist() -> Bool {
        return false
    }
    
    func load() {
        guard !checkForExist() else {
            mlSate.send(.ready)
            return
        }
        mlSate.send(.loading)
    }
    
    enum LoaderState {
        case ready
        case loading
        case initial
    }
}
