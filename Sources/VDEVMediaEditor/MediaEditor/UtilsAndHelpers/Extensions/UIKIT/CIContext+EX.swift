//
//  CIContext+Ex.swift
//  
//
//  Created by Vladislav Gushin on 03.10.2023.
//

import UIKit

extension CIContext {
    static let editorContext = CIContext(
        options: [
            .useSoftwareRenderer : false
        ]
    )
}
