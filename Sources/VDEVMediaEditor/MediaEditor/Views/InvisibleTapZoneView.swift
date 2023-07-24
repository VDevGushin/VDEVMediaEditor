//
//  InvisibleTapZoneView.swift
//  
//
//  Created by Vladislav Gushin on 26.04.2023.
//

import SwiftUI

struct InvisibleTapZoneView: View {
    private let tapCount: Int
    private let action: (() -> Void)?
    
    init(tapCount: Int = 1, action: (() -> Void)? = nil) {
        self.tapCount = tapCount
        self.action = action
    }
    
    var body: some View {
        Color.black
            .opacity(0.001)
            .onTapGesture(count: tapCount) {
                makeHaptics()
                action?()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
