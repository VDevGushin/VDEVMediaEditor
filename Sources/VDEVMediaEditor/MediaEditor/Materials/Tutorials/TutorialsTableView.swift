//
//  TutorialsTableView.swift
//  
//
//  Created by Vladislav Gushin on 16.06.2023.
//

import SwiftUI
import SwiftUIX
import AVKit
import Combine

final class TutorialsTableViewVM: ObservableObject {
    private(set) var videoSet = tutorialsSource
    deinit {
        Log.d("❌ Deinit: TutorialsTableViewVM")
    }
    
    func clear() {
        videoSet.removeItems()
    }
    
    func stopAll() { videoSet.stop() }
    
    func stop(for item: TutorialsModel) { videoSet.stop(for: item) }
    
    func play(for item: TutorialsModel) {
        videoSet.first { $0.id == item.id }?.play()
    }
}

struct TutorialsTableView: View {
    @Environment(\.presentationManager) var presentationManager
    @ObservedObject private var vm = TutorialsTableViewVM()
    @State private var curentModel: TutorialsModel?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(vm.videoSet) { model in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(model.title)
                            .font(AppFonts.elmaTrioRegular(16))
                            .foregroundColor(AppColors.white)
                        
                        Text(model.subtitle)
                            .font(AppFonts.elmaTrioRegular(12))
                            .foregroundColor(AppColors.whiteWithOpacity)
                        
                        Divider()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .overlay {
                        InvisibleTapZoneView {
                            vm.stopAll()
                            curentModel = model
                        }
                    }
                }
            }
        }
        .padding(.vertical)
        .overlay(alignment: .topTrailing) {
            CloseButton {
                vm.clear()
                presentationManager.dismiss()
            }
        }
        .blur(radius: curentModel != nil ? 3 : 0)
        .animation(.interactiveSpring(), value: curentModel)
        .sheet(item: $curentModel, onDismiss: {
            vm.stopAll()
        }, content: { model in
            TutorialsVideoView(model: model)
                .viewDidLoad {
                    model.play()
                }
                .background {
                    AppColors.red
                }
        })
    }
}

// MARK: - Model
final class TutorialsModel: Identifiable, ObservableObject, Equatable {
    @Published private(set) var isPlaying: Bool
    private(set) var title: String
    private(set) var subtitle: String
    private(set) var player: AVPlayer
    private(set) var videoURL: URL
    private var timeObserver: AnyCancellable?
    
    var id: String { videoURL.absoluteString }
    
    static func == (lhs: TutorialsModel, rhs: TutorialsModel) -> Bool {
        lhs.id == rhs.id
    }
    
    init(title: String, subtitle: String, videoURL: URL) {
        self.title = title
        self.subtitle = subtitle
        self.videoURL = videoURL
        self.player = .init(url: videoURL)
        self.isPlaying = false
        self.setItemToLoop()
        
        timeObserver = player.publisher(for: \.timeControlStatus)
            .sink(on: .main, object: self) { wSelf, status in
                if status == .paused {
                    wSelf.isPlaying = false
                }
                if status == .playing {
                    wSelf.isPlaying = true
                }
            }
    }
    
    deinit {
        Log.d("❌ Deinit: TutorialsTableCellModel")
    }
    
    func clear() {
        player.pause()
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
    }
    
    func stop() {
        player.pause()
        isPlaying = false
    }
    
    private func setItemToLoop() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .AVPlayerItemDidPlayToEndTime,
                                                  object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEndTime),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: player.currentItem)
    }
    
    @objc private func playerItemDidPlayToEndTime() {
        if isPlaying {
            player.seek(to: .zero)
            player.play()
        }
    }
    
    func play() {
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
}

// MARK: - Video
struct TutorialsVideoView: View {
    @ObservedObject private var model: TutorialsModel
    @Environment(\.presentationManager) var presentationManager
    
    init(model: TutorialsModel) {
        self.model = model
    }
    
    var body: some View {
        VideoPlayer(player: model.player) {
            IF(!model.isPlaying) {
                ZStack {
                    AppColors.blackWithOpacity1
                    VStack {
                        Text(model.subtitle)
                            .font(AppFonts.elmaTrioRegular(18))
                            .foregroundColor(AppColors.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top)
                        Spacer()
                    }
                }
                .transition(.opacityTransition())
            }
        }
        .clipped()
    }
}

// MARK: - Helpers
fileprivate extension Array where Element == TutorialsModel {
    func stop(for element: Element) {
        self.forEach { if $0.id != element.id { $0.stop() } }
    }
    
    func stop() { self.forEach { $0.stop() } }
    
    mutating func removeItems() {
        self.forEach { $0.clear() }
        self.removeAll()
    }
}

//        TabView(selection: $currentPage) {
//            ForEach(0..<vm.videoSet.count, id: \.self) { index in
//                TutorialsTableCell(model: vm.videoSet[index])
//                    .tabItem {
//                        Text(vm.videoSet[index].title)
//                            .font(AppFonts.elmaTrioRegular(12))
//                            .foregroundColor(AppColors.white)
//                    }
//            }
//        }
//        //.tabViewStyle(.page(indexDisplayMode: .never))
//        .onDisappear { vm.clear() }
//        .onChange(of: currentPage) { value in
//            vm.stopAll()
//        }
//        PaginationView(axis: .horizontal) {
//            ForEach(0..<vm.videoSet.count, id: \.self) { index in
//                TutorialsTableCell(model: vm.videoSet[index])
//            }
//        }
//        .initialPageIndex(0)
//        .currentPageIndex($currentPage)
//        .cyclesPages(true)
//        .pageIndicatorTintColor(AppColors.whiteWithOpacity)
//        .currentPageIndicatorTintColor(AppColors.white)
//            CocoaList(vm.videoSet) { model in
//                TutorialsTableCell(model: model, width: proxy.size.width)
//                    .onTapGesture {
//                        vm.stop(for: model)
//                        vm.play(for: model)
//                    }
//            }
//            .listStyle(.plain)
//            .listSeparatorStyle(.none)
