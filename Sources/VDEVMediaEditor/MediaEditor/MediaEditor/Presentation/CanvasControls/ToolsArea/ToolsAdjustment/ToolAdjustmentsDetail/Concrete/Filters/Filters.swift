//
//  Filters.swift
//  
//
//  Created by Vladislav Gushin on 05.09.2023.
//

import Foundation
import CoreImage

enum AllAdjustmentsFilters {
    static let highlights = FilterHighlights()
    static let brightness = FilterBrightness()
    static let contrast = FilterContrast()
    static let saturation = FilterSaturation()
    static let shadow = FilterShadow()
    static let blur = FilterBlur()
    static let alpha = FilterAlpha()
    static let temperature = FilterTemperature()
    static let vignette = FilterVignette()
    static let sharpen = FilterSharpen()
}

struct FilterHighlights {
    let min: Double = 0
    let max: Double = 1
    let normal: Double = 0
}

struct FilterBrightness {
    let min: Double = -0.2
    let max: Double = 0.2
    let normal: Double = 0
}

struct FilterContrast {
    let min: Double = -0.18
    let max: Double = 0.18
    let normal: Double = 0
}

struct FilterSaturation {
    let min: Double = -1
    let max: Double = 1
    let normal: Double = 0
}

struct FilterShadow {
    let min: Double = -1
    let max: Double = 1
    let normal: Double = 0
}

struct FilterBlur {
    let min: Double = 0
    let max: Double = 15
    let normal: Double = 0
}

struct FilterAlpha {
    let min: Double = 0
    let max: Double = 1
    let normal: Double = 1
}

struct FilterTemperature {
    let min: Double = -3000
    let max: Double = 3000
    let normal: Double = 0
}

struct FilterVignette {
    let value: Vignette = .init()
    let radius: Radius = .init()
    
    struct Radius {
        let min: Double = 0
        let max: Double = 10
        let normal: Double = 0
    }
    
    struct Vignette {
        let min: Double = 0
        let max: Double = 2
        let normal: Double = 0
    }
}

struct FilterSharpen {
    let radius: Radius = .init()
    let value: Sharpness = .init()
    
    struct Radius {
        let min: Double = 0
        let max: Double = 20
        let normal: Double = 0
    }
    
    struct Sharpness {
        let min: Double = 0
        let max: Double = 1
        let normal: Double = 0
    }
}

enum ValueCalc {
    static func make(
        value: CGFloat,
        max: CGFloat,
        min: CGFloat
    ) -> String {
        let minValue = min <= 0 ? 0 : abs(min)
        let allValue = minValue + max
        return "\(Int((value * 100) / allValue)) %"
    }
}
