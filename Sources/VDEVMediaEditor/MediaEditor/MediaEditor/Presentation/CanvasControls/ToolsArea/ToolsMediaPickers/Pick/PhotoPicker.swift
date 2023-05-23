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
    @Injected private var resolution: ResolutionService
    
    @Environment(\.presentationManager) var presentationManager
    
    typealias UIViewControllerType = UIImagePickerController
    private(set) var type: PhotoPickerViewType
    private(set) var onComplete: (PickerMediaOutput?) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        uiViewController.sourceType = .photoLibrary
        switch type {
        case .image:
            uiViewController.mediaTypes = [UTType.image.identifier]
            uiViewController.videoExportPreset = AVAssetExportPreset640x480
            uiViewController.videoQuality = .type640x480
            uiViewController.overrideUserInterfaceStyle = .dark
        case .video:
            uiViewController.videoMaximumDuration = resultSettings.maximumVideoDuration
            uiViewController.mediaTypes = [UTType.movie.identifier]
            uiViewController.videoExportPreset = resolution.videoExportPreset()
            uiViewController.videoQuality = .typeHigh
            uiViewController.overrideUserInterfaceStyle = .dark
            uiViewController.allowsEditing = true
        }
    }

    static func dismantleUIViewController(_ uiViewController: UIImagePickerController, coordinator: Coordinator) {
        Log.d("❌ dismantle PhotoPicker")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(with: self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
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
            defer { photoPicker.presentationManager.dismiss() }
            emptyResult()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         
            defer { photoPicker.presentationManager.dismiss() }
            
            Task(priority: .high) {
                guard let result = await mediaPickerGetter.makeResult(info: info) else {
                    return emptyResult()
                }
                setResult(result)
            }
        }
    }
}
