//
//  Striong+Ex.swift
//  VDEVMediaEditorExample
//
//  Created by Vladislav Gushin on 17.04.2023.
//

import Foundation

extension String {
}

extension String {
    var url: URL? { URL(string: self) }
    
    func replacing(placeholders: [String: String]) -> String {
        placeholders.reduce(self) { (partialResult, dictPair) in
            return partialResult.replacingOccurrences(of: "{\(dictPair.key)}", with: dictPair.value)
        }
    }
}
