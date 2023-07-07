//
//  Font+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.02.2023.
//

import SwiftUI

extension Font {
    init(uiFont: UIFont) {
        self.init(uiFont as CTFont)
    }
}

extension Font.Weight {
    var uiKitWeight: UIFont.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .thin: return .thin
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black

        default: return .regular
        }
    }
}
