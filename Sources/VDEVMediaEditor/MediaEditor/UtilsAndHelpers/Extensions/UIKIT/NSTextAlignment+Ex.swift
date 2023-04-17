//
//  NSTextAlignment.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.02.2023.
//

import UIKit
import SwiftUI

extension NSTextAlignment {
    init(textAlignment id: Int) {
        switch id {
        case 0: self = .left
        case 1: self = .center
        case 2: self = .right
        default: self = .center
        }
    }
}

extension NSTextAlignment {
    var textAlignment: TextAlignment {
        switch self {
        case .left: return .leading
        case .center: return .center
        case .right: return .trailing
        default: return .center
        }
    }

    var horizontalAlignment: Alignment {
        switch self {
        case .left: return .leading
        case .center: return .center
        case .right: return .trailing
        default: return .center
        }
    }
}
