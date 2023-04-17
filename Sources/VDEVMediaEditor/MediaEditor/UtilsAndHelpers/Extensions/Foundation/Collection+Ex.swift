//
//  Collection+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 26.02.2023.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Collection where Element: Collection {
    var isAllEmpty: Bool {
        for subArray in self {
            if subArray.isEmpty {
                return false
            }
        }
        return true
    }
}
