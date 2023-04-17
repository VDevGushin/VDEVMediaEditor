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

struct PhotoPickerView: View {
    let type: PhotoPickerViewType
    private(set) var onComplete: (PickerMediaOutput?) -> Void

    @State private var isLoading = false

    var body: some View {
        PhotoPicker(isLoading: $isLoading, type: type, onComplete: onComplete)
            .overlay(alignment: .center) {
                LoadingView(inProgress: isLoading, style: .large)
            }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController

    @Binding var isLoading: Bool
    private(set) var type: PhotoPickerViewType
    private(set) var onComplete: (PickerMediaOutput?) -> Void


    func makeUIViewController(context: Context) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        switch type {
        case .image:
            imagePicker.mediaTypes = [UTType.image.identifier]
            imagePicker.videoExportPreset = AVAssetExportPreset640x480
            imagePicker.videoQuality = .type640x480
        case .video:
            imagePicker.allowsEditing = true
            imagePicker.videoMaximumDuration = 30
            imagePicker.mediaTypes = [UTType.movie.identifier]
            imagePicker.videoExportPreset = AVAssetExportPreset640x480
            imagePicker.videoQuality = .type640x480
        }

        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = context.coordinator
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
        var photoPicker: PhotoPicker

        init(with photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }

        private func emptyResult() {
            DispatchQueue.main.async { [weak self] in
                self?.photoPicker.isLoading = false
                self?.photoPicker.onComplete(nil)
            }
        }

        func generateThumbnail(path: URL) -> UIImage? {
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
            
            DispatchQueue.main.async { [weak self] in
                self?.photoPicker.isLoading = true
            }

            guard let mediaType = info[.mediaType] as? String else {
                emptyResult()
                return
            }

            switch mediaType {
            case String(UTType.image.identifier):
                guard let image = info[.originalImage] as? UIImage else {
                    emptyResult()
                    return
                }
                
                let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset
                
                let compressed = image.compressImage(compressionQuality: 0.1, longSize: 640)

                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.photoPicker.onComplete(.init(with: compressed, asset: asset))
                    self.photoPicker.isLoading = false
                }

            case String(UTType.movie.identifier):
                
                guard let videoURL = info[.mediaURL] as? URL else {
                    emptyResult()
                    return
                }
                
                let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset

                DispatchQueue.global().async { [weak self] in
                    guard let self = self else { return }
                    
                    let image = self.generateThumbnail(path: videoURL)
                    
                    DispatchQueue.main.async {
                        self.photoPicker.isLoading = false
                        self.photoPicker.onComplete(.init(with: videoURL, thumbnail: image, videoAsset: asset))
                    }
                }
            default:
                emptyResult()
            }
        }
    }
}
