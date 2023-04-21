//
//  ToolsArea+Left.swift
//  
//
//  Created by Vladislav Gushin on 21.04.2023.
//

import SwiftUI

extension View {
    func leftTool() -> some View {
        self.modifier(LeftTools())
    }
}

private struct LeftTools: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            content
            Spacer()
        }
    }
}

