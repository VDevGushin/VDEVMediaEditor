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

struct PhotoPickerView: UIViewControllerRepresentable {
    @Injected private var resultSettings: VDEVMediaEditorResultSettings
    
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
            imagePicker.overrideUserInterfaceStyle = .dark
            return imagePicker
        case .video:
            imagePicker.videoMaximumDuration = resultSettings.maximumVideoDuration
            imagePicker.mediaTypes = [UTType.movie.identifier]
            imagePicker.videoExportPreset = resultSettings.resolution.videoExportPreset
            imagePicker.videoQuality = .typeHigh
            imagePicker.overrideUserInterfaceStyle = .dark
            imagePicker.allowsEditing = true
            return imagePicker
        }
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    static func dismantleUIViewController(_ uiViewController: UIImagePickerController, coordinator: Coordinator) {
        Log.d("❌ dismantle PhotoPicker")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }


    class Coordinator: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        private let photoPicker: PhotoPickerView
        private let mediaPickerGetter: MediaPickerGetter

        init(with photoPicker: PhotoPickerView) {
            self.photoPicker = photoPicker
            self.mediaPickerGetter = .init()
        }
        
        deinit { Log.d("❌ Deinit: PhotoPickerView.Coordinator") }
        
        @MainActor
        private func setResult(_ result: PickerMediaOutput) {
            photoPicker.onComplete(result)
        }
        
        @MainActor
        private func emptyResult( errorMessage: String? = nil) {
            if let errorMessage = errorMessage { Log.e(errorMessage) }
            photoPicker.onComplete(nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            emptyResult()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
            picker.dismiss()
            
            Task(priority: .high) {
                guard let result = await mediaPickerGetter.makeResult(info: info) else {
                    return emptyResult()
                }
                setResult(result)
            }
        }
    }
}
