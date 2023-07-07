//
//  PromptImageGeneratorView.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import SwiftUI
import Combine

final class PromptImageGeneratorViewModel: ObservableObject {
    @Published private(set) var state: VMState = .initial
    private let loader: PromptImageGeneratorMLLoader?
    private var operation: AnyCancellable?
    
    init() {
        loader = DIContainer
            .shared
            .resolveOptional(PromptImageGeneratorMLLoader.self)
        
        guard let loader = loader else {
            state = .notAvailable
            return
        }
    
        operation = loader
            .mlSate
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .ready:
                    self.state = .ready
                case .loading:
                    self.state = .loading
                case .initial:
                    self.state = .initial
                }
            }
    }
    
    func loadCoreML() {
        loader?.load()
    }
}

extension PromptImageGeneratorViewModel {
    enum VMState {
        case loading
        case ready
        case initial
        case notAvailable
    }
}

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
        case .loading:
            LoadingStateView()
        case .ready: EmptyView()
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
        var body: some View {
            Text("Загрузка...")
        }
    }
}
