//
//  AVMutableCompositionTrack.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import AVFoundation
import Foundation

extension AVMutableCompositionTrack {
    struct MixInfo {
        let longestVideoDuration: CMTime
        let shortestVideoDuration: CMTime
        let longestAudioDuration: CMTime
        let shortestAudioDuration: CMTime
    }

    func insert(track: AVAssetTrack,
                from asset: AVAsset,
                withCycleMode cycleMode: CycleMode,
                mixInfo: MixInfo) throws {
        
        func cycle(durationToFitIn: CMTime) throws {
            let repeatTimes = durationToFitIn.seconds / asset.duration.seconds

            for repeatIteration in (0..<Int(repeatTimes.rounded(.awayFromZero))) {
                let insertionTime = CMTime(seconds: Double(repeatIteration) * asset.duration.seconds,
                                           preferredTimescale: asset.duration.timescale)
                let secondsInLoopLast = durationToFitIn.seconds - (asset.duration.seconds * Double(repeatIteration))
                let chunkDuration = CMTime(seconds: min(secondsInLoopLast, asset.duration.seconds),
                                           preferredTimescale: asset.duration.timescale)
                let chunkRange = CMTimeRange(start: .zero, duration: chunkDuration)
                try insertTimeRange(chunkRange,
                                    of: track,
                                    at: insertionTime)
            }
        }

        switch cycleMode {
        case .none:
            try insertTimeRange(.init(start: .zero, duration: asset.duration), of: track, at: .zero)
        case .loopToLongestVideo, .loopToShortestVideo:
            let durationToFitIn = cycleMode == .loopToLongestVideo ? mixInfo.longestVideoDuration : mixInfo.shortestVideoDuration
            try cycle(durationToFitIn: durationToFitIn)
        case .loopToLongestAudio, .loopToShortestAudio:
            let durationToFitIn = cycleMode == .loopToLongestAudio ? mixInfo.longestAudioDuration : mixInfo.shortestAudioDuration
            try cycle(durationToFitIn: durationToFitIn)
        }
    }
}
