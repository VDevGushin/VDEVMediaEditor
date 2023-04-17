//
//  EditorFilter.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.02.2023.
//

import Foundation
import SwiftUI

public extension EditorFilter {
    
    @dynamicMemberLookup
    class StepSettings {
        private(set) public var jsonValue: [String: Any]
        
        public init(jsonValue value: Any) {
            self.jsonValue = (value as? [String: Any]) ?? [:]
        }
        
        public subscript(dynamicMember member: String) -> StepSettings? {
            guard let value = jsonValue[member] else { return nil }
            return .init(jsonValue: value)
        }
        
        public subscript<T>(dynamicMember member: String) -> T? {
            return jsonValue[member] as? T
        }
    }
}


public struct EditorFilter: Equatable {
    public struct Step {
        var type: String
        var url: URL?
        var settings: StepSettings?
    }
    var id: String
    var name: String
    var cover: URL?
    var steps: [Step]
    
    public init(id: String, name: String, cover: URL? = nil, steps: [Step]) {
        self.id = id
        self.name = name
        self.cover = cover
        self.steps = steps
    }

    public static func == (lhs: EditorFilter, rhs: EditorFilter) -> Bool {
        lhs.id == rhs.id
    }
}

extension FilterDescriptor {
    convenience init?(step: EditorFilter.Step) {
        guard let url = step.url else { return nil }
        
        switch step.type {
        case "lut":
            let colorSpaceString = "sRGB"
            guard let colorSpace = CGColorSpace.fromCFIDString(colorSpaceString) else {
                return nil
            }

            self.init(
                name: "CIColorCubeWithColorSpace",
                params: [
                    "inputCubeDimension": .number(64),
                    "inputCubeData": .init(dataURL: url),
                    "inputColorSpace": .colorSpaceString(colorSpace, colorSpaceString)
                ]
            )
        case "mask":
            self.init(
                name: "CIBlendWithMask",
                params: [
                    "inputMaskImage": .init(imageURL: url, contentMode: .scaleAspectFit)
                ]
            )
        case "texture":
            let blendMode = step.settings?.blendMode ?? "CISourceOverCompositing"
            let contentModeId = step.settings?.contentMode ?? 0
            let contentMode = UIView.ContentMode(rawValue: contentModeId) ?? .scaleToFill

            self.init(
                name: blendMode,
                params: [
                    "inputImage": .init(imageURL: url, contentMode: contentMode)
                ],
                customImageTargetKey: "inputBackgroundImage"
            )
            
        default: return nil
        }
    }
}

extension Array where Element == EditorFilter.Step {
    func makeFilterDescriptors() -> [FilterDescriptor] {
        compactMap { FilterDescriptor(step: $0) }
    }
}

extension EditorFilter: GridToolItem {
    var coverUrl: URL? { cover }

    static var cellAspect: CGFloat { 16/9 }
    static var contentMode: UIView.ContentMode { .scaleAspectFill }
}

extension Array where Element ==  EditorFilter.Step {
    var noMask: [Element] {
        self.filter { $0.type != "mask" }
    }

    var mask: [Element] {
        self.filter { $0.type == "mask" }
    }
}

extension Array where Element == EditorFilter {
    var maskImageURL: URL? { onlyMask.flatMap { $0.steps }.first?.url }
    
    var noMask: [Element] {
        var result: [EditorFilter] = []

        for i in 0..<self.count {
            let steps = self[i].steps.noMask

            if !steps.isEmpty {
                var filter = self[i]
                filter.steps = steps
                result.append(filter)
            }
        }

        return result
    }

    var onlyMask: [Element] {
        var result: [EditorFilter] = []

        for i in 0..<self.count {
            let steps = self[i].steps.mask

            if !steps.isEmpty {
                var filter = self[i]
                filter.steps = steps
                result.append(filter)
            }
        }

        return result
    }
}
