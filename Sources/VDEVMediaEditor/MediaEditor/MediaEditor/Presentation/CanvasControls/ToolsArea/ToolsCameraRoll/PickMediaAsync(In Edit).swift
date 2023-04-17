////
////  PickMediaAsync.swift
////  MediaEditor
////
////  Created by Vladislav Gushin on 19.02.2023.
////
//
import SwiftUI
import Combine
import AVKit
import PhotosUI


struct PickerMediaView: UIViewControllerRepresentable {
    @Binding var pickerResult: [UIImage] // pass images back to the SwiftUI view
    @Binding var isPresented: Bool // close the modal view
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let library = PHPhotoLibrary.shared()
        
        var configuration = PHPickerConfiguration(photoLibrary: library)
        configuration.filter = .any(of: [.images, .videos, .not(.livePhotos)])
        configuration.selectionLimit = 1 // ignore limit
        configuration.preferredAssetRepresentationMode = .current
        configuration.selection = .ordered
        
        
        
        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = context.coordinator // Use Coordinator for delegation
        return photoPickerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PickerMediaView
        
        init(_ parent: PickerMediaView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.pickerResult.removeAll()
            
            for image in results {
                
                if image.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    image.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                        if let error = error {
                            Log.e("Can't load image \(error.localizedDescription)")
                        } else if let image = newImage as? UIImage {
                            self?.parent.pickerResult.append(image)
                        }
                    }
                    
                } else {
                    print("Can't load asset")
                }
            }
            
            // close the modal view
            parent.isPresented = false
        }
    }
}

//struct PickerMediaAsyncView: View {
//    @StateObject private var vm: PickerMediaAsyncViewModel
//    @State private var isPresented: Bool = true
//
//    init(onComplete: @escaping (PickerMediaOutput?) async -> Void) {
//        self._vm = .init(wrappedValue: .init(onComplete: onComplete))
//    }
//
//    var body: some View {
//        MediaPicker(
//
//            isPresented: $isPresented,
//            limit: 1,
//            onChange: { medias in
//                vm.setup(media: medias.first)
//            }
//        )
//        .overlay {
//            LoadingView(inProgress: vm.isLoading, style: .large)
//                .ignoresSafeArea(.all)
//        }
//        .onChange(of: isPresented) { newValue in
//            if !newValue {
//                Task { await vm.onComplete(nil) }
//            }
//        }
//    }
//}
//
//private final class PickerMediaAsyncViewModel: ObservableObject {
//    private(set) var onComplete: (PickerMediaOutput?) async -> Void
//
//    @Published private(set) var isLoading: Bool = false
//
//    private var operation: Task<Void, Never>?
//
//    init(onComplete: @escaping (PickerMediaOutput?) async -> Void) {
//        self.onComplete = onComplete
//    }
//
//    @MainActor
//    private func setup(image: UIImage?) async {
//        await complete(image == nil ? nil : .init(with: image!))
//    }
//
//    @MainActor
//    private func setup(videoURL: URL?, tumbnail: UIImage?) async {
//        await complete(videoURL == nil ? nil : .init(with: videoURL!, thumbnail: tumbnail))
//    }
//
//    @MainActor
//    private func complete(_ result: PickerMediaOutput?) async {
//        isLoading = false
//        await onComplete(result)
//    }
//
//    func setup(media: Media?) {
//        isLoading = true
//
//        operation = Task(priority: .utility) {
//            guard let media = media else {
//                await complete(nil)
//                return
//            }
//
//            switch media.type {
//            case .image:
//                if let data = await media.getData() {
//                    let image = UIImage(data: data)
//                    let compressed = image?.compressImage()
//                    await setup(image: compressed)
//                }
//
//            case .video:
//                let mediaURL = await media.getVideoURL()
//
//                let exportSession = await compressVideoAsync(inputURL: mediaURL,
//                                            presetName: AVAssetExportPresetMediumQuality)
//
//                let videURL = exportSession?.outputURL ?? mediaURL
//
//                var tumbnail: UIImage? = nil
//
//                if let tumbnailURL = await media.getUrl(),
//                   let data = try? Data(contentsOf: tumbnailURL) {
//                    tumbnail = UIImage(data: data)
//                }
//
//                await setup(videoURL: videURL, tumbnail: tumbnail)
//            }
//        }
//    }
//
//    deinit {
//        operation?.cancel()
//        operation = nil
//        print("❌ Deinit: DrawingViewModel")
//    }
//}
