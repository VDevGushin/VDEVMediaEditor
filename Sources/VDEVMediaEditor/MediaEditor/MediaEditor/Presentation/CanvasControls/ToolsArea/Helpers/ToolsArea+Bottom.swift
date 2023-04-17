//
//  ToolsArea+Bottom.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 09.04.2023.
//

import SwiftUI

extension View {
    func bottomTool() -> some View {
        self.modifier(BottomTools())
    }
}

private struct BottomTools: ViewModifier {
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            Spacer()
            content
        }
    }
}
