//
//  PromptImageGeneratorView.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import SwiftUI
import Combine

@available(iOS 16.2, *)
final class PromptImageGeneratorViewModel: ObservableObject {
    @Published private(set) var state: VMState = .initial
    @Injected private var loader: PromptImageGeneratorMLService
    private var operation: AnyCancellable?
    init() {
        operation = loader
            .mlSate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                switch value {
                case let .ready(url):
                    self.state = .ready(url)
                case let .downloading(progress):
                    self.state = .downloading(progress)
                case .notStarted:
                    self.state = .initial
                case let .failed(error):
                    self.state = .error(error)
                case .notAvailable:
                    self.state = .notAvailable
                case .uncompressing:
                    self.state = .uncompressing
                }
            }
    }
    
    func loadCoreML() {
        loader.load()
    }
    
    func cancelLoadCoreML() {
        loader.cancelLoad()
    }
}

@available(iOS 16.2, *)
extension PromptImageGeneratorViewModel {
    enum VMState {
        case downloading(Double)
        case ready(URL)
        case initial
        case notAvailable
        case error(Error)
        case uncompressing
    }
}

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
        case let .ready(url): AIVIew(url: url)
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
            ProgressView("Downloading…", value: progress, total: 1).padding()
            Button("Cancel") {
                action()
            }
        }
    }
    
    struct ErrorStateView: View {
        let error: Error
        let action: () -> Void
        var body: some View {
            Text("Ошибка...")
            Button("Retry") {
                action()
            }
        }
    }
    
    struct UncompressingStateView: View {
        var body: some View {
            Text("Uncompressing...")
        }
    }
}
