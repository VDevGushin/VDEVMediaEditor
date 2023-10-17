//
//  PickerMediaOutput.swift
//  
//
//  Created by Vladislav Gushin on 03.05.2023.
//
import Foundation
import PhotosUI
import MobileCoreServices
import AVKit

@globalActor
struct GetMediaActor {
  actor MediaActorType { }
  static let shared: MediaActorType = MediaActorType()
}

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
    private(set) var itemAsset: CanvasItemAsset?
    private(set) var url: URL?
    private(set) var mediaType: MediaType = .empty
    
    init(with photo: UIImage, asset: CanvasItemAsset?) {
        id = UUID().uuidString
        image = photo
        mediaType = .photo
        itemAsset = asset
    }
    
    init(with videoURL: URL, thumbnail: UIImage?, videoAsset: CanvasItemAsset?) {
        id = UUID().uuidString
        url = videoURL
        image = thumbnail
        itemAsset = videoAsset
        mediaType = .video
    }
}

final class MediaPickerGetter {
    @GetMediaActor
    func makeResult(
        info: [UIImagePickerController.InfoKey : Any],
        needOriginal: Bool = false
    ) async -> PickerMediaOutput? {
        
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else { return nil }
        
        switch mediaType {
        case String(UTType.image.identifier):
            guard let image = info[.originalImage] as? UIImage else { return nil }
            
            guard !needOriginal else {
                return .init(with: image, asset: nil)
            }
            
            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
                let compressed = image.compressImage(compressionQuality: 0.1, longSize: 640)
                return await .init(with: compressed, asset: .image(asset: asset, image: nil))
            }
            
            let compressed = image.compressImage(compressionQuality: 0.1, longSize: 640)
            
            return await .init(
                with: compressed,
                asset: .image(asset: nil, image: image)
            )
        case String(UTType.movie.identifier):
            guard let videoURL = info[.mediaURL] as? URL else { return nil }
            let thumbnail = await generateThumbnail(path: videoURL)
            //            if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            //                return .init(with: videoURL, thumbnail: thumbnail, videoAsset: .video(asset: asset, url: nil))
            //            }
            return await .init(
                with: videoURL,
                thumbnail: thumbnail,
                videoAsset: .video(asset: nil, url: videoURL)
            )
        default:
            return nil
        }
    }
    
    @GetMediaActor
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
}
