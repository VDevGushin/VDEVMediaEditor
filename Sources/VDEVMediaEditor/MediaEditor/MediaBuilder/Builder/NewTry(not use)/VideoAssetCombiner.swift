//
//  VideoAssetCombiner.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 24.03.2023.
//

import UIKit
import Foundation
import AVFoundation
import Photos

extension VideoAssetCombiner {
    enum MixerError: Error {
        case couldNotGenerateThumbnail
        case couldNotMakeExporter
    }
}

final class VideoAssetCombiner {
    private let layers: [CanvasItemModel]
    private let canvasSize: CGSize
    private let scaleFactor: CGFloat
    private let canvasNativeSize: CGSize
    private let bgColor: UIColor
    
    init(layers: [CanvasItemModel], canvasSize: CGSize, scaleFactor: CGFloat, backgroundColor: UIColor) {
        self.layers = layers
        self.canvasSize = canvasSize
        self.scaleFactor = scaleFactor
        self.bgColor = backgroundColor
        self.canvasNativeSize = canvasSize * scaleFactor
    }
    
    func execute() async throws -> CombinerOutput {
        let canvasNativeSize = canvasSize * scaleFactor
    
        var layerInstructions = [VideoCompositorWithImageInstruction.LayerInstruction]()
        let mixComposition = AVMutableComposition()
        
        let bgImage = CIImage(color: CIColor(color: bgColor))
            .cropped(to: CGRect(origin: .zero, size: canvasNativeSize))
        let bg = CombinerAsset(
            body: .init(ciImage: bgImage),
            transform: Transform(zIndex: 0.0,
                                 offset: .zero,
                                 scale: 1,
                                 degrees: 0,
                                 blendingMode: .sourceOver)
        )
        
        if let bgIns = try await composeVideo(asset: bg, mixComposition: mixComposition) {
            layerInstructions.append(bgIns)
        }
        
        var zIndex = 1
        for i in 0..<layers.count {
            let element = layers[i]
            zIndex += i
            
            if let imageAsset = await element.makeImageAsset(
                canvasNativeSize: canvasNativeSize,
                scaleFactor: scaleFactor,
                layerIndex: zIndex
            ) {
                if let imageIns = try await composeVideo(asset: imageAsset, mixComposition: mixComposition) {
                    layerInstructions.append(imageIns)
                }
            }
            
            if let videoAsset = await element.makeVideoAsset(
                canvasNativeSize: canvasNativeSize,
                scaleFactor: scaleFactor,
                layerIndex: zIndex
            ) {
                if let videoIns = try await composeVideo(asset: videoAsset, mixComposition: mixComposition) {
                    layerInstructions.append(videoIns)
                }
            }
        
            
            if let labelsAsset = await element.makeLabelAsset(
                canvasNativeSize: canvasNativeSize,
                scaleFactor: scaleFactor,
                layerIndex: zIndex
            ) {
                if let labelIns = try await composeVideo(asset: labelsAsset, mixComposition: mixComposition) {
                    layerInstructions.append(labelIns)
                }
            }
        }
   
        let mainInstruction = VideoCompositorWithImageInstruction()
        let timeRange = getVideoData().reduce(CMTime.zero) { partialResult, asset in
            return partialResult + asset.duration
        }
        mainInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: timeRange)
        mainInstruction.layerInstructions = layerInstructions
        mainInstruction.canvasSize = canvasSize
        
        let mainComposition = AVMutableVideoComposition()
        mainComposition.renderSize = canvasNativeSize
        mainComposition.customVideoCompositorClass = VideoCompositorWithImage.self
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        let videoName = UUID().uuidString
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(videoName)
            .appendingPathExtension("MOV")
        
        try? FileManager.default.removeItem(at: url)
        
        guard let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else {
            throw MixerError.couldNotMakeExporter
        }
        
        exportSession.outputURL = url
        exportSession.outputFileType = .mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = mainComposition
        exportSession.fileLengthLimit =  10 * 100000 * 10 // 10MB
        
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
            let thumbUrl = try Self.generateThumbnail(videoUrl: url)
            Log.d("Resutl video URL: \(url)")
            return CombinerOutput(cover: thumbUrl, url: url)
        }
    }
    
    func composeVideo(asset: CombinerAsset, mixComposition: AVMutableComposition) async throws -> VideoCompositorWithImageInstruction.LayerInstruction? {
        
        let (shortestVideoDuration, longestVideoDuration) = getVideoDuration()
        let shortestAudioDuration = shortestVideoDuration
        let longestAudioDuration = longestVideoDuration
        
        switch asset.body {
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
                
                return VideoCompositorWithImageInstruction.LayerInstruction(
                    assetTrack: track,
                    transform: asset.transform
                )
            }
            
            return nil
        case .image(let imageBody):
            return VideoCompositorWithImageInstruction.LayerInstruction(
                ciImage: imageBody.ciImage,
                transform: asset.transform
            )
        }
    }
    
    func composeVideo(data: [CombinerAsset]) async throws -> CombinerOutput {
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
        let shortestAudioDuration = audioElements.min { $0.duration < $1.duration }?.duration ?? shortestVideoDuration
        let longestAudioDuration = audioElements.max { $0.duration < $1.duration }?.duration ?? longestVideoDuration
        
        var layerInstructions = [VideoCompositorWithImageInstruction.LayerInstruction]()
        
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
                case .image(let imageBody):
                    let instruction = VideoCompositorWithImageInstruction.LayerInstruction(
                        ciImage: imageBody.ciImage,
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
        mainInstruction.canvasSize = canvasSize
        
        let mainComposition = AVMutableVideoComposition()
        mainComposition.renderSize = canvasNativeSize
        mainComposition.customVideoCompositorClass = VideoCompositorWithImage.self
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        
        let videoName = UUID().uuidString
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(videoName)
            .appendingPathExtension("MOV")
        
        try? FileManager.default.removeItem(at: url)
        
        guard let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality) else {
            throw MixerError.couldNotMakeExporter
        }
        exportSession.audioMix = audioMix
        exportSession.outputURL = url
        exportSession.outputFileType = .mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = mainComposition
        exportSession.fileLengthLimit =  10 * 100000 * 10 // 10MB
        
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
            let thumbUrl = try Self.generateThumbnail(videoUrl: url)
            Log.d("Resutl video URL: \(url)")
            return CombinerOutput(cover: thumbUrl, url: url)
        }
    }
}

