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
        case .loading:
            VStack {
                Spacer()
                ActivityIndicator(isAnimating: true,
                                  style: .medium,
                                  color: .white)
                Spacer()
            }
        case .notStarted:
            InitialStateView(error: nil) { message in
                vm.submit(message: message)
            }
        case .error(let error):
            InitialStateView(error: error) { message in
                vm.submit(message: message)
            }
        case .inProgress(progress: let progress):
            VStack {
                Spacer()
                ProgressView("Proccessing...", value: Double(progress), total: 100).padding()
                Spacer()
            }
        }
    }
}

private extension PromptImageGeneratorView {
    struct InitialStateView: View {
        @State private var message: String =
         """
         maze, Narrow steep staircase, Old Building, Floating buildings, Urban, City rain, art by miyazaki and Ian McQue and Akihiko Yoshida and Katsuya Terada, colorful, trending on artstation, gorgeous, ultra-detailed, realistic, 8k, octane render, hyper detailed, cinematic
         """
        @FocusState private var messageIsFocused: Bool
        private let error: Error?
        private let onSubmit: (String) -> Void
        
        init(error: Error?, onSubmit: @escaping (String) -> Void) {
            self.error = error
            self.onSubmit = onSubmit
        }
        
        var body: some View {
            VStack(spacing: 12) {
                error.map {
                    Text($0.localizedDescription).foregroundColor(AppColors.redWithOpacity)
                }
                
                VStack {
                    TextEditor(text: $message)
                        .focused($messageIsFocused)
                        .transparentScrolling()
                        .lineSpacing(10)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .padding()
                    
                }.overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.yellow, lineWidth: 5)
                )
                .padding(.horizontal)
                .viewDidLoad {
                    messageIsFocused = true
                }
                
                Button("Submit") {
                    messageIsFocused = false
                    onSubmit(message)
                }
                .disabled(message.isEmpty)
                
                Spacer()
            }
        }
    }
    
    struct NotAvailableStateView: View {
        var body: some View {
            Text("Сервис не доступен")
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
