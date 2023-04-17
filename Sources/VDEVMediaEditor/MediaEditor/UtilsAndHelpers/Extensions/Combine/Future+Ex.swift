//
//  Future+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.02.2023.
//

import Combine
import SwiftUI

extension Future where Failure == Never {
    convenience init(asyncFunc: @escaping () async -> Output) {
        self.init { promise in
            Task {
                let result = await asyncFunc()
                promise(.success(result))
            }
        }
    }
}

extension Future where Failure == Error {
    convenience init(asyncFunc: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let result = try await asyncFunc()
                    promise(.success(result))
                } catch {
                    Log.e(error)
                    promise(.failure(error))
                }
            }
        }
    }
}
