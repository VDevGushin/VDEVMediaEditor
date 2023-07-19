//
//  ToolsArea+Right.swift
//  
//
//  Created by Vladislav Gushin on 21.04.2023.
//

import SwiftUI

extension View {
    func rightTool() -> some View {
        self.modifier(RightTools())
    }
}

private struct RightTools: ViewModifier {
    func body(content: Content) -> some View {
//        content
//            .frame(maxWidth: .infinity, alignment: .trailing)
        HStack(spacing: 0) {
            Spacer()
            content
        }
    }
}
