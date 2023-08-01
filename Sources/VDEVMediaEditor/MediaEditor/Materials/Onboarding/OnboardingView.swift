//
//  OnboardingView.swift
//  
//
//  Created by Vladislav Gushin on 18.06.2023.
//

import SwiftUI
import Combine

struct OnboardingView: View {
    @Environment(\.presentationManager) var presentationManager

    @StateObject var storyTimer: StoryTimer = StoryTimer(interval: 10.0)

    @GestureState private var isDetectingPress = false

    @State private var changeNews = false
    
    private let data: [OnboardingSourceModel]
    
    init() {
        data = onboardingSource
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                BlurView(style: .systemChromeMaterialDark)
                
                AsyncImageView(url: URL.getLocal(fileName: "BackgorundOnb",
                                                 ofType: "jpg")!) {
                    Image(uiImage: $0)
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    LoadingView(inProgress: true)
                }
                .edgesIgnoringSafeArea(.all)
                .blur(radius: 5, opaque: false)
                .frame(width: geometry.size.width,
                       height: nil, alignment: .center)
                .overlay {
                    AppColors.blackWithOpacity
                }
                .animation(.none, value: storyTimer.progress)
                .id("image" + data[Int(storyTimer.progress)].title)
                
                Overlay()
            }
            .onAppear { storyTimer.start(items: data.count) }
            .onDisappear { storyTimer.cancel() }
        }
        .overlay(alignment: .topTrailing) {
            CloseButton {
                storyTimer.cancel()
                presentationManager.dismiss()
            }
        }
    }

    @ViewBuilder
    private func Overlay() -> some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.6).ignoresSafeArea()

            VStack {
                HStack(alignment: .center, spacing: 4) {
                    ForEach(data.indices, id: \.self) { index in

                        let progress = min(max((CGFloat(storyTimer.progress) - CGFloat(index)), 0.0) , 1.0)

                        LoadingRectangle(progress: progress)
                            .frame(width: nil, height: 4, alignment: .leading)
                    }
                }
                .padding()
                .padding(.top)
                .padding(.top)

                VStack(alignment: .leading, spacing: 8) {
                    Text(data[Int(storyTimer.progress)].title)
                        .multilineTextAlignment(.leading)
                        .font(AppFonts.elmaTrioRegular(32))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(AppColors.white)
                        .transition(.opacityTransition())
                    
                    Text(data[Int(storyTimer.progress)].subtitle)
                        .multilineTextAlignment(.leading)
                        .font(AppFonts.elmaTrioRegular(20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(AppColors.whiteWithOpacity)
                        .transition(.opacityTransition())
                    
                    data[Int(storyTimer.progress)].imageURL.map {
                        AsyncImageView(url: $0) {
                            Image(uiImage: $0)
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            AppColors.blackInvisible
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .id("news" + data[Int(storyTimer.progress)].title)
            }

            HStack(alignment: .center, spacing: 0) {
                Rectangle()
                    .foregroundColor(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        storyTimer.advance(by: -1)
                    }
                Rectangle()
                    .foregroundColor(.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        storyTimer.advance(by: 1)
                    }
            }
            .gesture(LongPressGesture(minimumDuration: 0.1).sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local)).updating($isDetectingPress) { value, state, _ in
                switch value {
                case .second(true, nil): state = true
                default: break
                }
            })
        }
        .onChange(of: isDetectingPress) { value in
            isDetectingPress ? storyTimer.cancel() : storyTimer.start(items: data.count)
        }
    }
}

struct NewsWidget_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct LoadingRectangle: View {
    var progress: CGFloat

    var body: some View {
        GeometryReader {
            let size = $0.size

            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.white.opacity(0.3))
                    .cornerRadius(5)

                if progress > 0 {
                    Rectangle()
                        .frame(width: size.width * progress, alignment: .leading)
                        .foregroundColor(Color.white.opacity(0.9))
                        .cornerRadius(5)
                }
            }
        }
    }
}


class StoryTimer: ObservableObject {
    @Published var progress: Double
    private var interval: TimeInterval
    private var max: Int = 0
    private let publisher: Timer.TimerPublisher
    private var cancellable: Cancellable?


    init(interval: TimeInterval) {
        self.progress = 0
        self.interval = interval
        self.publisher = Timer.publish(every: 0.1, on: .main, in: .default)
    }

    func start(items: Int) {
        self.max = items
        self.cancellable = self.publisher
            .autoconnect()
            .sink(on: .main, object: self) { wSelf, _ in
                var newProgress = wSelf.progress + (0.1 / wSelf.interval)
                if Int(newProgress) >= wSelf.max {
                    newProgress = 0
                }
                withAnimation(newProgress == 0 ? .none : .linear) {
                    wSelf.progress = newProgress
                }
            }
    }

    func cancel() {
        self.cancellable?.cancel()
        self.cancellable = nil
    }

    func advance(by number: Int) {
        cancel()
        let newProgress = Swift.max((Int(self.progress) + number) % self.max , 0)
        self.progress = Double(newProgress)
        start(items: max)
    }
}
