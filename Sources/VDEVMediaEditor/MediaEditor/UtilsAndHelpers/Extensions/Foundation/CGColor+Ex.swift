//
//  CGColor+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import Foundation

import CoreImage

fileprivate let colorspaceMap: [String: CFString] = [
    "genericCMYK": CGColorSpace.genericCMYK,
    "displayP3": CGColorSpace.displayP3,
    "genericRGBLinear": CGColorSpace.genericRGBLinear,
    "adobeRGB1998": CGColorSpace.adobeRGB1998,
    "sRGB": CGColorSpace.sRGB,
    "genericGrayGamma2_2": CGColorSpace.genericGrayGamma2_2,
    "genericXYZ": CGColorSpace.genericXYZ,
    "genericLab": CGColorSpace.genericLab,
    "acescgLinear": CGColorSpace.acescgLinear,
    "itur_709": CGColorSpace.itur_709,
    "itur_2020": CGColorSpace.itur_2020,
    "rommrgb": CGColorSpace.rommrgb,
    "dcip3": CGColorSpace.dcip3,
    "extendedLinearITUR_2020": CGColorSpace.extendedLinearITUR_2020,
    "extendedLinearDisplayP3": CGColorSpace.extendedLinearDisplayP3,
    "displayP3_HLG": CGColorSpace.displayP3_HLG,
    "extendedSRGB": CGColorSpace.extendedSRGB,
    "linearSRGB": CGColorSpace.linearSRGB,
    "extendedLinearSRGB": CGColorSpace.extendedLinearSRGB,
    "extendedGray": CGColorSpace.extendedGray,
    "linearGray": CGColorSpace.linearGray,
    "extendedLinearGray": CGColorSpace.extendedLinearGray
    // "itur_2020_PQ": CGColorSpace.itur_2020_PQ,
    // "itur_2020_HLG": CGColorSpace.itur_2020_HLG,
    // "displayP3_PQ_EOTF": CGColorSpace.displayP3_PQ_EOTF,
    // "itur_2020_PQ_EOTF": CGColorSpace.itur_2020_PQ_EOTF,
    // "extendedITUR_2020": CGColorSpace.extendedITUR_2020,
    // "extendedDisplayP3": CGColorSpace.extendedDisplayP3,
    // "displayP3_PQ": CGColorSpace.displayP3_PQ,
]

extension CGColorSpace {
    static func fromCFIDString(_ cfIdString: String) -> CGColorSpace? {
        guard let realCFString = colorspaceMap[cfIdString],
              let colorSpace = CGColorSpace(name: realCFString) else {
            return nil
        }
        return colorSpace
    }
}
