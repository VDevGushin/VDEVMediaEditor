//
//  Combine_Unretained.swift
//  
//
//  Created by Vladislav Gushin on 15.07.2023.
//

import Combine
import UIKit

public extension Publisher {
    @inlinable
    func sink<Root: AnyObject, Output>(
        on queue: DispatchQueue = .main,
        object: Root,
        receiveValue: @escaping (Root, Output) -> Void
    ) -> AnyCancellable where Output == Self.Output, Failure == Never {
        receive(on: queue)
            .withUnretained(object)
            .sink { root, value in
                receiveValue(root, value)
            }
    }

    @inlinable
    func sink<Root: AnyObject, Output, Failure>(
        on queue: DispatchQueue = .main,
        object: Root,
        failure: Failure,
        receiveCompletion: @escaping (Root, Subscribers.Completion<Failure>) -> Void,
        receiveValue: @escaping (Root, Output) -> Void
    ) -> AnyCancellable where Output == Self.Output,
                              Failure == Self.Failure {
        receive(on: queue)
            .withUnretained(object, failure: failure)
            .sink { [weak object] completion in
                guard let object = object else { return }
                receiveCompletion(object, completion)
            } receiveValue: { root, value in
                receiveValue(root, value)
            }
    }

    @inlinable
    func sink<Root: AnyObject, Output>(
        _ object: Root,
        receiveValue: @escaping (Root, Output) -> Void
    ) -> AnyCancellable where Output == Self.Output,
                                Failure == Never {
        withUnretained(object)
            .sink { root, value in
                receiveValue(root, value)
            }
    }

    @inlinable
    func sink<Root: AnyObject, Output, Failure>(
        _ object: Root,
        failure: Failure,
        receiveCompletion: @escaping (Root, Subscribers.Completion<Failure>) -> Void,
        receiveValue: @escaping (Root, Output) -> Void
    ) -> AnyCancellable where Output == Self.Output,
                              Failure == Self.Failure {
        withUnretained(object, failure: failure)
            .sink { [weak object] completion in
                guard let object = object else { return }
                receiveCompletion(object, completion)
            } receiveValue: { root, value in
                receiveValue(root, value)
            }
    }

    @inlinable
    func withUnretained<T: AnyObject, Output, Failure>(
        _ object: T,
        failure: Failure
    )-> AnyPublisher<(T, Self.Output), Self.Failure>
    where Output == Self.Output,
          Failure == Self.Failure  {
        flatMap {  [weak object] element -> AnyPublisher<(T, Output), Failure> in
            guard let object = object else {
                return AnyPublisher<(T, Output), Failure>.fail(failure)
            }
            return AnyPublisher<(T, Output), Failure>.single((object, element))
        }
        .eraseToAnyPublisher()
    }

    @inlinable
    func withUnretained<T: AnyObject, Output>(
        _ object: T
    ) -> Publishers.CompactMap<Self, (T, Self.Output)>
    where Output == Self.Output,
          Failure == Never {
        compactMap { [weak object] output in
            guard let object = object else {
                return nil
            }
            return (object, output)
        }
    }

    @inlinable
    func weakAssign<Root: AnyObject, Output>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on object: Root) -> AnyCancellable where Output == Self.Output {
        sink { _ in
            //
        } receiveValue: { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }

    @inlinable
    func weakAssign<Root: AnyObject, Output>(to keyPath: ReferenceWritableKeyPath<Root, Output?>, on object: Root) -> AnyCancellable where Output == Self.Output {
        sink { _ in
            //
        } receiveValue: { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }

    @inlinable
    func weakAssign<Root: AnyObject, Output>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on object: Root) -> AnyCancellable where Output == Self.Output, Failure == Never {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }

    @inlinable
    func weakAssign<Root: AnyObject, Output>(to keyPath: ReferenceWritableKeyPath<Root, Output?>, on object: Root) -> AnyCancellable where Output == Self.Output, Failure == Never {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
