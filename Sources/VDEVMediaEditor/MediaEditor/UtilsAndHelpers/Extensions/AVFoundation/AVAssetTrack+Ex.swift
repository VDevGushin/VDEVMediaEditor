//
//  AVAssetTrack+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import AVFoundation

extension AVAssetTrack {
    var videoOrientation: VideoOrientation {
        let txf = preferredTransform
        let videoAngleInDegree = radiandsToDegrees(atan2(txf.b, txf.a))
        switch Int(videoAngleInDegree) {
        case 0:     return .right
        case 90:    return .up
        case 180:   return .left
        case -90:   return .down
        default:    return .other
        }
    }

    var aspectRatio: Double { Double(resolution.width / resolution.height) }

    var resolution: CGSize {
        let size = naturalSize.applying(preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}

fileprivate func radiandsToDegrees(_ radians: CGFloat) -> CGFloat {
    (radians * 180) / CGFloat.pi;
}
