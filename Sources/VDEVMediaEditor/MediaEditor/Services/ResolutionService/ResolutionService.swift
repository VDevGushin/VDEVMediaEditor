//
//  ResolutionService.swift
//  
//
//  Created by Vladislav Gushin on 18.05.2023.
//

import Foundation
import Combine
import AVKit

// Сервис для выбора разрешения результата

final class ResolutionService {
    var resolution: CurrentValueSubject<MediaResolution, Never> = .init(.fullHD)
    var value: MediaResolution = .fullHD
    
    init(resolution: VDEVMediaResolution) {
        self.set(resolution: resolution)
        self.value = resolution.value
    }
    
    func set(resolution: VDEVMediaResolution) {
        self.resolution.send(resolution.value)
        self.value = resolution.value
    }
    
    func set(resolution: MediaResolution) {
        self.resolution.send(resolution)
        self.value = resolution
    }
    
    func videoExportPreset() -> String {
        switch value {
        case .hd:
            return AVAssetExportPreset1280x720
        case .sd:
            return AVAssetExportPreset640x480
        default:
            return AVAssetExportPreset1920x1080
        }
    }
}
