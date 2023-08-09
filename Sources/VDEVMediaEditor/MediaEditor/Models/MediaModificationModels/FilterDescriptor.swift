//
//  FilterDescriptor.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import UIKit
import CoreImage

public let NeuralFilterDescriptorName = "NeuralFilter"

public class FilterDescriptor: Codable, Hashable {
    public enum Param: Codable, Hashable {
     
        enum ParamErrors: Error { case unableToDecodeBase64StringToData }
        
        case number(NSNumber)
        case dataBase64(NSData)
        case dataURL(NSData, URL)
        case color(CIColor)
        case vector(CIVector)
        case image(CIImage, UIView.ContentMode?, URL)
        case colorSpaceString(CGColorSpace, String)
        case neural(NeuralConfig)
        case unsupported

        var valueForParams: Any {
            switch self {
            case .number(let number): return number
            case .dataBase64(let data): return data
            case .dataURL(let data, _): return data
            case .color(let color): return color
            case .vector(let vector): return vector
            case .image(let image, _, _): return image
            case .colorSpaceString(let colorSpace, _): return colorSpace
            case .unsupported: return NSNull()
            case .neural: return NSNull()
            }
        }

        enum CodingKeys: CodingKey {
            case type
            case value
            case contentMode
        }

        public init(dataURL: URL) {
            guard let data = SessionCache<NSData>.data(from: dataURL, storeCache: true, extractor: {
                guard let data = NSData(contentsOf: dataURL) else { return nil }
                return ParamDataPreprocessor.process(url: dataURL, data: data)
            }()) else {
                self = .unsupported
                return
            }
            self = .dataURL(data, dataURL)
        }

        public init(imageURL: URL, contentMode: UIView.ContentMode? = nil) {
            guard let image = AssetExtractionUtil.image(fromUrl: imageURL) else {
                self = .unsupported
                return
            }
            self = .image(image, contentMode, imageURL)
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let type = try container.decode(String.self, forKey: .type)
            switch type {
            case "number":
                let number = try container.decode(Double.self, forKey: .value)
                self = .number(NSNumber(value: number))
            case "data_base64":
                let base64DataString = try container.decode(String.self, forKey: .value)
                guard let data = NSData(base64Encoded: base64DataString, options: []) else {
                    self = .unsupported
                    return
                }
                self = .dataBase64(data)
            case "data_URL":
                let urlString = try container.decode(String.self, forKey: .value)
                guard let url = URL(w1d1URLString: urlString) else {
                    self = .unsupported
                    return
                }
                self.init(dataURL: url)
            case "color":
                let colorHexString = try container.decode(String.self, forKey: .value)
                let color = UIColor(hexString: colorHexString)
                self = .color(CIColor(color: color))
            case "vector":
                let values = try container.decode([CGFloat].self, forKey: .value)
                let vector = CIVector(values: values, count: values.count)
                self = .vector(vector)
            case "image_URL":
                let urlString = try container.decode(String.self, forKey: .value)
                guard let url = URL(w1d1URLString: urlString) else {
                    self = .unsupported
                    return
                }
                let contentMode: UIView.ContentMode?
                if let contentModeInt = try container.decodeIfPresent(Int.self, forKey: .contentMode),
                   let safeContentMode = UIView.ContentMode(rawValue: contentModeInt) {
                    contentMode = safeContentMode
                } else {
                    contentMode = nil
                }
                self.init(imageURL: url, contentMode: contentMode)
            case "color_space_string":
                let colorSpaceString = try container.decode(String.self, forKey: .value)
                guard let colorSpace = CGColorSpace.fromCFIDString(colorSpaceString) else {
                    self = .unsupported
                    return
                }
                self = .colorSpaceString(colorSpace, colorSpaceString)
            default:
                self = .unsupported
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .number(let number):
                try container.encode("number", forKey: .type)
                try container.encode(number.floatValue, forKey: .value)
            case .dataBase64(let data):
                try container.encode("data_base64", forKey: .type)
                try container.encode(data.base64EncodedString(options: []), forKey: .value)
            case .dataURL(_, let url):
                try container.encode("data_URL", forKey: .type)
                try container.encode(url.w1d1exportSafeString, forKey: .value)
            case .color(let color):
                let uiColor = UIColor(ciColor: color)
                try container.encode("color", forKey: .type)
                try container.encode(uiColor.hexString, forKey: .value)
            case .vector(let vector):
                var arr = [CGFloat]()
                for i in 0..<vector.count { arr.append(vector.value(at: i)) }
                try container.encode("vector", forKey: .type)
                try container.encode(arr , forKey: .value)
            case .image(_, let contentMode, let url):
                try container.encode("image_URL", forKey: .type)
                try container.encodeIfPresent(contentMode?.rawValue, forKey: .contentMode)
                try container.encode(url.w1d1exportSafeString, forKey: .value)
            case .colorSpaceString(_, let colorSpaceString):
                try container.encode("color_space_string", forKey: .type)
                try container.encode(colorSpaceString, forKey: .value)
            case .unsupported, .neural:
                try container.encode("unsupported", forKey: .type)
                try container.encodeNil(forKey: .value)
            }
        }
    }

