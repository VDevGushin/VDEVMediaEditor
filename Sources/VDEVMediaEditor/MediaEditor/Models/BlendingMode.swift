//
//  BlendingMode.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 16.02.2023.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

/// Этот enum неразрывно связан с blending mode CIFilter'ов
public enum BlendingMode: String {
    case addition = "CIAdditionCompositing"
    case color = "CIColorBlendMode"
    case colorBurn = "CIColorBurnBlendMode"
    case colorDodge = "CIColorDodgeBlendMode"
    case darken = "CIDarkenBlendMode"
    case difference = "CIDifferenceBlendMode"
    case divide = "CIDivideBlendMode"
    case exclusion = "CIExclusionBlendMode"
    case hardLight = "CIHardLightBlendMode"
    case hue = "CIHueBlendMode"
    case lighten = "CILightenBlendMode"
    case linearBurn = "CILinearBurnBlendMode"
    case linearDodge = "CILinearDodgeBlendMode"
    case luminosity = "CILuminosityBlendMode"
    case maximum = "CIMaximumCompositing"
    case minimum = "CIMinimumCompositing"
    case multiplyBlendMode = "CIMultiplyBlendMode"
    case multiply = "CIMultiplyCompositing"
    case overlay = "CIOverlayBlendMode"
    case pinLight = "CIPinLightBlendMode"
    case saturation = "CISaturationBlendMode"
    case screen = "CIScreenBlendMode"
    case softLight = "CISoftLightBlendMode"
    case sourceAtop = "CISourceAtopCompositing"
    case sourceIn = "CISourceInCompositing"
    case sourceOut = "CISourceOutCompositing"
    case sourceOver = "CISourceOverCompositing"
    case subtract = "CISubtractBlendMode"

    static let normal = BlendingMode.sourceOver
}

extension BlendingMode {
    public var ciFilter: CIFilter {
        return CIFilter(name: rawValue) ?? CIFilter.sourceOverCompositing()
    }
}

extension BlendingMode {
    public var swiftUI: BlendMode {
        switch self {
        case .addition: return .normal
        case .color: return .color
        case .colorBurn: return .colorBurn
        case .colorDodge: return .colorDodge
        case .darken: return .darken
        case .difference: return .difference
        case .divide: return .normal
        case .exclusion: return .exclusion
        case .hardLight: return .hardLight
        case .hue: return .hue
        case .lighten: return .lighten
        case .linearBurn: return .normal
        case .linearDodge: return .normal
        case .luminosity: return .luminosity
        case .maximum: return .normal
        case .minimum: return .normal
        case .multiplyBlendMode: return .multiply
        case .multiply: return .multiply
        case .overlay: return .overlay
        case .pinLight: return .normal
        case .saturation: return .saturation
        case .screen: return .screen
        case .softLight: return .softLight
        case .sourceAtop: return .sourceAtop
        case .sourceIn: return .normal
        case .sourceOut: return .destinationOut
        case .sourceOver: return .normal
        case .subtract: return .normal
        }
    }
}
