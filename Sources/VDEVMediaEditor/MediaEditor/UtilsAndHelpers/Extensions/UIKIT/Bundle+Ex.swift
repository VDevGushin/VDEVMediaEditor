//
//  Bundle_Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import Foundation

extension Bundle {
    // CFBundleVersion
    var version: String {
        Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }

    // CFBundleShortVersionString
    var shortVersion: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
}

