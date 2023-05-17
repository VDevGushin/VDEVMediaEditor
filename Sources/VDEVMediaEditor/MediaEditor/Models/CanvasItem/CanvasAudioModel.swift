//
//  CanvasAudioModel.swift
//  
//
//  Created by Vladislav Gushin on 17.05.2023.
//

import Foundation
import Combine
import UIKit

final class CanvasAudioModel: CanvasItemModel {
    private(set) var volume: Float
    private(set) var thumbnail: UIImage?
    private(set) var audioURL: URL
    private(set) var title: String?
    private(set) var albumTitle: String?
    private(set) var albumArtist: String?
    private(set) var comments: String?
    
    init(audioURL: URL,
         thumbnail: UIImage?,
         volume: Float = 1.0,
         title: String?,
         albumTitle: String?,
         albumArtist: String?,
         comments: String?) {
        self.thumbnail = thumbnail
        self.audioURL = audioURL
        self.volume = volume
        self.title = title
        self.albumTitle = albumTitle
        self.albumArtist = albumArtist
        self.comments = comments

        super.init(type: .audio)
    }

    deinit {
        thumbnail = nil
        Log.d("❌ Deinit: CanvasAudioModel")
    }
    
    func update(volume: Float) {
        self.volume = volume
    }

    override func copy() -> CanvasAudioModel {
        let new = CanvasAudioModel(audioURL: audioURL,
                                   thumbnail: thumbnail,
                                   title: title,
                                   albumTitle: albumTitle,
                                   albumArtist: albumArtist,
                                   comments: comments)
        new.update(offset: offset, scale: scale, rotation: rotation)
        new.update(volume: volume)
        return new
    }
}
