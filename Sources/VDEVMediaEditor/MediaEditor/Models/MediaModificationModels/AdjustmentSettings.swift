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
    let alpha: Double

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
            )
            
        ]
    }
}
