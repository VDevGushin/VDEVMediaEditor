//
//  VideoMixer.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import Foundation
import AVFoundation
import Photos
import UIKit

typealias MixerThrowsCallback = () throws -> CombinerOutput

// Render one video from others
final class VideoMixer {
    @Injected private var resolution: ResolutionService
    
    enum MixerError: Error {
        case couldNotGenerateThumbnail
        case couldNotMakeExporter
    }
    
    private let renderSize: CGSize
    private let progressObserver: ProgressObserver?
    
    
    init(renderSize: CGSize,
         progressObserver: ProgressObserver? = nil) {
        self.renderSize = renderSize
        self.progressObserver = progressObserver
    }
    
    func composeVideo(data: [CombinerAsset], withAudio: Bool = true) async throws -> CombinerOutput {
        let mixComposition = AVMutableComposition()
        let audioMix = AVMutableAudioMix()
        
        let sortedData = data.sorted { $0.transform.zIndex < $1.transform.zIndex }
        
        let videoData: [CombinerAsset.VideoBody] = sortedData
            .compactMap { $0.body.videoBody }
        
        // Вычисляем видео элементы по косвенным признакам
        // В ассете есть видео > 1x1px и длительность видео > 0.1
        // Вторым условием отметаем видосы, которые сделаны из фоток
        let videoElements = videoData
            .filter { $0.asset.hasValidVideo && $0.asset.duration.seconds > 0.1 }
            .map { $0.asset }
        let shortestVideoDuration = videoElements.min { $0.duration < $1.duration }?.duration ?? .zero
        let longestVideoDuration = videoElements.max { $0.duration < $1.duration }?.duration ?? .zero
        
        let audioElements = videoData
            .filter { $0.asset.isAudioOnly && $0.asset.duration.seconds > 0.1 }
            .map { $0.asset }
        
        let shortestAudioDuration: CMTime
        let longestAudioDuration: CMTime
        
        if withAudio {
            shortestAudioDuration = audioElements.min { $0.duration < $1.duration }?.duration ?? shortestVideoDuration
            longestAudioDuration = audioElements.max { $0.duration < $1.duration }?.duration ?? longestVideoDuration
        } else {
            shortestAudioDuration = shortestVideoDuration
            longestAudioDuration = longestVideoDuration
        }
        
        var layerInstructions = [VideoCompositorWithImageInstruction.LayerInstruction]()
        
        progressObserver?.setMessage(value: "Подготовка слоев для рендера видео...")
        
        try sortedData.forEach { element in
            try autoreleasepool {
                switch element.body {
                case .video(let videoBody):
                    if videoBody.asset.hasValidVideo,
                       let firstTrack = videoBody.asset.tracks(withMediaType: .video).first {
                        let track = mixComposition.addMutableTrack(withMediaType: .video,
                                                                   preferredTrackID: kCMPersistentTrackID_Invalid)!
                        try track.insert(
                            track: firstTrack,
                            from: videoBody.asset,
                            withCycleMode: videoBody.cycleMode,
                            mixInfo: .init(longestVideoDuration: longestVideoDuration,
                                           shortestVideoDuration: shortestVideoDuration,
                                           longestAudioDuration: longestAudioDuration,
                                           shortestAudioDuration: shortestAudioDuration)
                        )
                        track.preferredTransform = firstTrack.preferredTransform
                        
                        let instruction = VideoCompositorWithImageInstruction.LayerInstruction(
                            assetTrack: track,
                            transform: element.transform
                        )
                        
                        layerInstructions.append(instruction)
                    }
                    
                    if withAudio {
                        if let firstAudioTrack = videoBody.asset.tracks(withMediaType: .audio).first {
                            let audioTrack = mixComposition.addMutableTrack(withMediaType: .audio,
                                                                            preferredTrackID: kCMPersistentTrackID_Invalid)!
                            
                            try? audioTrack.insert(
                                track: firstAudioTrack,
                                from: videoBody.asset,
                                withCycleMode: videoBody.cycleMode,
                                mixInfo: .init(longestVideoDuration: longestVideoDuration,
                                               shortestVideoDuration: shortestVideoDuration,
                                               longestAudioDuration: longestAudioDuration,
                                               shortestAudioDuration: shortestAudioDuration)
                                
                            )
                            
                            let trackMix = AVMutableAudioMixInputParameters(track: audioTrack)
                            trackMix.setVolume(videoBody.preferredVolume, at: .zero)
                            audioMix.inputParameters.append(trackMix)
                        }
                    }
                case .image(let imageBody):
                    let image = imageBody.ciImage
                
                    let instruction = VideoCompositorWithImageInstruction.LayerInstruction(
                        ciImage: image,
                        transform: element.transform
                    )
                    
                    layerInstructions.append(instruction)
                }
            }
        }
        
        let mainInstruction = VideoCompositorWithImageInstruction()
        let timeRange = videoData.reduce(CMTime.zero) { partialResult, elem in
            return partialResult + elem.asset.duration
        }
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: timeRange)
        mainInstruction.layerInstructions = layerInstructions
        mainInstruction.canvasSize = renderSize
        
        let mainComposition = AVMutableVideoComposition()
        mainComposition.renderSize = renderSize
        mainComposition.customVideoCompositorClass = VideoCompositorWithImage.self
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        let videoName = UUID().uuidString
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(videoName)
            .appendingPathExtension("mp4")
        
        try? FileManager.default.removeItem(at: url)
        
        let presetName = resolution.videoExportPreset()
        guard let exportSession = AVAssetExportSession(asset: mixComposition, presetName: presetName) else {
            throw MixerError.couldNotMakeExporter
        }
        
        exportSession.audioMix = audioMix
        exportSession.outputURL = url
        exportSession.outputFileType = .mp4
        exportSession.shouldOptimizeForNetworkUse = false
        exportSession.videoComposition = mainComposition
        exportSession.fileLengthLimit =  10 * 100000 * 10 // 10MB
        
        progressObserver?.addProgress(title: "Генерация видео...")
        
        try await withCheckedThrowingContinuation { c in
            exportSession.exportAsynchronously() { [weak exportSession] in
                if let error = exportSession?.error {
                    c.resume(throwing: error)
                    return
                }
                c.resume(returning: ())
            }
        } as Void
        
        return try await MainActor.run {
            let thumbUrl = try VideoMixer.generateThumbnail(videoUrl: url, videoName: videoName)
            Log.d("Resutl video URL: \(url)")
            return CombinerOutput(cover: thumbUrl, url: url, aspect: renderSize.width / renderSize.height)
        }
    }
    
    private static func generateThumbnail(videoUrl: URL, videoName: String) throws -> URL {
        let asset = AVURLAsset(url: videoUrl)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
       /// imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: .zero, actualTime: nil)
        
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("\(videoName)thumbnail")
            .appendingPathExtension("jpeg")
        
        let uiImage = UIImage(cgImage: cgImage)
        try uiImage.jpegData(compressionQuality: 1.0)!.write(to: url, options: .atomic)
        return url
    }
}
