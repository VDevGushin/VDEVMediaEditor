//
//  VideoPlayerViewForLayers.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.02.2023.
//

import AVKit
import SwiftUI
import Combine

final private class VideoPlayerViewForLayersVM: ObservableObject {
    @Injected private var processingWatcher: ItemProcessingWatcher
    @Published var inProcessing: Bool = false
    private var operation: AnyCancellable?
    
    init() {
        operation = processingWatcher
            .inProcessing
            .removeDuplicates()
            .sink(on: .main, object: self) { wSelf, value in
                wSelf.inProcessing = value
            }
    }
}

// MARK: - PlayerForLayer
struct VideoPlayerViewForLayers: View {
    @StateObject private var vm = VideoPlayerViewForLayersVM()
    @State private(set) var avAsset: AVAsset
    @State private(set) var isPlaying: Bool = false
    @State private(set) var volume: Float
    
    let videoComposition: AVVideoComposition?
    let thumbnail: UIImage?
    
    init(avAsset: AVAsset,
         videoComposition: AVVideoComposition?,
         volume: Float,
         thumbnail: UIImage?
    ) {
        self.avAsset = avAsset
        self.videoComposition = videoComposition
        self.volume = volume
        self.thumbnail = thumbnail
    }
    
    init(assetURL: URL,
         videoComposition: AVVideoComposition?,
         thumbnail: UIImage?,
         volume: Float
    ) {
        self.init(
            avAsset: AVAsset(url: assetURL),
            videoComposition: videoComposition,
            volume: volume,
            thumbnail: thumbnail
        )
    }
    
    var body: some View {
        PlayerView(asset: avAsset,
                   videoComposition: videoComposition,
                   isPlaying: $isPlaying,
                   volume: $volume,
                   cornerRadius: nil)
        .aspectRatio(avAsset.tracks(withMediaType: .video).first?.aspectRatio ?? 1,
                     contentMode: .fill)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isPlaying = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
            isPlaying = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { (_) in
            isPlaying = false
        }
        .onReceive(vm.$inProcessing) { value in
            isPlaying = !value
        }
    }
}
