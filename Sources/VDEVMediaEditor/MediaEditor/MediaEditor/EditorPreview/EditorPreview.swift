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
    func editorPreview(with contentPreview: Binding<EditorPreview.Content?>,
                       onPublish: @escaping (CombinerOutput) -> Void,
                       onClose: @escaping () -> Void) -> some View {
        
        modifier(EditorPreviewModifier(model: contentPreview,
                                       onPublish: onPublish,
                                       onClose: onClose))
    }
}

struct EditorPreviewModifier: ViewModifier {
    @Injected private var images: VDEVImageConfig
    @Binding private var model: EditorPreview.Content?
    @State private var showResult = false
    private let onPublish: (CombinerOutput) -> Void
    private let onClose: () -> Void
    @Namespace var animation
    
    init(model: Binding<EditorPreview.Content?>,
         onPublish: @escaping (CombinerOutput) -> Void,
         onClose: @escaping () -> Void) {
        self._model = model
        self.onClose = onClose
        self.onPublish = onPublish
    }
    
    func body(content: Content) -> some View {
        ZStack {
            if !showResult {
                AppColors.black
                    .matchedGeometryEffect(
                        id: "EditorArea",
                        in: animation,
                        anchor: .center,
                        isSource: true
                    )
            }
            
            content

            if showResult {
                model.map {
                    EditorPreview(model: $0,
                                  animation: animation,
                                  onPublish: onPublish,
                                  onClose: onClose)
                }
            }
        }
        .onChange(of: model) { value in
            withAnimation(.interactiveSpring()) {
                showResult = value != nil
            }
        }
    }
}

// MARK: - View
struct EditorPreview: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var vm: CanvasEditorViewModel
    
    @Injected private var images: VDEVImageConfig
    @Injected private var settings: VDEVMediaEditorSettings
   
    @State var model: Content
    var animation: Namespace.ID
    @State var challengeTitle: String = ""
    @State var needShare: Bool = false
    
    //let animation: Namespace.ID
    
    var onPublish: (CombinerOutput) -> Void
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
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
            
            Spacer()
            
            switch model.type {
            case .video:
                IsometricVideo(model: model)
                    .aspectRatio(model.aspect, contentMode: .fit)
                    .padding(.horizontal, 15)
                    .withParallaxCardEffect()
                    .matchedGeometryEffect(
                        id: "EditorArea",
                        in: animation
                    )
            case .image:
                AsyncImageView(url: model.url) { img in
                    IsometricImage(image: img)
                } placeholder: {
                    LoadingView(inProgress: true, style: .medium)
                }
                .aspectRatio(model.aspect, contentMode: .fit)
                .padding(.horizontal, 15)
                .withParallaxCardEffect()
                .matchedGeometryEffect(
                    id: "EditorArea",
                    in: animation
                )
            }
            
            Spacer()
            
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
        }
        .background {
            TransparentBlurView(removeAllFilters: false)
            .edgesIgnoringSafeArea(.all)
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
        .onAppear {
            challengeTitle = settings.title
        }
    }
}

// MARK: - Model
extension EditorPreview {
    struct Content: Identifiable, Equatable {
        enum ResultType {
            case video
            case image
        }
        
        let type: ResultType
        let model: CombinerOutput
        let aspect: CGFloat
        
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
        
        var id: String { model.url.absoluteString }
        var url: URL { model.url }
        var cover: URL { model.cover }
        
        public static func == (lhs: Content, rhs: Content) -> Bool {
            lhs.id == rhs.id
        }
    }
}
