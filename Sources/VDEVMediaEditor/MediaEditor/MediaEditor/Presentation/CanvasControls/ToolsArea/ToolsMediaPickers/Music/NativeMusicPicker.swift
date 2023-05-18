//
//  NativeMusicPicker.swift
//  
//
//  Created by Vladislav Gushin on 17.05.2023.
//

import UIKit
import SwiftUI
import PhotosUI
import MobileCoreServices
import AVKit
import MediaPlayer

struct NativeMusicPicker: UIViewControllerRepresentable {
    @Injected private var resultSettings: VDEVMediaEditorResultSettings
    
    typealias UIViewControllerType = MPMediaPickerController
    private(set) var onComplete: (CanvasAudioModel?) -> Void
    
    func makeUIViewController(context: Context) -> MPMediaPickerController {
        let mediaPicker: MPMediaPickerController = MPMediaPickerController(mediaTypes:.music)
        mediaPicker.delegate = context.coordinator
        mediaPicker.allowsPickingMultipleItems = false
        return mediaPicker
    }
    
    func updateUIViewController(_ uiViewController: MPMediaPickerController, context: Context) {}
    
    static func dismantleUIViewController(_ uiViewController: MPMediaPickerController, coordinator: Coordinator) {
        Log.d("❌ dismantle NativeMusicPicker")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }
    
    final class Coordinator: NSObject, MPMediaPickerControllerDelegate & UINavigationControllerDelegate {
        private let picker: NativeMusicPicker
        private let mediaPickerGetter: MediaPickerGetter
        
        init(with picker: NativeMusicPicker) {
            self.picker = picker
            self.mediaPickerGetter = .init()
        }
        
        deinit { Log.d("❌ Deinit: NativeMusicPicker.Coordinator") }
        
        @MainActor
        private func setResult(_ result: CanvasAudioModel) {
            picker.onComplete(result)
        }
        
        @MainActor
        private func emptyResult(errorMessage: String? = nil) {
            if let errorMessage = errorMessage { Log.e(errorMessage) }
            picker.onComplete(nil)
        }
        
        func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
            emptyResult()
        }
        
        func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
            
            mediaPicker.dismiss()
            
            Task {
                guard let item = mediaItemCollection.items.first, let url = item.assetURL else {
                    return emptyResult()
                }
                
                guard let exportedURL = await self.processAndExportComposition(soundFileUrl: url) else {
                    return emptyResult()
                }
                
                let thumbnail = item.artwork?.image(at: .init(width: 100, height: 100))
                
                let result = CanvasAudioModel(audioURL: exportedURL,
                                              thumbnail: thumbnail,
                                              title: item.title,
                                              albumTitle: item.albumTitle,
                                              albumArtist: item.albumArtist,
                                              comments: item.comments)
                setResult(result)
            }
        }
        
        private func processAndExportComposition(soundFileUrl: URL) async -> URL? {
            let recordAsset = AVURLAsset(url: soundFileUrl, options: nil)
            
            let composition = AVMutableComposition()
            guard let recordTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: CMPersistentTrackID()) else {
                return nil
            }
            
            guard let assetTrack1:AVAssetTrack = recordAsset.tracks(withMediaType: .audio).first else {
                return nil
            }
            
            let audioDuration:CMTime = assetTrack1.timeRange.duration
            do
            {
                try recordTrack.insertTimeRange(.init(start: .zero, end: audioDuration), of: assetTrack1, at: .zero)
            } catch {
                return nil
            }
            
            guard let blankMoviePathURL = Bundle.module.url(forResource: "blankVideo",
                                                            withExtension: ".mp4")
            else {
                // manage errors
                return nil
            }
            
            
            let videoAsset = AVAsset(url: blankMoviePathURL)
            // Get the video track from the empty video
            guard let sourceVideoTrack = videoAsset.tracks(withMediaType: .video).first
            else
            {
                // manage errors
                return nil
            }
            
            // Insert a new video track to the AVMutableComposition
            guard let videoTrack = composition.addMutableTrack(withMediaType: .video,
                                                               preferredTrackID: kCMPersistentTrackID_Invalid)
            else
            {
                // manage errors
                return nil
            }
            
            let trackTimeRange = CMTimeRange(start: .zero,
                                             duration: composition.duration)
            
            do {
                
                // Inset the contents of the video source into the new audio track
                try videoTrack.insertTimeRange(trackTimeRange,
                                               of: sourceVideoTrack,
                                               at: .zero)
                
            }
            catch {
                return nil
            }
            
            guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetPassthrough) else {
                return nil
            }
            
            guard let outURL = try? generateURLInCacheDir(withExtension: "MOV") else {
                return nil
            }
            
            export.outputFileType = .mov
            export.outputURL = outURL
            export.shouldOptimizeForNetworkUse = false
            
            do {
                return try await withCheckedThrowingContinuation { c in
                    export.exportAsynchronously { [weak export] in
                        if let error = export?.error {
                            Log.e(error)
                            c.resume(throwing: error)
                            return
                        }
                        Log.d(outURL)
                        c.resume(returning: outURL)
                    }
                }
            } catch {
                return nil
            }
        }
        
        private func generateURLInCacheDir(withExtension extension: String) throws -> URL {
            let imageIdentifier = UUID().uuidString
            let tmpDirURL = FileManager.default.temporaryDirectory
            return tmpDirURL.appendingPathComponent(imageIdentifier).appendingPathExtension(`extension`)
        }
    }
}
