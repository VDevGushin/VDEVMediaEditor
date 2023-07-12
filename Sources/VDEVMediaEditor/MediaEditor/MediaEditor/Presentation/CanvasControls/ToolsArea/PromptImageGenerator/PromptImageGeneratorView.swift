//
//  PromptImageGeneratorView.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import SwiftUI
import Combine
import UIKit

struct PromptImageGeneratorView: View {
    @StateObject private var vm: PromptImageGeneratorViewModel
    
    init(onComplete: @escaping (UIImage) -> Void) {
        self._vm = .init(wrappedValue: .init(onComplete: onComplete))
    }
    
    var body: some View {
        switch vm.state {
        case.inaccessible: EmptyView()
        case .loading:
            ProgressView(progress: 0, progressImage: vm.progressImage)
        case .notStarted:
            InitialStateView(message: $vm.messageToSubmit,
                             canSubmit: $vm.canSubmit,
                             error: nil) { message in
                vm.submit(message: message)
            } onRandomMessage: {
                vm.randomMessage()
            }
        case .error(let error):
            InitialStateView(message: $vm.messageToSubmit,
                             canSubmit: $vm.canSubmit,
                             error: error) { message in
                vm.submit(message: message)
            } onRandomMessage: {
                vm.randomMessage()
            }
        case .inProgress(progress: let progress):
            ProgressView(progress: progress, progressImage: vm.progressImage)
        }
    }
}

private extension PromptImageGeneratorView {
    struct ProgressView: View {
        let progress: Int
        var progressImage: UIImage?
        var body: some View {
            ZStack {
                progressImage.map { image in
                    Rectangle()
                        .fill(.red)
                        .overlay {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        }
                        .cornerRadius(10)
                        .blur(radius: 3)
                        .padding()
                }
                
                VStack(alignment: .center, spacing: 16) {
                    Spacer()
                    ActivityIndicator(isAnimating: true,
                                      style: .large,
                                      color: AppColors.white.uiColor)
                    
                    Text("\(progress)%")
                        .font(AppFonts.gramatika(size: 16))
                        .foregroundColor(AppColors.white)
                    
                    Spacer()
                }
            }
            .withParallaxCardEffect()
        }
    }
    
    struct InitialStateView: View {
        @Injected private var strings: VDEVMediaEditorStrings
        @Binding private var message: String
        @Binding private var canSubmit: Bool
        @FocusState private var messageIsFocused: Bool
        private let error: Error?
        private let onSubmit: (String) -> Void
        private let onRandomMessage: () -> Void
   
        init(message: Binding<String>,
             canSubmit: Binding<Bool>,
             error: Error?,
             onSubmit: @escaping (String) -> Void,
             onRandomMessage: @escaping () -> Void) {
            self.error = error
            self._message = message
            self._canSubmit = canSubmit
            self.onSubmit = onSubmit
            self.onRandomMessage = onRandomMessage
        }
        
        var body: some View {
            VStack(spacing: 12) {
                error.map {
                    Text($0.localizedDescription)
                        .font(AppFonts.gramatika(size: 12))
                        .foregroundColor(AppColors.redWithOpacity)
                }
                
                 VStack {
                    TextEditor(text: $message)
                        .multilineTextAlignment(.leading)
                        .focused($messageIsFocused)
                        .transparentScrolling()
                        .lineSpacing(10)
                        .autocapitalization(.none)
                        .disableAutocorrection(false)
                        .padding()
                        .viewDidLoad {
                            messageIsFocused = true
                        }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(AppColors.whiteWithOpacity, lineWidth: 3)
                )
                .padding(.horizontal)
               
                
                HStack {
                    TextButton(title: strings.random) {
                        onRandomMessage()
                    }
                    TextButton(title: strings.submit) {
                        messageIsFocused = false
                        onSubmit(message)
                    }
                    .disabled(!canSubmit)
                    .opacity(canSubmit ? 1.0 : 0.3)
                }
                
                Spacer()
            }
        }
    }
}

private extension View {
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
