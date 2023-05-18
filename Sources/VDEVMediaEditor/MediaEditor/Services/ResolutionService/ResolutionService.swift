//
//  ResolutionService.swift
//  
//
//  Created by Vladislav Gushin on 18.05.2023.
//

import Foundation
import Combine
import AVKit

final class ResolutionService {
    var resolution: CurrentValueSubject<MediaResolution, Never> = .init(.fullHD)
    
    init(resolution: VDEVMediaResolution) {
        self.set(resolution: resolution)
    }
    
    func set(resolution: VDEVMediaResolution) {
        self.resolution.send(resolution.value)
    }
    
    func set(resolution: MediaResolution) {
        self.resolution.send(resolution)
    }
    
    func videoExportPreset() -> String {
        switch resolution.value {
        case .hd:
            return AVAssetExportPreset1280x720
        case .sd:
            return AVAssetExportPreset640x480
        default:
            return AVAssetExportPreset1920x1080
        }
    }
}
