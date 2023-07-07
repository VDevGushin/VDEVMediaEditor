//
//  AppFonts.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.04.2023.
//

import SwiftUI

struct AppFonts {
    private static let elmaTrioRegularFontName: String = "ElmaTrio-Regular"
    
    private static func font(fontFamily: String, fontSize: CGFloat) -> Font {
        Font.init(uiFont: UIFont(name: fontFamily, size: fontSize) ?? .systemFont(ofSize: fontSize))
    }

    static func elmaTrioRegular(_ fontSize: CGFloat) -> Font {
        font(fontFamily: elmaTrioRegularFontName, fontSize: fontSize)
    }
    
    
    static func GTPressura(size: CGFloat) -> Font {
        let name = "GTPressuraPro-Regular"
        return Font(uiFont: UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: .regular))
    }

    static func gramatika(size: CGFloat) -> Font {
        let name = "Gramatika-Bold"
        return Font(uiFont: UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: .regular))
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
}




