//////
//////  PickMediaAsync.swift
//////  MediaEditor
//////
//////  Created by Vladislav Gushin on 19.02.2023.
//////
////
//import SwiftUI
//import Combine
//import AVKit
//import PhotosUI
//
//enum MediaExportError: Error {
//    case imageExportReturnedNoData
//    case cannotGetJPEGRepresentation
//    case cannotGetAVAssetExportSession
//    case cannotFetchAVAsset
//    case cannotFetchPHAsset
//    case noVideoExportPresetsAvailable
//    case noCachesDirectory
//    case avAssetExportSessionFailed
//}
//
//struct PickerMediaView: UIViewControllerRepresentable {
//    private(set) var onComplete: (PickerMediaOutput?) -> Void
//    
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let library = PHPhotoLibrary.shared()
//        var configuration = PHPickerConfiguration(photoLibrary: library)
//        configuration.filter = .all(of: [.any(of: [.images, .screenshots, .panoramas, .videos])])
//        configuration.selectionLimit = 1
//        configuration.preferredAssetRepresentationMode = .automatic
//        configuration.selection = .ordered
//        let photoPickerViewController = PHPickerViewController(configuration: configuration)
//        photoPickerViewController.overrideUserInterfaceStyle = .dark
//        photoPickerViewController.delegate = context.coordinator
//        return photoPickerViewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
//    
//    func makeCoordinator() -> Coordinator { Coordinator(self) }
//    
//    final class Coordinator: PHPickerViewControllerDelegate {
//        private let parent: PickerMediaView
//        
//        init(_ parent: PickerMediaView) {
//            self.parent = parent
//        }
//        
//        deinit { Log.d("❌ Deinit: PickerMediaView.Coordinator") }
//        
//        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//            guard !results.isEmpty else {
//                return emptyResult()
//            }
//            
//            for item in results {
//                if item.itemProvider.canLoadObject(ofClass: UIImage.self) {
//                    fetchImage(from: item)
//                    return
//                }
//                
//                if item.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
//                    fetchVideo(from: item)
//                    return
//                }
//                
//                emptyResult()
//            }
//        }
//        
//        private func fetchVideo(from item: PHPickerResult) {
//            item.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] videoURL, error in
//                if let error = error {
//                    self?.emptyResult(errorMessage: error.localizedDescription)
//                } else {
//                    guard let url = videoURL else {
//                        self?.emptyResult(errorMessage: "Empty url")
//                        return
//                    }
//                    
//                    if !FileManager.default.fileExists(atPath: url.path) {
//                        self?.emptyResult(errorMessage: "File doesn't exist at path")
//                        return
//                    }
//                    
//                    self?.exportForVideo(item: item, url: url)
//                }
//            }
//        }
//        
//        private func fetchImage(from item: PHPickerResult) {
//            item.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
//                if let error = error {
//                    self?.emptyResult(errorMessage: error.localizedDescription)
//                } else if let image = newImage as? UIImage {
//                    let asset = self?.getPHAsset(from: item)
//                    let compressed = image.compressImage(compressionQuality: 0.1, longSize: 640)
//                    let result = PickerMediaOutput.init(with: compressed, asset: asset)
//                    self?.setResult(result)
//                }
//            }
//        }
//        
//        @MainActor
//        private func setResult(_ result: PickerMediaOutput) {
//            DispatchQueue.main.async { [weak self] in self?.parent.onComplete(result) }
//        }
//        
//        @MainActor
//        private func emptyResult( errorMessage: String? = nil) {
//            if let errorMessage = errorMessage { Log.e(errorMessage) }
//            DispatchQueue.main.async { [weak self] in self?.parent.onComplete(nil) }
//        }
//    }
//}
//
//// MARK: - Helpers
//private extension PickerMediaView.Coordinator {
//    func generateThumbnail(path: URL) -> UIImage? {
//        do {
//            let asset = AVURLAsset(url: path, options: nil)
//            let imgGenerator = AVAssetImageGenerator(asset: asset)
//            imgGenerator.appliesPreferredTrackTransform = true
//            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
//            let thumbnail = UIImage(cgImage: cgImage)
//            return thumbnail
//        } catch let error {
//            Log.e("*** Error generating thumbnail: \(error.localizedDescription)")
//            return nil
//        }
//    }
//    
//    func getPHAsset(from item: PHPickerResult) -> PHAsset? {
//        if let id = item.assetIdentifier,
//           let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [id],
//                                                 options: nil).firstObject{
//            return fetchResult
//        }
//        return nil
//    }
//    
//    func makeUrlForVideoExportSession(url: URL) -> URL {
//        FileManager.default
//            .temporaryDirectory
//            .appendingPathComponent("\(UUID().uuidString)\(url.lastPathComponent)")
//    }
//}
//
//// MARK: - Export video
//private extension PickerMediaView.Coordinator {
//    func exportForVideo(item: PHPickerResult, url: URL) {
//        Task(priority: .high) {
//            let asset = self.getPHAsset(from: item)
//            
//            var destinationUrl = try? await self.tryToExport(url: url, asset: asset)
//            
//            if let destinationUrl = destinationUrl {
//                let thumbnail = self.generateThumbnail(path: destinationUrl)
//                
//                let result = PickerMediaOutput.init(with: destinationUrl,
//                                                    thumbnail: thumbnail,
//                                                    videoAsset: asset)
//                
//                self.setResult(result)
//                return
//            }
//            
//            destinationUrl = makeUrlForVideoExportSession(url: url)
//            
//            do {
//                try? FileManager.default.removeItem(at: destinationUrl!)
//                try FileManager.default.copyItem(at: url, to: destinationUrl!)
//            } catch {
//                emptyResult(errorMessage: "ERROR: Unable to copy file - \(error.localizedDescription)")
//                return
//            }
//            
//            let thumbnail = self.generateThumbnail(path: destinationUrl!)
//            
//            let result = PickerMediaOutput.init(with: destinationUrl!,
//                                                thumbnail: thumbnail,
//                                                videoAsset: asset)
//            
//            self.setResult(result)
//        }
//    }
//    
//    func tryToExport(url: URL, asset: PHAsset?) async throws -> URL {
//        guard let asset = asset else {
//            throw MediaExportError.cannotFetchPHAsset
//        }
//        
//        let outputURL = self.makeUrlForVideoExportSession(url: url)
//        let exportSession = try await self.exportSessionForVideoAsset(asset)
//        
//        exportSession.outputFileType = .mov
//        exportSession.outputURL = outputURL
//        exportSession.shouldOptimizeForNetworkUse = true
//        
//        try await withCheckedThrowingContinuation { c in
//            exportSession.exportAsynchronously() { [weak exportSession] in
//                if let error = exportSession?.error {
//                    c.resume(throwing: error)
//                    return
//                }
//                c.resume(returning: ())
//            }
//        } as Void
//        
//        return outputURL
//    }
//    
//    func exportSessionForVideoAsset(_ asset: PHAsset) async throws -> AVAssetExportSession {
//        let avAsset = try await fetchAVAsset(for: asset)
//        let preset = try await videoExportPreset(for: avAsset)
//        
//        return try await withCheckedThrowingContinuation
//        { (continuation: CheckedContinuation<AVAssetExportSession, Error>) in
//            PHImageManager.default().requestExportSession(
//                forVideo: asset,
//                options: makeVideoRequestOptions(),
//                exportPreset: preset
//            ) { session, info in
//                guard let session = session else {
//                    continuation.resume(throwing: MediaExportError.cannotGetAVAssetExportSession)
//                    return
//                }
//                continuation.resume(returning: session)
//            }
//        }
//    }
//    
//    func videoExportPreset(for asset: AVAsset) async throws -> String {
//        let preferredPresets = [
//            AVAssetExportPreset640x480,
//            AVAssetExportPresetMediumQuality,
//            AVAssetExportPreset1280x720,
//            AVAssetExportPresetLowQuality,
//            AVAssetExportPreset960x540
//        ]
//        let compatiblePresets = AVAssetExportSession.exportPresets(compatibleWith: asset)
//        let allPresets = preferredPresets + compatiblePresets
//        for preset in allPresets {
//            let canExport = await AVAssetExportSession.compatibility(
//                ofExportPreset: preset,
//                with: asset,
//                outputFileType: .mov
//            )
//            if canExport {
//                return preset
//            }
//        }
//        throw MediaExportError.noVideoExportPresetsAvailable
//    }
//    
//    func fetchAVAsset(for asset: PHAsset) async throws -> AVAsset {
//        try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<AVAsset, Error>) in
//            PHImageManager.default().requestAVAsset(
//                forVideo: asset,
//                options: makeVideoRequestOptions()
//            ) { avAsset, audioMix, info in
//                guard let avAsset = avAsset else {
//                    continuation.resume(throwing: MediaExportError.cannotFetchAVAsset)
//                    return
//                }
//                continuation.resume(returning: avAsset)
//            }
//        })
//    }
//    
//    func makeVideoRequestOptions() -> PHVideoRequestOptions {
//        let options = PHVideoRequestOptions()
//        options.deliveryMode = .mediumQualityFormat
//        options.isNetworkAccessAllowed = true
//        options.version = .current
//        return options
//    }
//}
