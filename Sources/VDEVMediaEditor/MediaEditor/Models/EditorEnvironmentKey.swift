//
//  EditorEnvironmentKey.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 02.02.2023.
//

import SwiftUI

private struct GuideLinesColorEnvironmentKey: EnvironmentKey {
    static let defaultValue: Color = .purple
}

public extension EnvironmentValues {
    var guideLinesColor: Color {
        get {  self[GuideLinesColorEnvironmentKey.self] }
        set { self[GuideLinesColorEnvironmentKey.self] = newValue }
    }
}
