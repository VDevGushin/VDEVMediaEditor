//
//  EditorPreview.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import SwiftUI
import AVFoundation
import Resolver

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
            
            model.map {
                EditorPreview(model: $0,
                              onPublish: onPublish,
                              onClose: onClose)
                .transition(.trailingTransition)
            }
        }
    }
}

// MARK: - Model
extension EditorPreview {
    struct Content: Identifiable {
        enum ResultType {
            case video
            case image
        }
        
        let type: ResultType
        let model: CombinerOutput
        
        init(model: CombinerOutput) {
            self.model = model
            
            if model.url.absoluteString.lowercased().hasSuffix("mov") {
                self.type = .video
            } else {
                self.type = .image
            }
        }
        
        var id: String { model.url.absoluteString }
        var url: URL { model.url }
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
    
    var onPublish: (CombinerOutput) -> Void
    var onClose: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(challengeTitle)
                    .font(AppFonts.elmaTrioRegular(12))
                    .foregroundColor(AppColors.white)
                    .padding()
                
                Spacer()
                
                CloseButton {
                    haptics(.light)
                    needShare = false
                    onClose()
                }.padding()
            }
            
            Group {
                switch model.type {
                case .video:
                    ResultVideoPlayer(assetURL: model.url,
                                      videoComposition: nil,
                                      volume: 0,
                                      thumbnail: nil,
                                      cornerRadius: 15)
                    .clipShape(RoundedCorner(radius: 15))
                case .image:
                    AsyncImageView(url: model.url) { img in
                        Image(uiImage: img)
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        LoadingView(inProgress: true, style: .medium)
                    }
                    .clipShape(RoundedCorner(radius: 15))
                }
            }
            .padding(15)
            .withParallaxCardEffect()
            
            HStack {
                ShareButton {
                    haptics(.light)
                    needShare = true
                }
                
                Spacer()
                
                PublishButton {
                    haptics(.light)
                    needShare = false
                    onPublish(model.model)
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
