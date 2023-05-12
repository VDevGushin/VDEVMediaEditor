//
//  URL+NetworkAdapter.swift
//  MediaEditorSample
//
//  Created by Vladislav Gushin on 12.05.2023.
//

import Foundation

extension URL {
    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }
}
