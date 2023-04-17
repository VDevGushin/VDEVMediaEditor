//
//  LivePhotoView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.02.2023.
//

import SwiftUI
import PhotosUI

struct LivePhotoView: UIViewRepresentable {
    typealias UIViewType = PHLivePhotoView

    var livePhoto: PHLivePhoto

    func makeUIView(context: Context) -> PHLivePhotoView {
        PHLivePhotoView()


        // Enable the following optionally to see live photo
        // playing back when it appears.
        // livePhotoView.startPlayback(with: .hint)

        //return livePhotoView
    }

    func updateUIView(_ uiView: PHLivePhotoView, context: Context) {
        uiView.livePhoto = livePhoto
    }
}
