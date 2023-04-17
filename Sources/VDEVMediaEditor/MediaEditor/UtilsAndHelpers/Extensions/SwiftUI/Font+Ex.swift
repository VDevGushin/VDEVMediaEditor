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

    static func mabry(weight: Font.Weight = .regular, size: CGFloat) -> Font {
        var name = "MabryPro"
        switch weight {
        case .black:
            name += "-Black"
        case .bold:
            name += "-Bold"
        case .light:
            name += "-Light"
        case .medium:
            name += "-Medium"
        default:
            name += "-Regular"
        }
        return Font(uiFont: UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: weight.uiKitWeight))
    }

    static func GTPressura(size: CGFloat) -> Font {
        let name = "GTPressuraPro-Regular"
        return Font(uiFont: UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: .regular))
    }

    static func gramatika(size: CGFloat) -> Font {
        let name = "Gramatika-Bold"
        return Font(uiFont: UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: .regular))
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
