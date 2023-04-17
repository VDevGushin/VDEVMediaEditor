//
//  CGRect+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 09.02.2023.
//

import Foundation
import UIKit

extension CGRect {
    func getScale(for child: CGRect) -> CGFloat {
        let scale: CGFloat

        if child.width >= child.height {
            scale = child.height / self.height
        } else {
            scale = child.width / self.width
        }

        return scale
    }

    func getOffset(for child: CGRect) -> CGSize {
        let oX0 = self.midX
        let oY0 = self.midY
        let oX1 = child.midX
        let oY1 = child.midY
        return .init(width: oX1 - oX0, height: oY1 - oY0 )
    }
}

extension CGRect {
    static func *(left: CGRect, right: CGFloat) -> CGRect {
        CGRect(origin: left.origin * right, size: left.size * right)
    }

    static func / (left: CGRect, right: CGFloat) -> CGRect {
        CGRect(origin: left.origin / right, size: left.size / right)
    }
}
