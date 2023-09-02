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
    var brightness: Double?
    var contrast: Double?
    var saturation: Double?
    var highlight: Double?
    var shadow: Double?
    var blurRadius: Double?
    var alpha: Double?
    var temperature: Double?
    var vignette: (Double, CGRect)?
    var sharpness: (radius: Double, sharpness: Double)?
    
    init(
        brightness: Double? = nil,
        contrast: Double? = nil,
        saturation: Double? = nil,
        highlight: Double? = nil,
        shadow: Double? = nil,
        blurRadius: Double? = nil,
        alpha: Double? = nil,
        temperature: Double? = nil,
        vignette: (Double, CGRect)? = nil,
        sharpness: (radius: Double, sharpness: Double)? = nil
    ) {
        if let brightness = brightness,
           AllAdjustmentsFilters.highlights.normal != brightness {
            self.brightness = brightness
        }
        
        if let contrast = contrast,
           AllAdjustmentsFilters.contrast.normal != contrast {
            self.contrast = contrast
        }
        
        if let saturation = saturation,
           AllAdjustmentsFilters.saturation.normal != saturation {
            self.saturation = saturation
        }
        
        if let highlight = highlight,
           AllAdjustmentsFilters.highlights.normal != highlight {
            self.highlight = highlight
        }
        
        if let shadow = shadow,
           AllAdjustmentsFilters.shadow.normal != shadow {
            self.shadow = shadow
        }
        
        if let blurRadius = blurRadius,
           AllAdjustmentsFilters.blur.normal != blurRadius {
            self.blurRadius = blurRadius
        }
        
        if let alpha = alpha,
           AllAdjustmentsFilters.alpha.normal != alpha {
            self.alpha = alpha
        }
        
        if let temperature = temperature,
           AllAdjustmentsFilters.temperature.normal != temperature {
            self.temperature = temperature
        }
        
        if let vignette = vignette,
           AllAdjustmentsFilters.vignette.normal != vignette.0 {
            self.vignette = vignette
        }
        
        if let sharpness = sharpness {
            if AllAdjustmentsFilters.sharpen.value.normal != sharpness.sharpness ||
                AllAdjustmentsFilters.sharpen.radius.normal != sharpness.radius {
                self.sharpness = sharpness
            }
        }
    }

    func makeFilterDescriptors() -> [FilterDescriptor] {
        let result: [FilterDescriptor?] = [
            makeCIColorControls(
                brightness: brightness,
                contrast: contrast,
                saturation: saturation
            ),
            makeCIHighlightShadowAdjust(
                highlight: highlight,
                shadow: shadow
            ),
            makeCIGaussianBlur(blurRadius: blurRadius),
            makeCIColorMatrix(alpha: alpha),
            makeCITemperatureAndTint(temperature: temperature),
            // makeCIVignette(vignette: vignette),
            makeCISharpenLuminance(sharpness: sharpness),
        ]
        return result.compactMap { $0 }
    }
}

fileprivate extension AdjustmentSettings {
    func makeCISharpenLuminance(sharpness: (radius: Double, sharpness: Double)?) -> FilterDescriptor? {
        var params = [String: FilterDescriptor.Param]()
        
        if let sharpness = sharpness {
            params["inputRadius"] = .number(NSNumber(value: sharpness.radius))
            params["inputSharpness"] = .number(NSNumber(value: sharpness.sharpness))
        }
        
        if params.isEmpty { return nil }
        
        return FilterDescriptor(
            name: "CISharpenLuminance",
            params: params
        )
    }
    
    func makeCIVignette(vignette: (Double, CGRect)?) -> FilterDescriptor? {
        var params = [String: FilterDescriptor.Param]()
        
        if let vignette = vignette {
            let radius = RadiusCalculator.radius(value: vignette.0, max: AllAdjustmentsFilters.vignette.max, imageExtent: vignette.1)
            
            params[kCIInputRadiusKey] = .number(NSNumber(value: radius))
            params[kCIInputIntensityKey] = .number(NSNumber(value: vignette.0))
        }
        
        if params.isEmpty { return nil }
        
        return FilterDescriptor(
            name: "CIVignette",
            params: params
        )
    }
    
    func makeCITemperatureAndTint(temperature: Double?) -> FilterDescriptor? {
        var params = [String: FilterDescriptor.Param]()
        
        if let temperature = temperature {
            params["inputNeutral"] = .vector(CIVector.init(x: CGFloat(temperature) + 6500, y: 0))
            params["inputTargetNeutral"] = .vector(CIVector.init(x: 6500, y: 0))
        }
        
        if params.isEmpty { return nil }
        
        return FilterDescriptor(
            name: "CITemperatureAndTint",
            params: params
        )
    }
    
    func makeCIColorMatrix(alpha: Double?) -> FilterDescriptor? {
        var params = [String: FilterDescriptor.Param]()
        
        if let alpha = alpha {
            params["inputRVector"] = .vector(CIVector(x: 1, y: 0, z: 0, w: 0))
            params["inputBVector"] = .vector(CIVector(x: 0, y: 0, z: 1, w: 0))
            params["inputAVector"] = .vector(CIVector(x: 0, y: 0, z: 0, w: CGFloat(alpha)))
            params["inputBiasVector"] = .vector(CIVector(x: 0, y: 0, z: 0, w: 0))
        }

        if params.isEmpty { return nil }
        
        return FilterDescriptor(
            name: "CIColorMatrix",
            params: params
        )
    }
    
    func makeCIGaussianBlur(blurRadius: Double?) -> FilterDescriptor? {
        var params = [String: FilterDescriptor.Param]()
        if let blurRadius = blurRadius {
            params["inputRadius"] = .number(NSNumber(value: blurRadius))
        }
        
        if params.isEmpty { return nil }
        
        return FilterDescriptor(
            name: "CIGaussianBlur",
            params: params
        )
    }
    
    func makeCIHighlightShadowAdjust(
        highlight: Double?,
        shadow: Double?
    ) -> FilterDescriptor? {
        if highlight == nil && shadow == nil {
            return nil
        }
        
        var params = [String: FilterDescriptor.Param]()
        
        if let highlight = highlight {
            params["inputHighlightAmount"] = .number(NSNumber(value: 1 - highlight))
        }
        
        if let shadow = shadow {
            params["inputShadowAmount"] = .number(NSNumber(value: shadow))
        }
        
        if params.isEmpty { return nil }
        
        return FilterDescriptor(
            name: "CIHighlightShadowAdjust",
            params: params
        )
    }
    
    func makeCIColorControls(
        brightness: Double?,
        contrast: Double?,
        saturation: Double?
    ) -> FilterDescriptor? {
        if brightness == nil && contrast == nil && saturation == nil {
            return nil
        }
        
        var params = [String: FilterDescriptor.Param]()
        
        if let brightness = brightness {
            params["inputBrightness"] = .number(NSNumber(value: brightness))
        }
        
        if let contrast = contrast {
            params["inputContrast"] = .number(NSNumber(value: 1 + contrast))
        }
        
        if let saturation = saturation {
            params["inputSaturation"] = .number(NSNumber(value: 1 + saturation))
        }
        
        if params.isEmpty { return nil }
        
        return FilterDescriptor(
            name: "CIColorControls",
            params: params
        )
    }
}

// MARK: - Helpers
fileprivate enum RadiusCalculator {
    static func radius(value: Double, max: Double, imageExtent: CGRect) -> Double {
        let base = Double(sqrt(pow(imageExtent.width, 2) + pow(imageExtent.height, 2)))
        let c = base / 20
        return c * value / max
    }
}
