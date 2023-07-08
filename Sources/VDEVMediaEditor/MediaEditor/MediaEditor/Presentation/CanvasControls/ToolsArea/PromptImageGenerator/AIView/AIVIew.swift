//
//  AIVIew.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import SwiftUI

@available(iOS 16.2, *)
struct AIVIew: View {
    @StateObject private var vm: AIVM
    
    init(url: URL) {
        self._vm = .init(wrappedValue: .init(url: url))
    }
    
    var body: some View {
        ZStack {
            switch vm.state {
            case let .error(error): EmptyView()
            case .loadCoreML: EmptyView()
            case .notStarted: EmptyView()
            case .ready: EmptyView()
            }
        }.viewDidLoad {
            vm.loadAll()
        }
    }
}
