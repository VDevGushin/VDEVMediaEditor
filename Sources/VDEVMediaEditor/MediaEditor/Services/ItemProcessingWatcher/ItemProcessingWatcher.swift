//
//  ItemProcessingWatcher.swift
//  
//
//  Created by Vladislav Gushin on 23.08.2023.
//

import Foundation
import Combine

struct ItemAIProcessingState: Equatable {
    let item: CanvasItemModel
    let state: State
    
    enum State {
        case finished
        case processing
        case notDetermined
    }
}

protocol ItemProcessingWatcher {
    var inProcessing: AnyPublisher<Bool, Never> { get }
    var inAIProcessing: AnyPublisher<ItemAIProcessingState, Never> { get }
    func startProcessing()
    func finishProcessing()
    
    func startAIProcessing(item: CanvasItemModel)
    func finishAIProcessing(item: CanvasItemModel)
}

final class ItemProcessingWatcherImpl: ItemProcessingWatcher {
    var inProcessing: AnyPublisher<Bool, Never> {
        _inProcessing
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    var inAIProcessing: AnyPublisher<ItemAIProcessingState, Never> {
        _inAIProcessing
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private var _inProcessing = CurrentValueSubject<Bool, Never>(false)
    private var _inAIProcessing = CurrentValueSubject<ItemAIProcessingState, Never>(
        .init(
            item: .init(),
            state: .notDetermined
        )
    )
    
    func startProcessing() {
        guard !_inProcessing.value else { return }
        _inProcessing.send(true)
    }
    
    func finishProcessing() {
        guard _inProcessing.value else { return }
        _inProcessing.send(false)
    }
    
    func startAIProcessing(item: CanvasItemModel) {
        guard _inAIProcessing.value.state != .processing else { return }
        _inAIProcessing.send(.init(item: item, state: .processing))
    }
    
    func finishAIProcessing(item: CanvasItemModel) {
        guard _inAIProcessing.value.state != .finished else { return }
        _inAIProcessing.send(.init(item: item, state: .finished))
    }
}
