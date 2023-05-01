//
//  PhotoPicker.swift.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 09.02.2023.
//

import UIKit
import SwiftUI
import PhotosUI
import MobileCoreServices
import AVKit

enum PhotoPickerViewType {
    case video
    case image
}

struct PickerMediaOutput {
    enum MediaType {
        case photo, video, livePhoto, empty
    }

    private(set) var id: String
    private(set) var image: UIImage?
    private(set) var phAsset: PHAsset?
    private(set) var url: URL?
    private(set) var mediaType: MediaType = .empty

    init(with photo: UIImage, asset: PHAsset?) {
        id = UUID().uuidString
        image = photo
        mediaType = .photo
        phAsset = asset
    }

    init(with videoURL: URL, thumbnail: UIImage?, videoAsset: PHAsset?) {
        id = UUID().uuidString
        url = videoURL
        image = thumbnail
        phAsset = videoAsset
        mediaType = .video
    }
}

struct PhotoPickerView: UIViewControllerRepresentable {
    @Injected private var settings: VDEVMediaEditorSettings
    
    typealias UIViewControllerType = UIImagePickerController
    private(set) var type: PhotoPickerViewType
    private(set) var onComplete: (PickerMediaOutput?) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .photoLibrary
        
        switch type {
        case .image:
            imagePicker.mediaTypes = [UTType.image.identifier]
            imagePicker.videoExportPreset = AVAssetExportPreset640x480
            imagePicker.videoQuality = .type640x480
        case .video:
            imagePicker.allowsEditing = true
            imagePicker.videoMaximumDuration = settings.maximumVideoDuration
            imagePicker.mediaTypes = [UTType.movie.identifier]
            imagePicker.videoExportPreset = AVAssetExportPreset640x480
            imagePicker.videoQuality = .type640x480
        }

        imagePicker.overrideUserInterfaceStyle = .dark
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    static func dismantleUIViewController(_ uiViewController: UIImagePickerController, coordinator: Coordinator) {
        Log.d("❌ dismantle PhotoPicker")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }


    class Coordinator: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        var photoPicker: PhotoPickerView

        init(with photoPicker: PhotoPickerView) {
            self.photoPicker = photoPicker
        }
        
        deinit { Log.d("❌ Deinit: PhotoPickerView.Coordinator") }
        
        @MainActor
        private func setResult(_ result: PickerMediaOutput) {
            DispatchQueue.main.async { [weak self] in self?.photoPicker.onComplete(result) }
        }
        
        @MainActor
        private func emptyResult( errorMessage: String? = nil) {
            if let errorMessage = errorMessage { Log.e(errorMessage) }
            DispatchQueue.main.async { [weak self] in self?.photoPicker.onComplete(nil) }
        }

        private func generateThumbnail(path: URL) async -> UIImage? {
            do {
                let asset = AVURLAsset(url: path, options: nil)
                let imgGenerator = AVAssetImageGenerator(asset: asset)
                imgGenerator.appliesPreferredTrackTransform = true
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                return thumbnail
            } catch let error {
                Log.e("*** Error generating thumbnail: \(error.localizedDescription)")
                return nil
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            emptyResult()
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
            picker.dismiss()
            
            guard let mediaType = info[.mediaType] as? String else {
                emptyResult()
                return
            }
            
            Task(priority: .high) {
                
                switch mediaType {
                case String(UTType.image.identifier):
                    guard let image = info[.originalImage] as? UIImage else {
                        emptyResult()
                        return
                    }
                    
                    let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
                    
                    let compressed = image.compressImage(compressionQuality: 0.1, longSize: 640)
                    
                    setResult(.init(with: compressed, asset: asset))
                    
                case String(UTType.movie.identifier):
                    
                    guard let videoURL = info[.mediaURL] as? URL else {
                        emptyResult()
                        return
                    }
                    
                    let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
                    
                    let image = await generateThumbnail(path: videoURL)
                    
                    setResult(.init(with: videoURL, thumbnail: image, videoAsset: asset))
                    
                default:
                    emptyResult()
                }
            }
        }
    }
}
