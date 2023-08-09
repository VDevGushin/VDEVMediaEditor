//
//  EditorFilter.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.02.2023.
//

import Foundation
import SwiftUI

// FOR UI
extension EditorFilter: GridToolItem {
    var coverUrl: URL? { cover }
    static var cellAspect: CGFloat { 16/9 }
    static var contentMode: UIView.ContentMode { .scaleAspectFill }
}

// Public model
public struct EditorFilter: Equatable {
    var id: String
    var name: String
    var cover: URL?
    var steps: [Step]
    
    public init(id: String,
                name: String,
                cover: URL? = nil,
                steps: [Step]) {
        self.id = id
        self.name = name
        self.cover = cover
        self.steps = steps
    }

    public static func == (lhs: EditorFilter,
                           rhs: EditorFilter) -> Bool { lhs.id == rhs.id }
    
    public struct Step {
        var type: StepType
        var url: URL?
        var id: String?
        var settings: StepSettings? // RAW JSON
        var neuralConfig: NeuralConfig?
        
        public init(
            type: StepType,
            id: String? = nil,
            url: URL? = nil,
            settings: StepSettings? = nil,
            neuralConfig: NeuralConfig? = nil
        ) {
            self.id = id
            self.type = type
            self.url = url
            self.settings = settings
            self.neuralConfig = neuralConfig
        }
        
        public enum StepType: String {
            case lut
            case mask
            case texture
            case neural
            
            public init?(value: String) {
                guard let value = StepType(rawValue: value) else { return nil }
                self = value
            }
        }
    }
    
    @dynamicMemberLookup
    public final class StepSettings {
        private(set) public var rawValue: [String: Any]
        
        public init(jsonValue value: Any) {
            self.rawValue = (value as? [String: Any]) ?? [:]
        }
        
        public subscript(dynamicMember member: String) -> StepSettings? {
            guard let value = rawValue[member] else { return nil }
            return .init(jsonValue: value)
        }
        
        public subscript<T>(dynamicMember member: String) -> T? {
            return rawValue[member] as? T
        }
    }
}

extension Sequence where Element == EditorFilter.Step {
    func makeFilterDescriptors(id: String? = nil) -> [FilterDescriptor] {
        compactMap { FilterDescriptor(step: $0, id: id) }
    }
}

// MARK: - MASK Filter
extension Sequence where Element ==  EditorFilter.Step {
    var noMask: [Element] { self.filter { $0.type != .mask } }
    var mask: [Element] { self.filter { $0.type == .mask } }
    var neural: [Element] { self.filter { $0.type == .neural } }
}

extension Array where Element == EditorFilter {
    var maskImageURL: URL? { onlyMask.flatMap { $0.steps }.first?.url }
    
    var hasNeural: Bool { contains { !$0.steps.neural.isEmpty } }
    
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
