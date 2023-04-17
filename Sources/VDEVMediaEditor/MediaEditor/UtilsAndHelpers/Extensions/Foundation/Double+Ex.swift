//
//  Double+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 07.02.2023.
//

import Foundation
import SwiftUI

enum RotateOrientation {
    case vertical
    case horizontal
    case no
}

extension Double {
    
    func makeAngle(withAdjustments: ((RotateOrientation) -> Void)? = nil) -> Angle {
        .degrees(self.makeAngle(withAdjustments: withAdjustments))
    }

    func makeAngle(withAdjustments: ((RotateOrientation) -> Void)? = nil) -> Double {
        let angle = self.clampAngle()


        if (87...93).contains(angle) && angle != 90 {
            withAdjustments?(.horizontal)
            return 90
        }

        if (177...183).contains(angle) && angle != 180 {
            withAdjustments?(.vertical)
            return 180
        }

        if (267...273).contains(angle) && angle != 270 {
            withAdjustments?(.horizontal)
            return 270
        }

        if ((357...360).contains(angle) || (0...1).contains(angle)) && angle != 0 {
            withAdjustments?(.vertical)
            return 0
        }

        withAdjustments?(.no)
        return self
    }


    func clampAngle() -> Double {
        var angle = self
        while angle < 0 {
            angle += 360
        }
        return angle.truncatingRemainder(dividingBy: 360)
    }
}
