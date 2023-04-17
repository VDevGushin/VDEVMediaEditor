//
//  ToolsManagementTransitions.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//

import SwiftUI

extension AnyTransition {
    static var leadingTransition: AnyTransition {
        .asymmetric(insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity))
    }
    
    static var trailingTransition: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing),
                                 removal: .move(edge: .trailing)).combined(with: .opacity)
    }
    
    static var bottomTransition: AnyTransition {
        .asymmetric(insertion: .move(edge: .bottom),
                                 removal: .move(edge: .bottom)).combined(with: .opacity)
    }
}
