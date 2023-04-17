//
//  Error+Ex.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation

extension Error {
    var isUnauthorized: Bool {
        guard let error = self as? URLError else { return false }

        if error.code == .userAuthenticationRequired {
            return true
        }

        return false
    }
}
