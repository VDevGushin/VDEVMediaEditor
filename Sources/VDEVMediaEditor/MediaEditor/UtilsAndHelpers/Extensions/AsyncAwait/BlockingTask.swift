//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 24.08.2023.
//

import Foundation

// - MARK: Box for sync operation (problem with render autoreleasepool)
func BlockingTask<T>(_ body: @escaping () async -> T?) -> T? {
    let semaphore = DispatchSemaphore(value: 0)
    let box = Box<T>()
    Task {
        let result = await body()
        box.result = result
        semaphore.signal()
    }
    semaphore.wait()
    return box.result
}

private final class Box<T> {
    var result: T?
}
