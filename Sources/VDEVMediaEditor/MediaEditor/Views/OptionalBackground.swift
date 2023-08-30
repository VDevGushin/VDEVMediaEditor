//
//  OptionalBackground.swift
//  
//
//  Created by Vladislav Gushin on 30.08.2023.
//

import SwiftUI

extension View {
    func background<BackView: View>(
        _ condition: Binding<Bool>,
        @ViewBuilder backView: () -> BackView
    ) -> some View {
        modifier(
            OptionalBackgroundMod(
                condition: condition,
                backView: backView
            )
        )
    }
    
    func background<BackView: View>(
        _ condition: Bool,
        @ViewBuilder backView: () -> BackView
    ) -> some View {
        modifier(
            OptionalBackgroundMod(
                condition: .constant(condition),
                backView: backView
            )
        )
    }
    
    func background<BackView: View>(
        condition: @escaping () -> Bool,
        @ViewBuilder backView: () -> BackView
    ) -> some View {
        modifier(
            OptionalBackgroundMod(
                condition: .constant(condition()),
                backView: backView
            )
        )
    }
}

private struct OptionalBackgroundMod<BackView: View>: ViewModifier {
    @Binding private var condition: Bool
    private let backView: BackView
   
    init(
        condition: Binding<Bool>,
        @ViewBuilder backView: () -> BackView
    ) {
        self._condition = condition
        self.backView = backView()
    }
    
    func body(content: Content) -> some View {
        content
            .background {
                if condition {
                    backView
                }
            }
    }
}
