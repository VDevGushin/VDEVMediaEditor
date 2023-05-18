//
//  VDEVMediaResolution.swift
//  
//
//  Created by Vladislav Gushin on 24.04.2023.
//

import Foundation
import AVKit

public enum VDEVMediaResolution {
    case ultraHD8k
    case ultraHD4k
    case fullHD
    case hd
    case sd

    var value: MediaResolution {
        switch self {
        case .ultraHD8k: return .ultraHD8k
        case .ultraHD4k: return .ultraHD4k
        case .fullHD: return .fullHD
        case .hd: return .hd
        case .sd: return .sd
        }
    }
    
    var videoExportPreset: String {
        switch self {
        case .hd:
            return AVAssetExportPreset1280x720
        case .sd:
            return AVAssetExportPreset640x480
        default:
            return AVAssetExportPreset1920x1080
        }
    }
}