// MARK: - Make templates with images/videos/placeholders[image,video]
private extension VideoAssetCombiner {
    func makeTemplateAsset(element: CanvasItemModel,
                           scaleFactor: CGFloat,
                           layerIndex: Int) async -> CombinerAsset? {
        
        guard element.type == .template else { return nil }
        
        let item: CanvasTemplateModel = CanvasItemModel.toType(model: element)
        
        let layers = item.layerItems
        var zIndex = layerIndex
        
        var bufferImage: CIImage = CIImage(color: .clear)
        
        for i in 0..<layers.count {
            let element = layers[i]
            zIndex += i
            
            if let placeholderAsset = await element.makePlaceholderAsset(
                scaleFactor: scaleFactor,
                layerIndex: zIndex
            ) {
                bufferImage = combine(asset: placeholderAsset, bufferImage: bufferImage)
            }
            
            if let imageAsset = await element.makeTemplateImageAsset(
                scaleFactor: scaleFactor,
                layerIndex: zIndex
            ) {
                bufferImage = combine(asset: imageAsset, bufferImage: bufferImage)
            }
            
            if let labelsAsset = await element.makeTemplateLabelAsset(
                scaleFactor: scaleFactor,
                layerIndex: zIndex
            ) {
                bufferImage = combine(asset: labelsAsset, bufferImage: bufferImage)
            }
        }
        
        return CombinerAsset(
            body: .init(ciImage: bufferImage),
            transform: Transform(zIndex: Double(layerIndex),
                                 offset: .zero,
                                 scale: 1,
                                 degrees: 0,
                                 blendingMode: .sourceOver)
        )
    }
}

// MARK: Combine CIImage
private extension VideoAssetCombiner {
    func combine(asset: CombinerAsset, bufferImage: CIImage) -> CIImage {
        var resultImage: CIImage = bufferImage
        
        if let newCIImage = asset.body.imageBody?.ciImage {
            autoreleasepool {
                resultImage = newCIImage
                    .composited(with: resultImage,
                                canvasSize: canvasNativeSize,
                                transform: asset.transform)
            }
        }
        
        return resultImage.cropped(to: CGRect(origin: .zero, size: canvasNativeSize))
    }
}

private extension VideoAssetCombiner {
    func getVideoData() -> [AVAsset] {
        var videoElements: [AVAsset] = []
        
        for layerModel in layers {
            
            if layerModel.type == .video {
                let video: CanvasVideoModel = CanvasItemModel.toType(model: layerModel)
                let asset = AVAsset(url: video.videoURL)
                if asset.hasValidVideo && asset.duration.seconds > 0.1 {
                    videoElements.append(asset)
                }
            }
            
            if layerModel.type == .template {
                let template: CanvasTemplateModel = CanvasItemModel.toType(model: layerModel)
                for templateLayer in template.layerItems {
                    if templateLayer.type == .placeholder {
                        let placeholderModel: CanvasPlaceholderModel = CanvasItemModel.toType(model: templateLayer)
                        if let videoModel = placeholderModel.videoModel {
                            let asset = AVAsset(url: videoModel.videoURL)
                            if asset.hasValidVideo && asset.duration.seconds > 0.1 {
                                videoElements.append(asset)
                            }
                        }
                    }
                }
            }
        }
        return videoElements
    }
    
    func getVideoDuration() -> (CMTime, CMTime) {
        let videoElements = getVideoData()
        let shortestVideoDuration = videoElements.min { $0.duration < $1.duration }?.duration ?? .zero
        let longestVideoDuration = videoElements.max { $0.duration < $1.duration }?.duration ?? .zero
        
        return (shortestVideoDuration, longestVideoDuration)
    }
    
    private static func generateThumbnail(videoUrl: URL) throws -> URL {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        let cgImage = try imgGenerator.copyCGImage(at: .zero, actualTime: nil)
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent("thumbnail")
            .appendingPathExtension("jpeg")
        let uiImage = UIImage(cgImage: cgImage)
        try uiImage.jpegData(compressionQuality: 1.0)!.write(to: url, options: .atomic)
        return url
    }
}
