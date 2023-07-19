//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 21.04.2023.
//

import SwiftUI

extension View {
    func topTool() -> some View {
        self.modifier(TopTools())
    }
}

private struct TopTools: ViewModifier {
    func body(content: Content) -> some View {
//        content
//            .frame(maxHeight: .infinity, alignment: .top)
        VStack(spacing: 0) {
            content
            Spacer()
        }
    }
}
