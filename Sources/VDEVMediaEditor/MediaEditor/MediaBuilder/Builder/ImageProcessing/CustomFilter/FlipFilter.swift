//
//  FlipFilter.swift
//  
//
//  Created by Vladislav Gushin on 26.09.2023.
//

import UIKit

// MARK: - Input
public enum FlipType {
    case vertical
    case horizontal
    
    var inputKey: String {
        switch self {
        case .vertical:
            return "inputFlipVertical"
        case .horizontal:
            return "inputFlipHorizontal"
        }
    }
}

public struct FlipFilterInput {
    let value: Bool = true
    let flipType: FlipType
    init?(
        value: Bool,
        flipType: FlipType
    ) {
        if value == false { return nil }
        self.flipType = flipType
    }
}

// MARK: - Processing filter
public struct FlipFilter {
    private let filterDescriptor: FilterDescriptor
    
    public init?(_ descriptor: FilterDescriptor) {
        guard descriptor.isFlip else { return nil }
        self.filterDescriptor = descriptor
    }
    
    func execute(_ image: CIImage) -> CIImage {
        guard let params = filterDescriptor.params else {
            return image
        }
        
        var imageForFlip = image
        let extent = image.extent
        
        for (_ , param) in params {
            switch param {
            case .flip(let flipType):
                switch flipType {
                case .vertical:
                    imageForFlip = imageForFlip
                        .transformed(by: CGAffineTransformMakeScale(1, -1))
                    imageForFlip = imageForFlip
                        .transformed(by: CGAffineTransformMakeTranslation(0, extent.size.height))
                case .horizontal:
                    imageForFlip = imageForFlip
                        .transformed(by: CGAffineTransformMakeScale(-1, 1))
                    imageForFlip = imageForFlip
                        .transformed(by: CGAffineTransformMakeTranslation(extent.size.width, 0))
                }
            default: continue
            }
        }
        return imageForFlip
    }
}
