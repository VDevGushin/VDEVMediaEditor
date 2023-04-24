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
    @Injected private var output: VDEVMediaEditorOut
   
    @State var model: Content
    @State var challengeTitle: String
    @State var needShare: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                CloseButton {
                    haptics(.light)
                    needShare = false
                    dismiss()
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
                    vm.onPublish(output: model.model)
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
