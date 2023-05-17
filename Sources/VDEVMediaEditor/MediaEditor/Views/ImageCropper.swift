//
//  ImageCropper.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 30.01.2023.
//

import SwiftUI
import UIKit
import Mantis

extension View {
    @ViewBuilder
    func imageCropper(show: Binding<Bool>,
                      item: ToolItem,
                      onComplete: @escaping (CanvasImageModel) -> Void) -> some View {
        switch item {
        case .imageCropper(let item):
            self.fullScreenCover(isPresented: show, content: {
                ImageCropperWrapper(show: show, item: item) { cropped in
                    let newItem = CanvasImageModel(image: cropped ?? item.image,
                                                   asset: nil)

                    newItem.update(offset: item.offset,
                                   scale: item.scale,
                                rotation: item.rotation)

                    onComplete(newItem)
                }
                .edgesIgnoringSafeArea(.all)
            })
        default: self
        }
    }
}

private final class ImageCropperWrapperViewModel: ObservableObject {
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var image: UIImage?
    
    private let item: CanvasImageModel

    init(item: CanvasImageModel) { self.item = item }
    
    func getImage() {
        isLoading = true
        Task {
            let originalFilteredImage = await item.getFilteredOriginal()
            await MainActor.run {
                image = originalFilteredImage ?? item.image
                isLoading = false
            }
        }
    }
}

private struct ImageCropperWrapper: View {
    @Binding private var isShow: Bool
    @StateObject private var vm: ImageCropperWrapperViewModel
    private let onClose: (UIImage?) -> Void
    
    init(show: Binding<Bool>, item: CanvasImageModel, onClose: @escaping (UIImage?) -> Void) {
        self._isShow = show
        self.onClose = onClose
        _vm = .init(wrappedValue: .init(item: item))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                ImageCropperView(image: image) { cropped in
                    isShow = false
                    onClose(cropped)
                }
            }
            
            LoadingView(inProgress: vm.isLoading, style: .large)
        }
        .onAppear { vm.getImage() }
    }
}

private struct ImageCropperView: UIViewControllerRepresentable {
    let image: UIImage
    let onClose: (UIImage?) -> Void
    
    func makeCoordinator() -> ImageEditorCoordinator {
        ImageEditorCoordinator(parent: self)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }

    func makeUIViewController(context: Context) -> Mantis.CropViewController {
        let editor = Mantis.cropViewController(image: image)
        editor.delegate = context.coordinator
        return editor
    }

    final class ImageEditorCoordinator: NSObject, CropViewControllerDelegate {
        private let parent: ImageCropperView

        init(parent: ImageCropperView) { self.parent = parent }

        func cropViewControllerDidImageTransformed(_ cropViewController: Mantis.CropViewController) { }

        func cropViewControllerDidCrop(_ cropViewController: Mantis.CropViewController, cropped: UIImage, transformation: Mantis.Transformation, cropInfo: Mantis.CropInfo) {
            self.parent.onClose(cropped)
        }

        func cropViewControllerDidFailToCrop(_ cropViewController: Mantis.CropViewController, original: UIImage) { }

        func cropViewControllerDidCancel(_ cropViewController: Mantis.CropViewController, original: UIImage) {
            self.parent.onClose(nil)
        }

        func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) { }

        func cropViewControllerDidEndResize(_ cropViewController: Mantis.CropViewController, original: UIImage, cropInfo: Mantis.CropInfo) {
        }
    }
}
