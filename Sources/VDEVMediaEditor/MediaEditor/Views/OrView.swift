//
//  OrView.swift
//  
//
//  Created by Vladislav Gushin on 19.08.2023.
//

import SwiftUI

struct OrView<V1: View, V2: View>: View {
    private let _view1: V1
    private let _view2: V2
    private let condition: Bool
    
    init(_ condition: Bool,
         @ViewBuilder firstView: () -> V1,
         @ViewBuilder secondView: () -> V2
    ) {
        self.condition = condition
        self._view1 = firstView()
        self._view2 = secondView()
    }
    
    var body: some View {
        if condition {
            _view1
        } else {
            _view2
        }
    }
}
