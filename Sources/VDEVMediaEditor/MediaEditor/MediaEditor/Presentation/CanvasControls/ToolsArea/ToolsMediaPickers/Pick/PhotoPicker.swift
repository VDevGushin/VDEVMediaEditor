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
    private(set) var needOriginal: Bool
    private(set) var onComplete: (PickerMediaOutput?) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        imagePicker.view.backgroundColor = .clear
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        uiViewController.sourceType = .photoLibrary
        uiViewController.view.backgroundColor = .clear
        switch type {
        case .image:
            uiViewController.mediaTypes = [UTType.image.identifier]
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
        Coordinator(with: self, needOriginal: needOriginal)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
        private let photoPicker: PhotoPickerView
        private let mediaPickerGetter: MediaPickerGetter
        private let needOriginal: Bool

        init(with photoPicker: PhotoPickerView, needOriginal: Bool) {
            self.photoPicker = photoPicker
            self.needOriginal = needOriginal
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
                guard let result = await mediaPickerGetter.makeResult(
                    info: info,
                    needOriginal: needOriginal
                ) else {
                    return emptyResult()
                }
                setResult(result)
            }
        }
    }
}
