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
        case .type1: return "1:1"
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
        HStack {
            AnimatedGradientViewVertical(
                color: AppColors.redWithOpacity,
                duration: 2,
                blur: 20
            )
            .background {
                AppColors
                    .whiteWithOpacity2
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(2)
            }
            .background {
                Image(systemName:  vm.aspectRatio  == nil ? "arrow.up.and.down.and.arrow.left.and.right" : "scribble.variable")
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(AppColors.whiteWithOpacity1)
                    .font(.system(size: 64, weight: .regular))
                    .blur(radius: 2)
                    .rotationEffect(.degrees(vm.aspectRatio  == nil ? 45 : 0))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppColors.whiteWithOpacity2, lineWidth: 1)
            )
            .aspectRatio(vm.aspectRatio ?? 9/16, contentMode: .fill)
            .frame(maxWidth: 100)
            .frame(maxHeight: 100)
            .animation(.interactiveSpring(), value: vm.aspectRatio)
            .withParallaxCardEffect()
            
            VStack(
                alignment: .leading,
                spacing: 12
            ) {
                ForEach(0..<variants.count, id: \.self) { index in
                    Button {
                        makeHaptics()
                        onSelected(variants[index].value)
                    } label: {
                        Group {
                            if vm.aspectRatio == variants[index].value {
                                Text(variants[index].title)
                                    .font(AppFonts.elmaTrioRegular(18))
                                    .foregroundColor(AppColors.whiteWithOpacity)
                                    .underline()
                                    .transition(.opacityTransition(speed: 0.2))
                            } else {
                                Text(variants[index].title)
                                    .font(AppFonts.elmaTrioRegular(18))
                                    .foregroundColor(AppColors.whiteWithOpacity)
                                    .transition(.opacityTransition(speed: 0.2))
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .frame(minHeight: 32)
                        .background {
                            if vm.aspectRatio == variants[index].value {
                                AppColors
                                    .whiteWithOpacity2
                                    .transition(.opacityTransition(speed: 0.2))
                                
                            } else {
                                AnimatedGradientViewVertical(
                                    color: AppColors.whiteWithOpacity2,
                                    duration: 2,
                                    blur: 20
                                )
                                .transition(.opacityTransition(speed: 0.2))
                            }
                        }
                        .background {
                            InvisibleTapZoneView {
                                onSelected(variants[index].value)
                            }
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(vm.aspectRatio == variants[index].value)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
