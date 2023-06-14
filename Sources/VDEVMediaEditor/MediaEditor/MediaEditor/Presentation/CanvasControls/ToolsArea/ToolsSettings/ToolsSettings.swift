//
//  ToolsSettings.swift
//  
//
//  Created by Vladislav Gushin on 05.05.2023.
//

import SwiftUI
import Combine

final class ToolsSettingsViewModel: ObservableObject {
    @Published var variants: [MediaResolution] = []
    @Published var canvasVM: CanvasEditorViewModel
    @Published var current: MediaResolution = .fullHD
    @Published var needAutoEnhance: Bool = false
    
    @Injected private var resultSettings: VDEVMediaEditorResultSettings
    
    private var storage: Set<AnyCancellable> = Set()
    
    init(vm: CanvasEditorViewModel) {
        self.canvasVM = vm
        current = vm.resultResolution
        needAutoEnhance = resultSettings.needAutoEnhance.value
        
        canvasVM
            .$resultResolution
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.current = value
            }
            .store(in: &storage)
        
        makeVariants()
        
        $needAutoEnhance
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                if self.needAutoEnhance != self.resultSettings.needAutoEnhance.value {
                    self.resultSettings.needAutoEnhance.send($0)
                    makeHaptics()
                }
            }
            .store(in: &storage)
    }
    
    func makeVariants() {
        // Не разрешать работать с видео в формате 8к 4к
        canvasVM.data.$layers.flatMap { result -> AnyPublisher<Bool, Never> in result.elements.withVideoAsync() }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                
                if value {
                    switch self.canvasVM.resultResolution {
                    case .ultraHD8k, .ultraHD4k: self.canvasVM.set(resolution: .fullHD)
                    default: break
                    }
                    self.variants = [.sd, .hd, .fullHD].filter { $0 != self.canvasVM.resultResolution }
                    self.variants = [self.canvasVM.resultResolution] + self.variants
                } else {
                    self.variants = [.sd, .hd, .fullHD, .ultraHD4k, .ultraHD8k].filter { $0 != self.canvasVM.resultResolution }
                    self.variants = [self.canvasVM.resultResolution] + self.variants
                }
            }
            .store(in: &storage)
    }
    
    func set(_ result: MediaResolution) {
        makeHaptics()
        canvasVM.set(resolution: result)
    }
    
    func set(_ needAutoEnhance: Bool) {
        resultSettings
            .needAutoEnhance
            .send(needAutoEnhance)
    }
}

struct ToolsSettings: View {
    @StateObject private var vm: ToolsSettingsViewModel
    @Injected private var strings: VDEVMediaEditorStrings
    @State private var showTutorials: Bool = false
    
    init(vm: CanvasEditorViewModel) {
        _vm = .init(wrappedValue: .init(vm: vm))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("MATERIALS")
                .font(AppFonts.elmaTrioRegular(18))
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                makeHaptics()
                showTutorials = true
            } label: {
                Text("SHOW TUTORIALS")
                    .font(AppFonts.elmaTrioRegular(15))
                    .foregroundColor(AppColors.whiteWithOpacity)
            }
            .buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity,
                   alignment: .leading)
            .frame(minHeight: 32)
            .background {
                InvisibleTapZoneView { showTutorials = true }
            }
            
            Divider().background(AppColors.whiteWithOpacity)
            
            Text(strings.quality)
                .font(AppFonts.elmaTrioRegular(18))
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Toggle(strings.questionQualityImage, isOn: $vm.needAutoEnhance)
                .toggleStyle(iOSCheckboxToggleStyle())
                .font(AppFonts.elmaTrioRegular(15))
                .foregroundColor(AppColors.whiteWithOpacity)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
            
            Divider().background(AppColors.whiteWithOpacity)
            
            Text(strings.resolution)
                .font(AppFonts.elmaTrioRegular(18))
                .foregroundColor(AppColors.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
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
        .fullScreenCover(isPresented: $showTutorials) {
            TutorialsTableView()
                .background { BlurView(style: .systemChromeMaterialDark) }
        }
    }
}
