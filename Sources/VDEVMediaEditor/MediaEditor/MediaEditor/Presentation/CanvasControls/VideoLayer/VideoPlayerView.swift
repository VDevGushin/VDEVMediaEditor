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
    let volume: Double
    let thumbnail: UIImage?
    let cornerRadius: CGFloat
    
    init(avAsset: AVAsset,
         videoComposition:
         AVVideoComposition?,
         volume: Double,
         thumbnail: UIImage?,
         cornerRadius: CGFloat) {
        self.avAsset = avAsset
        self.videoComposition = videoComposition
        self.volume = volume
        self.thumbnail = thumbnail
        self.cornerRadius = cornerRadius
    }
    
    init(assetURL: URL, videoComposition: AVVideoComposition?, volume: Double, thumbnail: UIImage?, cornerRadius: CGFloat) {
        self.init(avAsset: AVAsset(url: assetURL),
                  videoComposition: videoComposition,
                  volume: volume,
                  thumbnail: thumbnail,
                  cornerRadius: cornerRadius)
    }
    
    var body: some View {
        PlayerView(asset: avAsset, videoComposition: videoComposition, isPlaying: $isPlaying, volume: volume, cornerRadius: cornerRadius)
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
    @State private var isPlaying: Bool = false
    
    let videoComposition: AVVideoComposition?
    let volume: Double
    let thumbnail: UIImage?
    
    init(avAsset: AVAsset, videoComposition: AVVideoComposition?, volume: Double, thumbnail: UIImage?) {
        self.avAsset = avAsset
        self.videoComposition = videoComposition
        self.volume = volume
        self.thumbnail = thumbnail
    }
    
    init(assetURL: URL, videoComposition: AVVideoComposition?, volume: Double, thumbnail: UIImage?) {
        self.init(avAsset: AVAsset(url: assetURL),
                  videoComposition: videoComposition,
                  volume: volume,
                  thumbnail: thumbnail)
    }
    
    var body: some View {
        PlayerView(asset: avAsset, videoComposition: videoComposition, isPlaying: $isPlaying, volume: volume, cornerRadius: nil)
            .aspectRatio(avAsset.tracks(withMediaType: .video).first?.aspectRatio ?? 1,
                         contentMode: .fill)
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

private struct PlayerView: UIViewRepresentable {
    let asset: AVAsset
    var videoComposition: AVVideoComposition?
    @Binding var isPlaying: Bool
    let volume: Double
    let cornerRadius: CGFloat?
    
    func makeUIView(context: Context) -> _PlayerView {
        let view = _PlayerView()
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius ?? 0.0
        view.playerLayer.cornerRadius = cornerRadius ?? 0.0
        return view
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
    
    var player: AVPlayer? {
        get { playerLayer.player }
        set { playerLayer.player = newValue }
    }
    
    @discardableResult
    func replaceIfNeeded(with asset: AVAsset) -> Self {
        if player?.currentItem?.asset != asset {
            replaceCurrentItem(with: asset)
        }
        
        return self
    }
    
    @discardableResult
    func replaceCurrentItem(with asset: AVAsset) -> Self {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        setItemToLoop()
        return self
    }
    
    @discardableResult
    func setPlaying(_ isPlaying: Bool) -> Self {
        if isPlaying {
            player?.play()
        } else {
            player?.pause()
        }
        return self
    }
    
    @discardableResult
    func setVideoComposition(videoComposition: AVVideoComposition?) -> Self {
        player?.currentItem?.videoComposition = videoComposition
        
        if player?.currentItem?.videoComposition != nil {
            playerLayer.pixelBufferAttributes = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
        } else {
            playerLayer.pixelBufferAttributes = nil
        }
        
        return self
    }
    
    @discardableResult
    func setVolume(_ volume: Double) -> Self {
        player?.volume = Float(volume)
        return self
    }
    
    // MARK: Loop mechanism
    private func setItemToLoop() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc private func playerItemDidPlayToEndTime() {
        player?.seek(to: .zero)
        player?.play()
    }
}
