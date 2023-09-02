//
//  ToolAdjustmentsDetailVM.swift
//  
//
//  Created by Vladislav Gushin on 05.09.2023.
//

import UIKit

final class ToolAdjustmentsDetailVM: ObservableObject {
    @Injected var strings: VDEVMediaEditorStrings
    @Injected var images: VDEVImageConfig
    @Published var state: State = .first
    
    private(set) var allAdjustmentTools: [AdjustmentItemType] = []
    
    init() {
        allAdjustmentTools = [
            .highlight(title: strings.highlight, image: images.adjustments.highlights),
            .shadow(title: strings.shadow, image: images.adjustments.shadows),
            .saturation(title: strings.saturation, image: images.adjustments.saturation),
            .contrast(title: strings.contrast, image: images.adjustments.contrast),
            .blurRadius(title: strings.blurRadius, image: images.adjustments.blur),
            .temperature(title: strings.temperature, image: images.adjustments.temperature),
            .brightness(title: strings.brightness, image: images.adjustments.brightness),
            .alpha(title: strings.alpha, image: images.adjustments.mask),
            .sharpness(title: strings.sharpen, image: images.adjustments.sharpen)
        ]
    }
}

extension ToolAdjustmentsDetailVM {
    enum AdjustmentItemType {
        case highlight(title: String, image: UIImage)
        case shadow(title: String, image: UIImage)
        case saturation(title: String, image: UIImage)
        case contrast(title: String, image: UIImage)
        case blurRadius(title: String, image: UIImage)
        case temperature(title: String, image: UIImage)
        case brightness(title: String, image: UIImage)
        case sharpness(title: String, image: UIImage)
        case alpha(title: String, image: UIImage)
        
        var title: String {
            switch self {
            case .highlight(title: let title, image: _): return title
            case .shadow(title: let title, image: _): return title
            case .saturation(title: let title, image: _): return title
            case .contrast(title: let title, image: _): return title
            case .blurRadius(title: let title, image: _): return title
            case .temperature(title: let title, image: _): return title
            case .brightness(title: let title, image: _): return title
            case .sharpness(title: let title, image: _): return title
            case .alpha(title: let title, image: _): return title
            }
        }
        
        var image: UIImage {
            switch self {
            case .highlight(title: _, image: let image): return image
            case .shadow(title: _, image: let image): return image
            case .saturation(title: _, image: let image): return image
            case .sharpness(title: _, image: let image): return image
            case .contrast(title: _, image: let image): return image
            case .blurRadius(title: _, image: let image): return image
            case .temperature(title: _, image: let image): return image
            case .brightness(title: _, image: let image): return image
            case .alpha(title: _, image: let image): return image
            }
        }
    }
    
    enum State: Equatable {
        static func == (lhs: ToolAdjustmentsDetailVM.State, rhs: ToolAdjustmentsDetailVM.State) -> Bool {
            switch (lhs, rhs) {
            case (.first, .first): return true
            case (.detail, .detail): return true
            default: return false
            }
        }
        
        case first
        case detail(AdjustmentItemType)
        
        var showMenu: Bool {
            switch self {
            case .first: return true
            case .detail: return false
            }
        }
    }
}
