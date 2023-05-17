//
//  AVExt.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 02.02.2023.
//

import AVFoundation
import SwiftUI
import UIKit

struct AVAssetConfig  {
    let resolution: CGSize
    let aspectRatio: Double
    let duration: CGFloat

    init?(resolution: CGSize?, aspectRatio: Double?, duration: CMTime?) {
        guard let resolution = resolution,
              let aspectRatio = aspectRatio,
              let duration = duration else {
            return nil
        }

        self.resolution = resolution
        self.aspectRatio = aspectRatio
        self.duration = CMTimeGetSeconds(duration)
    }
}

extension AVAsset {
    @MainActor
    func getRatio(_ completion: @escaping (CGFloat?) -> Void) {
        loadTracks(withMediaType: .video) { tracks, _ in
            guard let firstTrack = tracks?.first else {
                return completion(nil)
            }
            completion(firstTrack.aspectRatio)
        }
    }
    
    func getFirstTrack() async -> AVAssetTrack? {
        let tracks = try? await self.loadTracks(withMediaType: .video)
        return tracks?.first
    }

    func getSize() async -> CGSize? { await getFirstTrack()?.resolution }

    func getConfig() async -> AVAssetConfig? {
        let track = await getFirstTrack()

        let resolution = track?.resolution
        let aspectRatio = track?.aspectRatio

        let duration = try? await self.load(.duration)
        
        return .init(resolution: resolution, aspectRatio: aspectRatio, duration: duration)
    }

    var hasValidVideo: Bool {
        guard let firstTrack = tracks(withMediaType: .video).first else {
            return false
        }
        
        return firstTrack.naturalSize.width > 1 && firstTrack.naturalSize.height > 1
    }

    var isAudioOnly: Bool {
        return tracks(withMediaType: .audio).first != nil && !hasValidVideo
    }
}

enum VideoOrientation: String {
    enum Simple: String {
        case portrait
        case landscape
        case other
    }

    case up = "up"
    case down = "down"
    case left = "left"
    case right = "right"
    case other = "other"

    var simplified: Simple {
        switch self {
        case .up, .down: return .portrait
        case .left, .right: return .landscape
        case .other: return .other
        }
    }
}
