//
//  ToolsResolution.swift
//  
//
//  Created by Vladislav Gushin on 05.05.2023.
//

import SwiftUI


struct ToolsResolution: View {
    @Injected private var settings: VDEVMediaEditorSettings
    @EnvironmentObject private var vm: CanvasEditorViewModel
    
    private var variants: [MediaResolution] = []
    private let onSelected: (MediaResolution) -> Void
    
    init(onSelected: @escaping (MediaResolution) -> Void) {
        self.onSelected = onSelected
        let settingsResolution = settings.resolution.value
        variants = [.sd, .hd, .fullHD, .ultraHD4k, .ultraHD8k].filter { $0 != settingsResolution }
        variants = [settings.resolution.value] + variants
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<variants.count, id: \.self) { index in
                Button {
                    makeHaptics()
                    onSelected(variants[index])
                } label: {
                    Group {
                        if vm.resultResolution == variants[index] {
                            Text(variants[index].title)
                                .font(AppFonts.elmaTrioRegular(15))
                                .foregroundColor(AppColors.whiteWithOpacity)
                                .underline()
                        } else {
                            Text(variants[index].title)
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
                        makeHaptics()
                        onSelected(variants[index])
                    }
                }
            }
        }
        .cornerRadius(8)
    }
}
