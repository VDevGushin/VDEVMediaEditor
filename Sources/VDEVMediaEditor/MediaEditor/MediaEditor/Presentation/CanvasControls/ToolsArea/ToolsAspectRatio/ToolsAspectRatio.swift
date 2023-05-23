//
//  ToolsAspectRatio.swift
//  
//
//  Created by Vladislav Gushin on 05.05.2023.
//

import SwiftUI

extension View {
    @ViewBuilder
    func with(aspectRatio: CGFloat?) -> some View {
        if let aspectRatio = aspectRatio {
            self.aspectRatio(aspectRatio, contentMode: .fit)
        } else {
            self
        }
    }
}

private enum Aspects {
    case full
    case type1
    case type2
    case type3
    case type4
    case type5
    case type6
    case type7
    case custom(CGFloat)
    
    var value: CGFloat? {
        switch self {
        case .full: return nil
        case .type1: return 1/1
        case .type2: return 9/16
        case .type3: return 4/5
        case .type4: return 5/7
        case .type5: return 3/4
        case .type6: return 3/5
        case .type7: return 2/3
        case .custom(let value): return value
        }
    }
    
    var title: String {
        switch self {
        case .full: return "FULL"
        case .type1: return "1:1 (Instagram)"
        case .type2: return "9:16"
        case .type3: return "4:5"
        case .type4: return "5:7"
        case .type5: return "3:4"
        case .type6: return "3:5"
        case .type7: return "2:3 (10/15)"
        case .custom: return "CUSTOM"
        }
    }
}

struct ToolsAspectRatioView: View {
    @Injected private var settings: VDEVMediaEditorSettings
    @EnvironmentObject private var vm: CanvasUISettingsViewModel
    
    private var variants: [Aspects] = []
    private let onSelected: (CGFloat?) -> Void
    
    init(onSelected: @escaping (CGFloat?) -> Void) {
        self.onSelected = onSelected
        //variants = [.type1, .type2, .type3, .type4, .type5, .type6, .type7]
        if let userAspect = settings.aspectRatio {
            variants = [.custom(userAspect), .full, .type1, .type2, .type3, .type4, .type5, .type6, .type7]
        } else {
            variants = [.full, .type1, .type2, .type3, .type4, .type5, .type6, .type7]
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<variants.count, id: \.self) { index in
                Button {
                    makeHaptics()
                    onSelected(variants[index].value)
                } label: {
                    Group {
                        if vm.aspectRatio == variants[index].value {
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
                        onSelected(variants[index].value)
                    }
                }
            }
        }
        .cornerRadius(8)
    }
}
