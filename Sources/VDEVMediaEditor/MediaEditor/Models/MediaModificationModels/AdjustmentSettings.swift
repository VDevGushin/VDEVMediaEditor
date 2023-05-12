//
//  AdjustmentSettings.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import Foundation

struct AdjustmentSettings: Identifiable {
    let id = UUID()
    var brightness: Double
    var contrast: Double
    var saturation: Double
    var highlight: Double
    var shadow: Double

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
            )
        ]
    }
}
