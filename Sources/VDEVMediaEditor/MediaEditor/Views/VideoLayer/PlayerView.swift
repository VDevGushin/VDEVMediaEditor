//
//  PlayerView.swift
//  
//
//  Created by Vladislav Gushin on 22.09.2023.
//

import AVKit
import SwiftUI

struct PlayerView: UIViewRepresentable {
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
        if volume != player?.volume {
            player?.volume = volume
        }
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
