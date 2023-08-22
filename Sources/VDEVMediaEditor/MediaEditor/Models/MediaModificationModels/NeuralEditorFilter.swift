//
//  NeuralEditorFilter.swift
//  
//
//  Created by Vladislav Gushin on 22.08.2023.
//

import Foundation
import SwiftUI

// FOR UI
extension NeuralEditorFilter: GridToolItem {
    var coverUrl: URL? { cover }
    static var cellAspect: CGFloat { 16/9 }
    static var contentMode: UIView.ContentMode { .scaleAspectFill }
}

// Public model
public struct NeuralEditorFilter: Equatable {
    var id: String
    var name: String
    var cover: URL?
    var steps: [Step]
    
    public init(id: String,
                name: String,
                cover: URL?,
                steps: [Step]) {
        self.id = id
        self.name = name
        self.cover = cover
        self.steps = steps
    }

    public static func == (lhs: NeuralEditorFilter,
                           rhs: NeuralEditorFilter) -> Bool { lhs.id == rhs.id }
    
    public struct Step {
        var id: String
        var filterID: String
        var neuralConfig: NeuralConfig
        var settings: StepSettings?
        var url: URL?
        
        public init?(
            id: String?,
            filterID: String?,
            url: URL?,
            settings: StepSettings? = nil,
            neuralConfig: NeuralConfig?
        ) {
            guard let id,
                  let filterID,
                  let neuralConfig else {
                return nil
            }
            self.id = id
            self.filterID = filterID
            self.url = url
            self.settings = settings
            self.neuralConfig = neuralConfig
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

extension Sequence where Element == NeuralEditorFilter.Step {
    func makeFilterDescriptors(id: String? = nil) -> [FilterDescriptor] {
        compactMap { FilterDescriptor(step: $0, id: id) }
    }
}
