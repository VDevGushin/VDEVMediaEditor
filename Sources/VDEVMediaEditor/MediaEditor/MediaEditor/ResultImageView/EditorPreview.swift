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
    func editorPreview(with contentPreview: Binding<EditorPreview.Content?>) -> some View {
        modifier(EditorPreviewModifier(model: contentPreview))
    }
}

struct EditorPreviewModifier: ViewModifier {
    
    @Binding private var model: EditorPreview.Content?
    
    init(model: Binding<EditorPreview.Content?>) {
        self._model = model
    }
    
    func body(content: Content) -> some View {
        content
            .fullScreenCover(item: $model, onDismiss: {
                model = nil
            }, content: {model in
                EditorPreview(model: model,
                              challengeTitle: "")
            })
    }
}

// MARK: - Model
extension EditorPreview {
    enum Content: Identifiable {
        case video(URL)
        case image(URL)
        
        var id: String {
            switch self {
            case .image(let url): return url.absoluteString
            case .video(let url): return url.absoluteString
            }
        }
        
        var url: URL {
            switch self {
            case .image(let url): return url
            case .video(let url): return url
            }
        }
    }
}

// MARK: - View
struct EditorPreview: View {
    @Environment(\.dismiss) private var dismiss
    @Injected private var images: VDEVImageConfig
   
    @State var model: Content
    @State var challengeTitle: String
    @State var needShare: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                CloseButton {
                    needShare = false
                    dismiss()
                }.padding()
            }
            
            Group {
                switch model {
                case .video(let url):
                    ResultVideoPlayer(assetURL: url,
                                      videoComposition: nil,
                                      volume: 0,
                                      thumbnail: nil,
                                      cornerRadius: 15)
                    .clipShape(RoundedCorner(radius: 15))
                case .image(let url):
                    AsyncImageView(url: url) { img in
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
                
                SeeAnswersButton(number: 345) {
                    
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
    }
}
