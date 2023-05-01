//
//  CameraVPViewNative.swift
//  
//
//  Created by Vladislav Gushin on 01.05.2023.
//

import UIKit
import SwiftUI
import PhotosUI
import MobileCoreServices
import AVKit

struct NativeCameraView: View {
    let onComplete: (PickerMediaOutput?) -> Void
    
    var body: some View {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            CameraVPViewNative(onComplete: onComplete)
        } else {
            EmptyView()
        }
    }
}

struct CameraVPViewNative: UIViewControllerRepresentable {
    @Injected private var settings: VDEVMediaEditorSettings
    let onComplete: (PickerMediaOutput?) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraVPViewNative>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
        imagePicker.cameraCaptureMode = .video
        imagePicker.videoMaximumDuration = settings.maximumVideoDuration
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = true
        imagePicker.overrideUserInterfaceStyle = .dark
        imagePicker.cameraFlashMode = .off
        imagePicker.videoQuality = .typeHigh
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.videoExportPreset = AVAssetExportPreset1280x720
        
        return imagePicker
    }
    
    static func dismantleUIViewController(_ uiViewController: UIImagePickerController, coordinator: Coordinator) {
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        private let parent: CameraVPViewNative
        
        init(_ parent: CameraVPViewNative) { self.parent = parent }
        
        deinit { Log.d("❌ Deinit: CameraVPViewNative.Coordinator") }
        
        @MainActor
        private func setResult(_ result: PickerMediaOutput) {
            DispatchQueue.main.async { [weak self] in self?.parent.onComplete(result) }
        }
        
        @MainActor
        private func emptyResult( errorMessage: String? = nil) {
            if let errorMessage = errorMessage { Log.e(errorMessage) }
            DispatchQueue.main.async { [weak self] in self?.parent.onComplete(nil) }
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
                    
                    var resultImage = image
                    
                    if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                        resultImage = image.compressImage(compressionQuality: 0.1, longSize: 640)
                        setResult(.init(with: resultImage, asset: asset))
                        return
                    }
                    
                    setResult(.init(with: resultImage, asset: nil))
                    
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
