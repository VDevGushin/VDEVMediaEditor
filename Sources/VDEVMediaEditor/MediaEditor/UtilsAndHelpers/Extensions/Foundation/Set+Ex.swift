//
//  Set+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.02.2023.
//

import Foundation
import Combine

extension Set where Element == AnyCancellable {
    mutating func limitCancel(_ value: Int = 10) {
        while count > value { self.popFirst()?.cancel() }
    }
    
    mutating func cancelAll() {
        self = Set<AnyCancellable>()
    }
}
