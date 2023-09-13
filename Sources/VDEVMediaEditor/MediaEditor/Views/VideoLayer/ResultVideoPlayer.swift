//
//  ResultVideoPlayer.swift
//  
//
//  Created by Vladislav Gushin on 22.09.2023.
//

import AVKit
import SwiftUI

// MARK: - Result video player
struct ResultVideoPlayer: View {
    @State private(set) var avAsset: AVAsset
    @State private var isPlaying: Bool = false
    
    let videoComposition: AVVideoComposition?
    let volume: Float
    let thumbnail: UIImage?
    let cornerRadius: CGFloat
    let aspectRatio: CGFloat?
    
    init(avAsset: AVAsset,
         videoComposition: AVVideoComposition? = nil,
         volume: Float = 0.0,
         thumbnail: UIImage? = nil,
         cornerRadius: CGFloat,
         aspectRatio: CGFloat? = nil) {
        self.avAsset = avAsset
        self.videoComposition = videoComposition
        self.volume = volume
        self.thumbnail = thumbnail
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
    }
    
    init(assetURL: URL,
         videoComposition: AVVideoComposition? = nil,
         volume: Float = 0.0,
         thumbnail: UIImage? = nil,
         cornerRadius: CGFloat,
         aspectRatio: CGFloat? = nil) {
        self.init(avAsset: AVAsset(url: assetURL),
                  videoComposition: videoComposition,
                  volume: volume,
                  thumbnail: thumbnail,
                  cornerRadius: cornerRadius,
                  aspectRatio: aspectRatio)
    }
    
    var body: some View {
        PlayerView(asset: avAsset,
                   videoComposition: videoComposition,
                   isPlaying: $isPlaying,
                   volume: .constant(volume),
                   cornerRadius: cornerRadius)
        .aspectRatio(aspectRatio ??
                     avAsset.tracks(withMediaType: .video).first?.aspectRatio ?? 1,
                     contentMode: .fit)
        .clipped()
        .onAppear {
            isPlaying = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (_) in
            isPlaying = true
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { (_) in
            isPlaying = false
        }
    }
}
