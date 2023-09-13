//
//  CombinerAsset.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import CoreImage
import AVFoundation

struct CombinerAsset {
    var body: Body
    var transform: Transform
    
    var zIndex: Double {
        transform.zIndex
    }
    
    init(
        body: Body,
        transform: Transform
    ) {
        self.body = body
        self.transform = transform
    }
}

extension CombinerAsset {
    struct ImageBody {
        var ciImage: CIImage
    }

    struct VideoBody {
        var asset: AVAsset
        var preferredVolume: Float
        var cycleMode: CycleMode
    }

    enum Body {
        case image(ImageBody)
        case video(VideoBody)

        var imageBody: ImageBody? {
            switch self {
            case .image(let body): return body
            default: return nil
            }
        }

        var videoBody: VideoBody? {
            switch self {
            case .video(let videoBody): return  videoBody
            default: return nil
            }
        }

        init(ciImage: CIImage) {
            self = .image(CombinerAsset.ImageBody(ciImage: ciImage))
        }

        init(
            asset: AVAsset,
            preferredVolume: Float,
            cycleMode: CycleMode
        ) {
            self = .video(CombinerAsset.VideoBody(asset: asset, preferredVolume: preferredVolume, cycleMode: cycleMode))
        }
    }
}