    public var id: String?
    public var name: String
    public var params: [String: Param]?
    public var customImageTargetKey: String?
    
    var isNeural: Bool { name == NeuralFilterDescriptorName }

    public init(name: String,
                params: [String: Param]? = nil,
                id: String? = nil,
                customImageTargetKey: String? = nil) {
        self.id = id
        self.name = name
        self.params = params
        self.customImageTargetKey = customImageTargetKey
    }
    
    public static func == (lhs: FilterDescriptor, rhs: FilterDescriptor) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(params)
        hasher.combine(customImageTargetKey)
    }
}

public extension FilterDescriptor {
    convenience init?(step: EditorFilter.Step, id: String?) {
        switch step.type {
        case .lut:
            let colorSpaceString = "sRGB"
            guard let colorSpace = CGColorSpace.fromCFIDString(colorSpaceString),
                  let url = step.url else {
                return nil
            }
            self.init(
                name: "CIColorCubeWithColorSpace",
                params: [
                    "inputCubeDimension": .number(64),
                    "inputCubeData": .init(dataURL: url),
                    "inputColorSpace": .colorSpaceString(colorSpace, colorSpaceString)
                ],
                id: id
            )
        case .mask:
            guard let url = step.url else { return nil }
            self.init(
                name: "CIBlendWithMask",
                params: [
                    "inputMaskImage": .init(imageURL: url, contentMode: .scaleAspectFit)
                ],
                id: id
            )
        case .texture:
            guard let url = step.url else { return nil }
            let blendMode = step.settings?.blendMode ?? "CISourceOverCompositing"
            let contentModeId = step.settings?.contentMode ?? 0
            let contentMode = UIView.ContentMode(rawValue: contentModeId) ?? .scaleToFill
            
            self.init(
                name: blendMode,
                params: [
                    "inputImage": .init(imageURL: url, contentMode: contentMode)
                ],
                id: id,
                customImageTargetKey: "inputBackgroundImage"
            )
            
        case .neural:
            guard let neuralConfig = step.neuralConfig else { return nil }
            self.init(name: NeuralFilterDescriptorName,
                      params: [neuralConfig.stepID: .neural(neuralConfig)],
                      id: id)
        }
    }
}

extension Sequence where Element == FilterDescriptor {
    var notNeuralFilters: [Element] {
        self.filter { !$0.isNeural }
    }
    
    var neuralFilters: [Element] {
        self.filter { $0.isNeural }
    }
    
    var ciFilters: [CIFilter] {
        // not work with neuralFilters
        self.compactMap { CIFilter(name: $0.name) }
    }
}

private final class ParamDataPreprocessor {
    static func process(url: URL, data: NSData) -> NSData {
        if (data as Data).mimetype.type == .image ||
            ["png", "jpg", "jpeg"].contains(url.pathExtension.lowercased()),
           let lut = ImageFileLUT(imageData: data as Data) {
            return lut.generateLUTData()
        }
        if url.pathExtension.lowercased() == "cube",
           let lut = CubeLUT(cubeFileData: data) {
            return lut.generateLUTData()
        }
        return data
    }
}
