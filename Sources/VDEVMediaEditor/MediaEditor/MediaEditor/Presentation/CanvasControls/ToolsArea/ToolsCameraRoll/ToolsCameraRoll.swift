//
//  CameraVPView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 06.02.2023.
//

import SwiftUI
import YPImagePicker
import AVKit
import PhotosUI


struct ToolsCameraRoll {
    enum MediaType {
        case photo, video, livePhoto
    }

    var id: String
    var photo: UIImage?
    var url: URL?
    var mediaType: MediaType = .photo

    init(with photo: UIImage) {
        id = UUID().uuidString
        self.photo = photo
        mediaType = .photo
    }

    init(with videoURL: URL, photo: UIImage?) {
        id = UUID().uuidString
        url = videoURL
        self.photo = photo
        mediaType = .video
    }
}

struct CameraVPView: UIViewControllerRepresentable {
    @Injected private var images: VDEVImageConfig
    
    let isLibrary: Bool
    let canvasSize: CGSize
    let didPick: (ToolsCameraRoll?) -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraVPView>) -> YPImagePicker {

        var config = YPImagePickerConfiguration()

        if isLibrary {
            config.startOnScreen = .library
            config.screens = [.library]
        } else {
            config.startOnScreen = .photo
            config.screens = [.photo, .video]
        }
        config.hidesCancelButton = false
        config.showsPhotoFilters = false
        config.hidesStatusBar = true
        config.hidesBottomBar = false
        config.maxCameraZoomFactor = 2.0
        ////config.showsCrop = .rectangle(ratio: canvasSize.width / canvasSize.height)
        config.onlySquareImagesFromCamera = false
        config.shouldSaveNewPicturesToAlbum = false
        config.showsVideoTrimmer = false
        config.video.compression = AVAssetExportPresetPassthrough
        config.video.recordingTimeLimit = 30.0
        config.video.libraryTimeLimit = 30.0

        config.showsCropGridOverlay = true
        config.gallery.hidesRemoveButton = false
        config.library.itemOverlayType = .grid
        config.library.options = nil
        config.library.onlySquare = false
        config.library.isSquareByDefault = false
        config.library.minWidthForItem = nil
        config.library.mediaType = .photoAndVideo
        config.library.defaultMultipleSelection = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 4
        config.library.spacingBetweenItems = 1.0
        config.library.preselectedItems = nil
        config.library.skipSelectionsGallery = false
        config.library.preSelectItemOnMultipleSelection = true

        config.wordings.ok = "ok"
        config.wordings.done = "Done"
        config.wordings.cancel =  "Cancel"
        config.wordings.save = "Save"
        config.wordings.processing = "Processing"
        config.wordings.trim = "Trim"
        config.wordings.cover = "Cover"
        config.wordings.albumsTitle = "Albums"
        config.wordings.libraryTitle = "Library"
        config.wordings.cameraTitle = "Photo"
        config.wordings.videoTitle = "Video"
        config.wordings.next = "Next"
        config.wordings.filter = "Filter"
        config.wordings.crop = "Crop"
        config.colors.photoVideoScreenBackgroundColor = AppColors.black.uiColor

        config.icons.capturePhotoImage = images.common.photoVideoCapture

        let picker = YPImagePicker(configuration: config)
        picker.overrideUserInterfaceStyle = .dark
        picker.didFinishPicking(completion: context.coordinator.completion(_:_:))


        return picker
    }

    static func dismantleUIViewController(_ uiViewController: YPImagePicker, coordinator: Coordinator) {
    }

    func updateUIViewController(_ uiViewController: YPImagePicker, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator {
        private let parent: CameraVPView

        init(_ parent: CameraVPView) { self.parent = parent }

        func completion(_ items: [YPMediaItem], _ cancelled: Bool) -> Void {
            if cancelled {
                parent.didPick(nil)
                return
            }

            if let firstItem = items.first {
                switch firstItem {
                case .photo(let photo):
                    self.parent.didPick(ToolsCameraRoll(with: photo.image))
                case .video(let video):
                    parent.didPick(.init(with: video.url, photo: video.thumbnail))
                }
            }

            parent.didPick(nil)
        }
    }
}
