////
////  PickMediaSDK.swift
////
////
////  Created by Vladislav Gushin on 01.05.2023.
////
//
//import UIKit
//import AssetsPickerViewController
//import SwiftUI
//import PhotosUI
//
//struct PickMediaSDK: UIViewControllerRepresentable {
//    private(set) var onComplete: (PickerMediaOutput?) -> Void
//
//    func makeUIViewController(context: Context) -> some UIViewController {
//        let pickerConfig = AssetsPickerConfig()
//        pickerConfig.albumIsShowEmptyAlbum = true
//        pickerConfig.albumIsShowHiddenAlbum = true
//        pickerConfig.albumIsShowMomentAlbums = true
//        pickerConfig.assetIsShowCameraButton = false
//
//        pickerConfig.assetsMaximumSelectionCount = 1
//        pickerConfig.albumDefaultType = .albumMyPhotoStream
//
//        let options = PHFetchOptions()
//        options.predicate = NSPredicate(format: "duration <= %f", 15.0)
//        // options.sortDescriptors = [NSSortDescriptor(key: "duration", ascending: true)]
//
//        pickerConfig.assetFetchOptions = [
//            .smartAlbum: options,
//            .album: options,
//        ]
//
//        let picker = AssetsPickerViewController()
//        picker.isShowLog = true
//        picker.pickerConfig = pickerConfig
//        picker.pickerDelegate = context.coordinator
//        picker.overrideUserInterfaceStyle = .dark
//        picker.navigationController?.overrideUserInterfaceStyle = .dark
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
//
//    func makeCoordinator() -> Coordinator { Coordinator(self) }
//
//    final class Coordinator: AssetsPickerViewControllerDelegate {
//        private let parent: PickMediaSDK
//
//        init(_ parent: PickMediaSDK) {
//            self.parent = parent
//        }
//
//        deinit { Log.d("❌ Deinit: PickMediaSDK.Coordinator") }
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
//
//        @MainActor
//        func assetsPickerDidCancel(controller: AssetsPickerViewController) {
//            emptyResult()
//        }
//
//        @MainActor
//        func assetsPickerCannotAccessPhotoLibrary(controller: AssetsPickerViewController) {
//            emptyResult()
//        }
//
//        func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
//
//        }
//
//        @MainActor
//        func assetsPicker(controller: AssetsPickerViewController, didSelect asset: PHAsset, at indexPath: IndexPath) {
//            switch asset.mediaType {
//            case .image: fetchImage(asset: asset)
//            case .video: fetchVideo(asset: asset)
//            default:
//                emptyResult()
//            }
//        }
//
//        func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
//            if controller.selectedAssets.count > 0 {
//                controller.photoViewController.deselectAll()
//            }
//            return true
//        }
//    }
//}
//
//private extension PickMediaSDK.Coordinator {
//    func fetchVideo(asset: PHAsset) {
//        Task(priority: .high) {
//            do {
//                let url = try await asset.getURL()
//
//                if !FileManager.default.fileExists(atPath: url.path) {
//                    await emptyResult(errorMessage: "File doesn't exist at path")
//                    return
//                }
//
//                await exportForVideo(asset: asset, url: url)
//
//            } catch {
//                await emptyResult(errorMessage: "Can't get video")
//            }
//        }
//    }
//
//    func fetchImage(asset: PHAsset) {
//        Task(priority: .high) {
//            var image: UIImage?
//
//            if let imageURL = try? await asset.getURL(),
//               let data = try? Data(contentsOf: imageURL) {
//                image = UIImage(data: data)
//            } else {
//                image = asset.getImage()
//            }
//
//            guard let image = image else {
//                await emptyResult(errorMessage: "No image")
//                return
//            }
//
//            let compressed = image.compressImage(compressionQuality: 0.1, longSize: 640)
//            let result = PickerMediaOutput.init(with: compressed, asset: asset)
//            await self.setResult(result)
//        }
//    }
//}
//
//// MARK: - Export video
//private extension PickMediaSDK.Coordinator {
//    func exportForVideo(asset: PHAsset, url: URL) async {
//        var destinationUrl = try? await self.tryToExport(url: url, asset: asset)
//
//        if let destinationUrl = destinationUrl {
//            let thumbnail = self.generateThumbnail(path: destinationUrl)
//
//            let result = PickerMediaOutput.init(with: destinationUrl,
//                                                thumbnail: thumbnail,
//                                                videoAsset: asset)
//
//            await setResult(result)
//            return
//        }
//
//        destinationUrl = makeUrlForVideoExportSession(url: url)
//
//        do {
//            try? FileManager.default.removeItem(at: destinationUrl!)
//            try FileManager.default.copyItem(at: url, to: destinationUrl!)
//        } catch {
//            await emptyResult(errorMessage: "ERROR: Unable to copy file - \(error.localizedDescription)")
//            return
//        }
//
//        let thumbnail = self.generateThumbnail(path: destinationUrl!)
//
//        let result = PickerMediaOutput.init(with: destinationUrl!,
//                                            thumbnail: thumbnail,
//                                            videoAsset: asset)
//        await setResult(result)
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
//
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
//    func makeUrlForVideoExportSession(url: URL) -> URL {
//        FileManager.default
//            .temporaryDirectory
//            .appendingPathComponent("\(UUID().uuidString)\(url.lastPathComponent)")
//    }
//}
