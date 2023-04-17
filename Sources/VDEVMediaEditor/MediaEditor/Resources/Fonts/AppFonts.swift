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
}




