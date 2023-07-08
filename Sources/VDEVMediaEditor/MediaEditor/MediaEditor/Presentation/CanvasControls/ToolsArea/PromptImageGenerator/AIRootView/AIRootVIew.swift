//
//  AIRootVIew.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import SwiftUI

@available(iOS 16.2, *)
struct AIRootView: View {
    @StateObject private var vm: AIVMRoot
    
    init(url: URL) {
        self._vm = .init(wrappedValue: .init(url: url))
    }
    
    var body: some View {
        ZStack {
            switch vm.state {
            case let .error(error):
                ErrorStateView(error: error) {
                    vm.prepareML()
                }
            case .loadCoreML:
                LoadingCoreMLStateView()
            case .notStarted:
                InitialStateView()
            case let .ready(pipleLine):
                AIImageGeneratorView(pipleLine)
            }
        }.viewDidLoad {
            vm.prepareML()
        }
    }
}

@available(iOS 16.2, *)
private extension AIRootView {
    struct InitialStateView: View {
        var body: some View {
            Text("Подготовка...")
        }
    }
    
    struct LoadingCoreMLStateView: View {
        var body: some View {
            Text("Prepare ML...")
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
