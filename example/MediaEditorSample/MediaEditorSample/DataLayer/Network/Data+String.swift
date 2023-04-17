//
//  Data+String.swift
//  W1D1
//
//  Created by Алексей Лысенко on 14.04.2022.
//

import Foundation

extension Data {
    static func +=(left: inout Data, right: String) {
        guard let data = right.data(using: .utf8) else { return }
        left.append(data)
    }
}
