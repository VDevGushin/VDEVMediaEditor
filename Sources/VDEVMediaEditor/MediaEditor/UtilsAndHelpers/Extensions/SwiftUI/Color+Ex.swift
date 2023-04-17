//
//  Color_Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import SwiftUI

extension Color {
    var uiColor: UIColor {
        if #available(iOS 14.0, *) {
            return UIColor(self)
        }

        let comps = components()
        return UIColor(red: comps.r, green: comps.g, blue: comps.b, alpha: comps.a)
    }

    private func components() -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }

    init(hue: Double, saturation: Double, lightness: Double) {
        let (h, s, v) = Color.hsl_to_hsv(h: hue, s: saturation, l: lightness)
        self.init(hue: h, saturation: s, brightness: v)
    }

    static func hsv_to_hsl(h: Double, s: Double, v: Double) -> (h: Double, s: Double, l: Double) {
        let l = v * (1 - s / 2)
        let s = [0, 1].contains(l) ? 0 : (v - l)/min(l, 1 - l)
        return (h, s, l)
    }

    static func hsl_to_hsv(h: Double, s: Double, l: Double) -> (h: Double, s: Double, v: Double) {
        let v = l + s * min(l, 1-l)
        let s = v == 0 ? 0 : 2 * (1 - l / v)
        return (h, s, v)
    }
}

