//
//  NeuralConfig.swift
//  
//
//  Created by Vladislav Gushin on 10.08.2023.
//

import Foundation

public struct NeuralConfig: Equatable, Hashable {
    public static func == (lhs: NeuralConfig, rhs: NeuralConfig) -> Bool {
        lhs.stepID == rhs.stepID
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(stepID)
    }
    
    let stepID: String
    let minPixels: Int
    let maxPixels: Int
    let allowedDimensions: [AllowedDimension]
    let dimensionsMultipleOf: Int
    
    public init(
        stepID: String,
        minPixels: Int,
        maxPixels: Int,
        allowedDimensions: [AllowedDimension],
        dimensionsMultipleOf: Int
    ) {
        self.minPixels = minPixels
        self.maxPixels = maxPixels
        self.allowedDimensions = allowedDimensions
        self.dimensionsMultipleOf = dimensionsMultipleOf
        self.stepID = stepID
    }
}

public extension NeuralConfig {
    struct AllowedDimension {
        let width: Int
        let height: Int
        
        public init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
    }
}
