//
//  Error+Ex.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation

public extension Error {
    var isUnauthorized: Bool {
        guard let error = self as? URLError else { return false }

        if error.code == .userAuthenticationRequired {
            return true
        }

        return false
    }
}

public struct ErrorRepresentation {
    @Injected private var strings: VDEVMediaEditorStrings
    
    private(set) var title: String = ""
    private(set) var message: String = ""
    
    init(message: String) {
        self.title = strings.error
        self.message = message
    }
}

extension Error {
    func makeRepresentable() -> ErrorRepresentation {
        return ErrorRepresentation(message: self.localizedDescription)
    }
}
