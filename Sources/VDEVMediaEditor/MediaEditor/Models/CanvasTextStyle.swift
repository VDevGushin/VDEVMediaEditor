//
//  CanvasTextStyle.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.02.2023.
//

import SwiftUI

// MARK: - Text style
public struct CanvasTextStyle: CaseIterable, Equatable {
    public struct ShadowCfg: Equatable {
        var color: UIColor
        var offset: CGSize
        var blur: CGFloat

        static let `default` = ShadowCfg(
            color: AppColors.black.uiColor.withAlphaComponent(0.2),
            offset: .init(width: 3, height: 3),
            blur: 12
        )
    }

    var fontFamily: String
    var lineHeightMultiple: CGFloat
    var kern: CGFloat
    var uppercased: Bool
    var shadow: ShadowCfg?
    
    public init(fontFamily: String, lineHeightMultiple: CGFloat, kern: CGFloat, uppercased: Bool, shadow: ShadowCfg? = nil) {
        self.fontFamily = fontFamily
        self.lineHeightMultiple = lineHeightMultiple
        self.kern = kern
        self.uppercased = uppercased
        self.shadow = shadow
    }

    func font(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: fontFamily, size: size) ?? .systemFont(ofSize: size)
    }

    public static let `default` = CanvasTextStyle(
        fontFamily: UIFont.systemFont(ofSize: 32).familyName,
        lineHeightMultiple: 0,
        kern: 0,
        uppercased: false
    )

    public static let basicText = CanvasTextStyle(
        fontFamily: "VisueltPro-Regular",
        lineHeightMultiple: 32/30,
        kern: 0,
        uppercased: false
    )

    public static let boldText = CanvasTextStyle(
        fontFamily: "Gramatika-Bold",
        lineHeightMultiple: 32/26,
        kern: 0,
        uppercased: true,
        shadow: .default
    )

    public static let serifText =  CanvasTextStyle(
        fontFamily: "MaregrapheCaption-Regular",
        lineHeightMultiple: 32/30,
        kern: 0,
        uppercased: false
    )

    public static let mono = CanvasTextStyle(
        fontFamily: "GTPressuraPro-Regular",
        lineHeightMultiple: 32/30,
        kern: 0,
        uppercased: false
    )

    public static var allCases: [CanvasTextStyle] {
        [basicText, boldText, serifText, mono]
    }
}

