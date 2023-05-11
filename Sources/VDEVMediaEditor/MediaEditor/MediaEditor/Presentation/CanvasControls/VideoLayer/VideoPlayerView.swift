//
//  VideoPlayerView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.02.2023.
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

// MARK: - Fight video player
struct VideoPlayerView: View {
    @State private(set) var avAsset: AVAsset
    @State private(set) var isPlaying: Bool = false
    @Binding private(set) var volume: Float
    
    let videoComposition: AVVideoComposition?
    let thumbnail: UIImage?
    
    init(avAsset: AVAsset,
         videoComposition: AVVideoComposition?,
         volume: Binding<Float>,
         thumbnail: UIImage?) {
        self.avAsset = avAsset
        self.videoComposition = videoComposition
        self._volume = volume
        self.thumbnail = thumbnail
        
        print("====>", volume)
    }
    
    init(assetURL: URL,
         videoComposition: AVVideoComposition?,
         thumbnail: UIImage?,
         volume: Binding<Float>) {
        self.init(avAsset: AVAsset(url: assetURL),
                  videoComposition: videoComposition,
                  volume: volume,
                  thumbnail: thumbnail)
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
    }
}

private struct PlayerView: UIViewRepresentable {
    @Binding private var isPlaying: Bool
    @Binding private var volume: Float
    private let asset: AVAsset
    private var videoComposition: AVVideoComposition?
    private let cornerRadius: CGFloat?
    
    init(asset: AVAsset,
         videoComposition: AVVideoComposition?,
         isPlaying: Binding<Bool>, volume: Binding<Float>, cornerRadius: CGFloat?) {
        self.asset = asset
        self.videoComposition = videoComposition
        self._isPlaying = isPlaying
        self._volume = volume
        self.cornerRadius = cornerRadius
    }
    
    func makeUIView(context: Context) -> _PlayerView {
        let view = _PlayerView()
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius ?? 0.0
        view.playerLayer.cornerRadius = cornerRadius ?? 0.0
        return view
    }
    
    static func dismantleUIView(_ uiView: _PlayerView, coordinator: ()) {
        uiView.setPlaying(false)
        uiView.removeFromSuperview()
    }
    
    func updateUIView(_ uiView: _PlayerView, context: Context) {
        uiView
            .replaceIfNeeded(with: asset)
            .setVolume(volume)
            .setVideoComposition(videoComposition: videoComposition)
            .setPlaying(isPlaying)
    }
}

final class _PlayerView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }
    
    var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }
    
    deinit {
        Log.d("❌ Deinit: _PlayerView")
    }
    
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    func replaceIfNeeded(with asset: AVAsset) -> Self {
        if player?.currentItem?.asset != asset {
            return replaceCurrentItem(with: asset)
        }
        
        return self
    }
    
    func replaceCurrentItem(with asset: AVAsset) -> Self {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        return setItemToLoop()
    }
    
    func setPlaying(_ isPlaying: Bool){
        if isPlaying {
            player?.play()
        } else {
            player?.pause()
        }
    }
    
    func setVideoComposition(videoComposition: AVVideoComposition?) -> Self {
        player?.currentItem?.videoComposition = videoComposition
        
        if player?.currentItem?.videoComposition != nil {
            playerLayer.pixelBufferAttributes = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        } else {
            playerLayer.pixelBufferAttributes = nil
        }
        
        return self
    }
    
    func setVolume(_ volume: Float) -> Self {
        player?.volume = volume
        return self
    }
    
    // MARK: Loop mechanism
    private func setItemToLoop() -> Self {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        return self
    }
    
    @objc private func playerItemDidPlayToEndTime() {
        player?.seek(to: .zero)
        player?.play()
    }
}
