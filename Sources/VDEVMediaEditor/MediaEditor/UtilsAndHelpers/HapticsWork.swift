//
//  HapticsWork.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 28.03.2023.
//

import SwiftUI

func makeHaptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

extension View {
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
