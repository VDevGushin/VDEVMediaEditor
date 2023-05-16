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
    
    @Binding private var model: EditorPreview.Content?
    
    private let onPublish: (CombinerOutput) -> Void
    private let onClose: () -> Void
    
    @State private var showResult = false
    
    init(model: Binding<EditorPreview.Content?> ,
         onPublish: @escaping (CombinerOutput) -> Void,
         onClose: @escaping () -> Void) {
        self._model = model
        self.onClose = onClose
        self.onPublish = onPublish
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if showResult {
                model.map {
                    EditorPreview(model: $0,
                                  onPublish: onPublish,
                                  onClose: onClose)
                    .transition(.bottomTransition)
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
    @State var challengeTitle: String = ""
    @State var needShare: Bool = false
    
    private var cornerRadius: CGFloat { 15 }
    
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
                case .image:
                    AsyncImageView(url: model.url) { img in
                        IsometricImage(image: img)
                    } placeholder: {
                        LoadingView(inProgress: true, style: .medium)
                    }
                    .aspectRatio(model.aspect, contentMode: .fit)
                    .clipShape(RoundedCorner(radius: cornerRadius))
                    .padding(.horizontal, 15)
                    .withParallaxCardEffect()
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
            ZStack {
                AppColors.black
                
                Image(uiImage: images.common.resultGradient)
                    .resizable()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .frame(maxWidth: .infinity)
            }
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
            
            if model.url.absoluteString.lowercased().hasSuffix("mov") {
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
