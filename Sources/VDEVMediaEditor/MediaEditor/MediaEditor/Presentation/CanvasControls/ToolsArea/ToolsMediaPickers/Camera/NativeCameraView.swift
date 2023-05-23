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
    @Injected private var resultSettings: VDEVMediaEditorResultSettings
    let onComplete: (PickerMediaOutput?) -> Void
    @Environment(\.presentationManager) var presentationManager
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraVPViewNative>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    static func dismantleUIViewController(_ uiViewController: UIImagePickerController, coordinator: Coordinator) {
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        uiViewController.sourceType = .camera
        uiViewController.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
        uiViewController.cameraCaptureMode = .photo
        uiViewController.videoMaximumDuration = resultSettings.maximumVideoDuration
        uiViewController.allowsEditing = false
        uiViewController.showsCameraControls = true
        uiViewController.overrideUserInterfaceStyle = .dark
        uiViewController.cameraFlashMode = .off
        uiViewController.modalPresentationStyle = .fullScreen
        uiViewController.videoQuality = .typeHigh
        uiViewController.videoExportPreset = AVAssetExportPresetPassthrough
    }
    
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
            defer { parent.presentationManager.dismiss() }
            emptyResult()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            defer { parent.presentationManager.dismiss() }
            
            Task(priority: .high) {
                guard let result = await mediaPickerGetter.makeResult(info: info) else {
                    return emptyResult()
                }
                setResult(result)
            }
        }
    }
}
