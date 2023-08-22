//
//  ItemProcessingWatcher.swift
//  
//
//  Created by Vladislav Gushin on 23.08.2023.
//

import Foundation
import Combine

protocol ItemProcessingWatcher {
    var inProcessing: AnyPublisher<Bool, Never> { get }
    func startProcessing()
    func finishProcessing()
}

final class ItemProcessingWatcherImpl: ItemProcessingWatcher {
    var inProcessing: AnyPublisher<Bool, Never> {
        _inProcessing
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private var _inProcessing = CurrentValueSubject<Bool, Never>(false)
    
    func startProcessing() {
        guard !_inProcessing.value else { return }
        _inProcessing.send(true)
    }
    
    func finishProcessing() {
        guard _inProcessing.value else { return }
        _inProcessing.send(false)
    }
}
