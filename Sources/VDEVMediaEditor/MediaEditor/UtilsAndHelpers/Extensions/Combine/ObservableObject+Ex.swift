//
//  BaseCombine.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 02.02.2023.
//

import Foundation
import Combine

extension ObservableObject where Self.ObjectWillChangePublisher == ObservableObjectPublisher {
    func observe<T: ObservableObject>(nested inner: T) -> AnyCancellable {
        inner.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }
    
    func observeOnMain<T: ObservableObject>(nested inner: T) -> AnyCancellable {
        inner
            .objectWillChange
            .sink(on: .main, object: self) { wSelf, _ in
                wSelf.objectWillChange.send()
            }
    }
}
