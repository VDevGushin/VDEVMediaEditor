//
//  ToolsManagementTransitions.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//

import SwiftUI

private let moveSpeed: Double = 0.4
private let opacitySpeed: Double = 0.5

extension AnyTransition {
    static var leadingTransition: AnyTransition {
        .asymmetric(insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity))
        //.animation(.easeInOut(duration: moveSpeed))
    }
    
    static var trailingTransition: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing))
        .combined(with: .opacity)
        //.animation(.easeInOut(duration: moveSpeed))
    }
    
    static var bottomTransition: AnyTransition {
        .asymmetric(insertion: .move(edge: .bottom),
                    removal: .move(edge: .bottom))
        .combined(with: .opacity)
        //.animation(.easeInOut(duration: moveSpeed))
    }
    
    static func opacityTransition(withAnimation: Bool = true) -> AnyTransition {
        return withAnimation ? .opacity.animation(.easeInOut(duration: opacitySpeed)) : .opacity
    }
}
