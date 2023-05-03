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
        imagePicker.cameraCaptureMode = .photo
        imagePicker.videoMaximumDuration = settings.maximumVideoDuration
        imagePicker.allowsEditing = false
        imagePicker.showsCameraControls = true
        imagePicker.overrideUserInterfaceStyle = .dark
        imagePicker.cameraFlashMode = .off
        imagePicker.modalPresentationStyle = .fullScreen
        imagePicker.videoQuality = .typeHigh
        imagePicker.videoExportPreset = AVAssetExportPresetPassthrough
        
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
        private let mediaPickerGetter: MediaPickerGetter
        
        init(_ parent: CameraVPViewNative) {
            self.parent = parent
            self.mediaPickerGetter = .init()
        }
        
        deinit { Log.d("❌ Deinit: CameraVPViewNative.Coordinator") }
        
        @MainActor
        private func setResult(_ result: PickerMediaOutput) {
            parent.onComplete(result)
        }
        
        @MainActor
        private func emptyResult( errorMessage: String? = nil) {
            if let errorMessage = errorMessage { Log.e(errorMessage) }
            parent.onComplete(nil)
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
