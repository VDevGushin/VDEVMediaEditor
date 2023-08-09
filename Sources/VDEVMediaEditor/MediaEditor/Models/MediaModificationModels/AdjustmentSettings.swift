//
//  AdjustmentSettings.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import Foundation
import CoreImage

struct AdjustmentSettings: Identifiable {
    let id = UUID()
    var brightness: Double
    var contrast: Double
    var saturation: Double
    var highlight: Double
    var shadow: Double
    var blurRadius: Double
    var alpha: Double
    var sharpen: Double

    func makeFilterDescriptors() -> [FilterDescriptor] {
        return [
            FilterDescriptor(
                name: "CIColorControls",
                params: [
                    "inputBrightness": .number(NSNumber(value: brightness)),
                    "inputContrast": .number(NSNumber(value: contrast)),
                    "inputSaturation": .number(NSNumber(value: saturation))
                ]
            ),
            
            FilterDescriptor(
                name: "CIHighlightShadowAdjust",
                params: [
                    "inputHighlightAmount": .number(NSNumber(value: highlight)),
                    "inputShadowAmount": .number(NSNumber(value: shadow))
                ]
            ),
            
            FilterDescriptor(
                name: "CIGaussianBlur",
                params: [
                    "inputRadius": .number(NSNumber(value: blurRadius))
                ]
            ),
            
            FilterDescriptor(
                name: "CIColorMatrix",
                params: [
                    "inputAVector": .vector(CIVector(values: [0, 0, 0, alpha], count: 4))
                ]
            ),
            
            FilterDescriptor(
                name: "CISharpenLuminance",
                params: [
                    "inputSharpness": .number(NSNumber(value: sharpen))
                ]
            )
        ]
    }
}

extension AdjustmentSettings {
    enum DefaultValues {
        case currentContrastValue
        case currentBrightnessValue
        case currentSaturationValue
        case currentSharpenValue
        case currentHighlightValue
        case currentShadowValue
        case currentGaussianValue
        case currentAlphaValue
        
        var value: Double {
            let colorFilters = CIFilter(name: "CIColorControls")!
            let sharpenLuminanceFilters = CIFilter(name: "CISharpenLuminance")!
            let highlightShadowAdjustFilters = CIFilter(name: "CIHighlightShadowAdjust")!
            let colorMatrixFilters = CIFilter(name: "CIColorMatrix")!
            switch self {
            case .currentContrastValue:
                return colorFilters.value(forKey: kCIInputContrastKey) as? Double ?? 0.0
            case .currentBrightnessValue:
                return colorFilters.value(forKey: kCIInputBrightnessKey) as? Double ?? 0.0
            case .currentSaturationValue:
                return colorFilters.value(forKey: kCIInputSaturationKey) as? Double ?? 1.0
            case .currentSharpenValue:
                return sharpenLuminanceFilters.value(forKey: kCIInputSharpnessKey) as? Double ?? 0.4
            case .currentHighlightValue:
                return highlightShadowAdjustFilters.value(forKey: "inputHighlightAmount") as? Double ?? 0.5
            case .currentShadowValue:
                return highlightShadowAdjustFilters.value(forKey: "inputShadowAmount") as? Double ?? 0
            case .currentGaussianValue:
                return 0.0
            case .currentAlphaValue:
                return colorMatrixFilters.value(forKey: "inputAVector") as? Double ?? 1
            }
        }
    }
}
