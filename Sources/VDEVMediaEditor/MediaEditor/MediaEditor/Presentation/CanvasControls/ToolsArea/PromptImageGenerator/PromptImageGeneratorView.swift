//
//  PromptImageGeneratorView.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import SwiftUI
import Combine

@available(iOS 16.2, *)
struct PromptImageGeneratorView: View {
    @StateObject private var vm: PromptImageGeneratorViewModel = .init()
    var body: some View {
        switch vm.state {
        case .initial:
            InitialStateView {
                vm.loadCoreML()
            }
        case .notAvailable:
            NotAvailableStateView()
        case let .downloading(progress):
            LoadingStateView(progress: progress) {
                vm.cancelLoadCoreML()
            }
        case let .error(error):
            ErrorStateView(error: error) {
                vm.loadCoreML()
            }
        case .uncompressing:
            UncompressingStateView()
        case let .ready(url): AIRootView(url: url)
        }
    }
}

@available(iOS 16.2, *)
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
