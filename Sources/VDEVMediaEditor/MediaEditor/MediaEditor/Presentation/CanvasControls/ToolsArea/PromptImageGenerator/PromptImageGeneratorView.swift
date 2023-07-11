//
//  PromptImageGeneratorView.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import SwiftUI
import Combine

struct PromptImageGeneratorView: View {
    @StateObject private var vm: PromptImageGeneratorViewModel = .init()
    private let onComplete: (UIImage) -> Void
    
    init(onComplete: @escaping (UIImage) -> Void) {
        self.onComplete = onComplete
    }
    
    var body: some View {
        Rectangle().fill(.green)
            .viewDidLoad {
                vm.submit()
            }
    }
}

private extension PromptImageGeneratorView {
    struct InitialStateView: View {
        let action: () -> Void
        var body: some View {
            Button("Скачать") {
                action()
            }
        }
    }
    
    struct NotAvailableStateView: View {
        var body: some View {
            Text("Сервис не доступен")
        }
    }
    
    struct LoadingStateView: View {
        let progress: Double
        let action: () -> Void
        var body: some View {
            VStack {
                ProgressView("Downloading…", value: progress, total: 1).padding()
                Button("Cancel") {
                    action()
                }
            }
        }
    }
    
    struct ErrorStateView: View {
        let error: Error
        let action: () -> Void
        var body: some View {
            VStack {
                Text("Ошибка...")
                Button("Retry") {
                    action()
                }
            }
        }
    }
    
    struct UncompressingStateView: View {
        var body: some View {
            Text("Uncompressing...")
        }
    }
}
