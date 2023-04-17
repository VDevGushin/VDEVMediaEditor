//
//  Transform.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import CoreGraphics

struct Transform {
    let zIndex: Double
    let offset: CGSize
    let scale: Double
    let degrees: Double
    var blendingMode: BlendingMode

    var radians: CGFloat { degrees * (CGFloat.pi / 180) }
}
