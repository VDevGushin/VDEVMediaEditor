//
//  String_Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import Foundation

extension String: Error, LocalizedError {
    public var localizedDescription: String {
        self
    }
    
    public var errorDescription: String? {
        NSLocalizedString(self, comment: "")
    }
}

extension String {
    var url: URL? { URL(string: self) }
    
    func replacing(placeholders: [String: String]) -> String {
        placeholders.reduce(self) { (partialResult, dictPair) in
            return partialResult.replacingOccurrences(of: "{\(dictPair.key)}", with: dictPair.value)
        }
    }
}
