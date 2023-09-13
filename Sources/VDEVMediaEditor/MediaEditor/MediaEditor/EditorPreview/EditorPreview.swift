//
//  EditorPreview.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import SwiftUI
import AVFoundation


// MARK: - Modifier

extension View {
    func editorPreview(with contentPreview: Binding<PreviewContent?>,
                       cornerRadius: CGFloat,
                       onPublish: @escaping (CombinerOutput) -> Void,
                       onClose: @escaping () -> Void) -> some View {
        modifier(EditorPreviewModifier(
            model: contentPreview,
            cornerRadius: cornerRadius,
            onPublish: onPublish,
            onClose: onClose
        ))
    }
}

private struct EditorPreviewModifier: ViewModifier {
    @Injected private var images: VDEVImageConfig
    @Binding private var model: PreviewContent?
    private let cornerRadius: CGFloat
    @State private var showResult = false
    private let onPublish: (CombinerOutput) -> Void
    private let onClose: () -> Void
    
    init(model: Binding<PreviewContent?>,
         cornerRadius: CGFloat,
         onPublish: @escaping (CombinerOutput) -> Void,
         onClose: @escaping () -> Void) {
        self._model = model
        self.cornerRadius = cornerRadius
        self.onClose = onClose
        self.onPublish = onPublish
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .scaleEffect(showResult ? 1.5 : 1.0, anchor: .center)
                .blur(radius: showResult ? 3 : 0)
                .clipShape(RoundedCorner(radius: cornerRadius))
            
            model.map {
                EditorPreview(model: $0,
                              onPublish: onPublish,
                              onClose: onClose)
                .opacity(showResult ? 1.0 : 0.0)
                .scaleEffect(showResult ? 1.0 : 0.5, anchor: .center)
                .blur(radius: showResult ? 0 : 15)
                .clipShape(RoundedCorner(radius: cornerRadius))
            }
        }
        .onChange(of: model) { value in
            withAnimation(.easeInOut(duration: 0.2)) {
                showResult = value != nil
            }
        }
    }
}

// MARK: - View
private struct EditorPreview: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: CanvasEditorViewModel
    @Injected private var images: VDEVImageConfig
    @Injected private var settings: VDEVMediaEditorSettings
    
    @State var model: PreviewContent
    @State private var challengeTitle: String = ""
    @State private var needShare: Bool = false
    @State private var showAnimation: Bool = false
    
    var onPublish: (CombinerOutput) -> Void
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            if showAnimation {
                HStack {
                    Text(challengeTitle)
                        .font(AppFonts.elmaTrioRegular(12))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                    
                    CloseButton {
                        haptics(.light)
                        needShare = false
                        onClose()
                    }
                }
                .padding()
                .transition(.topTransition)
            }
            
            Spacer()
            
            switch model.type {
            case .video:
                IsometricVideo(model: model)
                    .aspectRatio(model.aspect, contentMode: .fit)
                    .padding(.horizontal, 15)
                    .withParallaxCardEffect()
            case .image:
                AsyncImageView(url: model.url) { img in
                    IsometricImage(image: img)
                } placeholder: {
                    LoadingView(inProgress: true)
                }
                .aspectRatio(model.aspect, contentMode: .fit)
                .padding(.horizontal, 15)
                .withParallaxCardEffect()
            }
            
            Spacer()
            
            if showAnimation {
                HStack {
                    ShareButton {
                        haptics(.light)
                        needShare = true
                    }
                    
                    Spacer()
                    
                    if settings.isInternalModule {
                        PublishButton {
                            haptics(.light)
                            needShare = false
                            onPublish(model.model)
                        }
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 12)
                .transition(.bottomTransition)
            }
        }
        .background($showAnimation) {
            TransparentBlurView(removeAllFilters: false)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
        }
        .onAppear {
            challengeTitle = settings.title
        }
        .viewDidLoad {
            withAnimation(.easeInOut) {
                showAnimation = true
            }
        }
        .sheet(isPresented: $needShare, onDismiss: {
            needShare = false
        }, content: {
            ShareSheetView(activityItems: [model.url],
                           applicationActivities: [InstagramStoriesActivity()]) { _, _, _, error in
                if let error = error {
                    Log.e(error.localizedDescription)
                }
                needShare = false
            }
        })
    }
}

struct PreviewContent: Identifiable, Equatable {
    enum ResultType { case video, image }
    let type: ResultType
    let model: CombinerOutput
    let aspect: CGFloat
    var id: String { model.url.absoluteString }
    var url: URL { model.url }
    var cover: URL { model.cover }
    
    init(model: CombinerOutput) {
        self.model = model
        self.aspect = model.aspect
        if model.url.absoluteString.lowercased().hasSuffix("mov") ||
            model.url.absoluteString.lowercased().hasSuffix("mp4"){
            self.type = .video
        } else {
            self.type = .image
        }
    }
    
    public static func == (lhs: PreviewContent, rhs: PreviewContent) -> Bool {
        lhs.id == rhs.id
    }
}
