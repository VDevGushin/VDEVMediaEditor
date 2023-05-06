//
//  ToolsResolution.swift
//  
//
//  Created by Vladislav Gushin on 05.05.2023.
//

import SwiftUI
import Combine

final class ToolsResolutionViewModel: ObservableObject {
    @Published var variants: [MediaResolution] = []
    @Published var canvasVM: CanvasEditorViewModel
    @Published var current: MediaResolution = .fullHD
    
    private var storage: Set<AnyCancellable> = Set()
    
    init(vm: CanvasEditorViewModel) {
        self.canvasVM = vm
        current = vm.resultResolution
        
        canvasVM
            .$resultResolution
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.current = value
            }
            .store(in: &storage)
        
        makeVariants()
    }
    
    func makeVariants() {
        // Не разрешать работать с видео в формате 8к 4к
        canvasVM.data.$layers.flatMap { result -> AnyPublisher<Bool, Never> in result.elements.withVideoAsync() }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                
                if value {
                    switch canvasVM.resultResolution {
                    case .ultraHD8k, .ultraHD4k: canvasVM.set(resolution: .fullHD)
                    default: break
                    }
                    self.variants = [.sd, .hd, .fullHD].filter { $0 != self.canvasVM.resultResolution }
                    self.variants = [canvasVM.resultResolution] + self.variants
                } else {
                    self.variants = [.sd, .hd, .fullHD, .ultraHD4k, .ultraHD8k].filter { $0 != self.canvasVM.resultResolution }
                    self.variants = [canvasVM.resultResolution] + self.variants
                }
                
            }
            .store(in: &storage)
    }
    
    func set(_ result: MediaResolution) {
        makeHaptics()
        canvasVM.set(resolution: result)
    }
}

struct ToolsResolution: View {
    @StateObject private var vm: ToolsResolutionViewModel
    
    init(vm: CanvasEditorViewModel) {
        _vm = .init(wrappedValue: .init(vm: vm))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<vm.variants.count, id: \.self) { index in
                Button {
                    vm.set(vm.variants[index])
                } label: {
                    Group {
                        if vm.current == vm.variants[index] {
                            Text(vm.variants[index].title)
                                .font(AppFonts.elmaTrioRegular(15))
                                .foregroundColor(AppColors.whiteWithOpacity)
                                .underline()
                        } else {
                            Text(vm.variants[index].title)
                                .font(AppFonts.elmaTrioRegular(15))
                                .foregroundColor(AppColors.whiteWithOpacity)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(minHeight: 32)
                .background {
                    InvisibleTapZoneView {
                        vm.set(vm.variants[index])
                    }
                }
            }
        }
        .cornerRadius(8)
    }
}
