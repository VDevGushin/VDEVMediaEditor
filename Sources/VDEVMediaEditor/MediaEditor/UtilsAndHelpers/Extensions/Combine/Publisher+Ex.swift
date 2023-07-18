//
//  Publisher+Ex.swift
//  
//
//  Created by Vladislav Gushin on 14.07.2023.
//

import Combine
import Foundation

extension AnyPublisher {
    @inlinable
    static func single<T, F>(_ value: T) -> AnyPublisher<T, F> {
        Just(value).setFailureType(to: F.self).eraseToAnyPublisher()
    }
    
    @inlinable
    static func fail<T, F>(_ value: F) -> AnyPublisher<T, F> {
        Fail(error: value).eraseToAnyPublisher()
    }
}

public extension Publisher {    
    @inlinable
    func receiveOnMain() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        receive(on: DispatchQueue.main)
    }

    @inlinable
    func receiveOnGlobal(_ qos: DispatchQoS.QoSClass = .default) -> Publishers.ReceiveOn<Self, DispatchQueue> {
        receive(on: DispatchQueue.global(qos: qos))
    }
}
