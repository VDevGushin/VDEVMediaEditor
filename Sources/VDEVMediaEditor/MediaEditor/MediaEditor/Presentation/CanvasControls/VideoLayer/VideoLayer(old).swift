////
////  PlayerWithLayer.swift
////  CameraWork
////
////  Created by Vladislav Gushin on 01.02.2023.
////
//
//import AVFoundation
//import SwiftUI
//import UIKit
//
//@MainActor
//final class VideoLayerViewMode: ObservableObject {
//    @Published var isMuted = true
//    @Published private(set) var item: AVPlayerItem
//    @Published private(set) var thumbnail: UIImage?
//    @Published private(set) var canShow = false
//    @Published private(set) var ratio: CGFloat = 1
//
//
//    init(url: URL, thumbnail: UIImage?) {
//        self.item = .init(url: url)
//        self.thumbnail = thumbnail
//
//        item.asset.getRatio{ [weak self] ratio in
//            guard let self = self else { return }
//            guard let ratio = ratio else { return }
//            DispatchQueue.main.async {
//                self.ratio = ratio
//                self.canShow = true
//            }
//        }
//    }
//}
//
//struct VideoLayerView: View {
//    @Environment(\.guideLinesColor) private var guideLinesColor
//
//    @StateObject private var vm: VideoLayerViewMode
//
//    private(set) var videoComposition: AVVideoComposition?
//
//    init(url: URL, videoComposition: AVVideoComposition?, thumbnail: UIImage?) {
//        self._vm = .init(wrappedValue: .init(url: url,
//                                             thumbnail: thumbnail))
//        self.videoComposition = videoComposition
//    }
//
//    var body: some View {
//        if vm.canShow {
//            UIVideoPlayer(item: vm.item,
//                          videoComposition: videoComposition,
//                          isMuted: $vm.isMuted)
//            .aspectRatio(vm.ratio, contentMode: .fit)
//            .background(
//                vm.thumbnail.map {
//                    Image(uiImage: $0)
//                        .resizable()
//                        .aspectRatio(vm.ratio, contentMode: .fit)
//                }
//            )
//            .background(guideLinesColor.opacity(0.1))
//        } else {
//            LoadingView(inProgress: true, style: .large,  color: .init(guideLinesColor))
//            .aspectRatio(vm.ratio, contentMode: .fit)
//            .background(guideLinesColor.opacity(0.1))
//        }
//    }
//}
//
//struct UIVideoPlayer: UIViewRepresentable {
//    let item: AVPlayerItem
//    let videoComposition: AVVideoComposition?
//
//    @Binding var isMuted: Bool
//
//    func makeUIView(context: Context) -> AVLayerView {
//        let view = AVLayerView()
//        context.coordinator
//            .setupPlayer(view.player)
//            .setCurrent(item: item)
//            .play(isMuted)
//        view.setVideoComposition(videoComposition: videoComposition)
//        return view
//    }
//
//    func updateUIView(_ uiView: AVLayerView, context: Context) {
//        uiView
//            .setVideoComposition(videoComposition: videoComposition)
//
//        context
//            .coordinator
//            .play(isMuted)
//    }
//
//    static func dismantleUIView(_ uiView: AVLayerView, coordinator: Coordinator) { }
//
//    func makeCoordinator() -> Coordinator { Coordinator(self) }
//
//    final class Coordinator: NSObject {
//        private let parent: UIVideoPlayer
//        private var item: AVPlayerItem?
//        private var player: AVPlayer?
//
//        init(_ parent: UIVideoPlayer) {
//            self.parent = parent
//            super.init()
//            NotificationCenter.default.addObserver(self,
//                                                   selector: #selector(playerItemDidReachEnd(notification:)),
//                                                   name: .AVPlayerItemDidPlayToEndTime,
//                                                   object: player?.currentItem)
//        }
//
//        deinit {
//            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
//            Log.d("❌ Deinit: UIVideoPlayer.Coordinator")
//        }
//
//        @discardableResult
//        func setupPlayer(_ player: AVPlayer) -> Self {
//            if !(self.player === player) {
//                self.player = player
//            }
//            return self
//        }
//
//        @discardableResult
//        func setCurrent(item: AVPlayerItem) -> Self {
//            if player?.currentItem == nil {
//                self.item = item
//                player?.replaceCurrentItem(with: item)
//            }
//            return self
//        }
//
//        @discardableResult
//        func play(_ isMuted: Bool = true) -> Self {
//            player?.isMuted = isMuted
//            player?.play()
//            return self
//        }
//
//        private func pause() {
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                if !self.parent.isMuted { self.parent.isMuted = true }
//            }
//            player?.pause()
//        }
//
//        @objc private func playerItemDidReachEnd(notification: Notification) {
//            if let item = notification.object as? AVPlayerItem,
//               player?.currentItem == item {
//
//                item.seek(to: CMTime.zero) { [weak self] value in
//                    guard let self = self else { return }
//                    if value {
//                        self.play(self.parent.isMuted)
//                    }
//                }
//            }
//        }
//    }
//}
//
//final class AVLayerView: UIView {
//    var playerLayer: AVPlayerLayer!
//    var player: AVPlayer!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        player?.pause()
//        playerLayer?.removeFromSuperlayer()
//        player = nil
//        playerLayer = nil
//
//        self.player = .init()
//        self.playerLayer = .init()
//        playerLayer.player = player
//        playerLayer.videoGravity = .resizeAspectFill
//        layer.addSublayer(playerLayer)
//    }
//
//    required init?(coder: NSCoder) { fatalError() }
//
//    deinit {
//        player?.pause()
//        playerLayer?.removeFromSuperlayer()
//        player = nil
//        playerLayer = nil
//        Log.d("❌ Deinit: AVLayerView")
//    }
//
//    func setVideoComposition(videoComposition: AVVideoComposition?) {
//        player?.currentItem?.videoComposition = videoComposition
//
//        if videoComposition != nil {
//            playerLayer?.pixelBufferAttributes = [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
//        } else {
//            playerLayer?.pixelBufferAttributes = nil
//        }
//    }
//
//    func setPlaying(_ isPlaying: Bool) {
//        if isPlaying {
//            player?.play()
//        } else {
//            player?.pause()
//        }
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        playerLayer.frame = bounds
//    }
//}
