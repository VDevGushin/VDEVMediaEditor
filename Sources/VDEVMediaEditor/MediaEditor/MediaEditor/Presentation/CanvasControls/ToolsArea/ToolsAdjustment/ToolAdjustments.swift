//
//  ToolAdjustments.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import SwiftUI
import Combine

private final class ToolAdjustmentsVM: ObservableObject {
    @Injected var strings: VDEVMediaEditorStrings
    var toolItems: [AdjustToolItem] = []
    
    init() {
        let colorFilters = CIFilter(name: "CIColorControls")!
        let sharpenLuminanceFilters = CIFilter(name: "CISharpenLuminance")!
        let highlightShadowAdjustFilters = CIFilter(name: "CIHighlightShadowAdjust")!
        let colorMatrixFilters = CIFilter(name: "CIColorMatrix")!
        let currentContrastValue = colorFilters.value(forKey: kCIInputContrastKey) as? Double ?? 0.0
        let currentBrightnessValue = colorFilters.value(forKey: kCIInputBrightnessKey) as? Double ?? 0.0
        let currentSaturationValue = colorFilters.value(forKey: kCIInputSaturationKey) as? Double ?? 1.0
        let currentSharpenValue = sharpenLuminanceFilters.value(forKey: kCIInputSharpnessKey) as? Double ?? 0.4
        let currentHighlightValue = highlightShadowAdjustFilters.value(forKey: "inputHighlightAmount") as? Double ?? 0.5
        let currentShadowValue = highlightShadowAdjustFilters.value(forKey: "inputShadowAmount") as? Double ?? 0
        let currentGaussianValue = 0.0
        let currentAlphaValue = colorMatrixFilters.value(forKey: "inputAVector") as? Double ?? 1
        
        toolItems = [
            AdjustToolItem(
                title: strings.brightness,
                min: currentBrightnessValue - 0.2,
                max: currentBrightnessValue + 0.2,
                normal: currentBrightnessValue
            ),
            AdjustToolItem(
                title: strings.contrast,
                min: currentContrastValue - 0.1,
                max: currentContrastValue + 0.1,
                normal: currentContrastValue
            ),
            AdjustToolItem(
                title: strings.saturation,
                min: currentSaturationValue - 1,
                max: currentSaturationValue + 1,
                normal: currentSaturationValue
            ),
            AdjustToolItem(
                title: strings.highlight,
                min: 0,
                max: currentHighlightValue,
                normal: currentHighlightValue
            ),
            AdjustToolItem(
                title: strings.shadow,
                min: currentShadowValue - 1,
                max: currentShadowValue + 1,
                normal: currentShadowValue
            ),
            AdjustToolItem(
                title: strings.blurRadius,
                min: 0,
                max: 15,
                normal: currentGaussianValue
            ),
            AdjustToolItem(
                title: strings.alpha,
                min: 0,
                max: 1,
                normal: currentAlphaValue
            ),
//            AdjustToolItem(
//                title: strings.sharpen,
//                min: currentSharpenValue,
//                max: 2,
//                normal: currentSharpenValue
//            ),
        ]
    }
}

struct ToolAdjustments: View {
    @EnvironmentObject private var vm: CanvasEditorViewModel
    @StateObject private var toolsAdjVM: ToolAdjustmentsVM = .init()
    private weak var memento: MementoObject? // for save state
    private let item: CanvasItemModel
    
    @State private var brightness: Double = 0
    @State private var contrast: Double = 0
    @State private var saturation: Double = 0
    @State private var highlight: Double = 0
    @State private var shadow: Double = 0
    @State private var blurRadius: Double = 0
    @State private var alpha: Double = 0
    //@State private var sharpen: Double = 0.40
    
    @Binding private var state: ToolsEditState
    
    init(_ item: CanvasItemModel,
         state: Binding<ToolsEditState>,
         memento: MementoObject? = nil) {
        self.item = item
        self._state = state
        self.memento = memento
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 18) {
                ForEach(0..<toolsAdjVM.toolItems.count, id: \.self) { i in
                    let item = toolsAdjVM.toolItems[i]
                    HStack {
                        Text(item.title)
                            .font(AppFonts.elmaTrioRegular(12))
                            .foregroundColor(AppColors.whiteWithOpacity)
                            .frame(maxWidth: 80, alignment: .leading)
                            .opacity(state.getOpacity(for: i))
                            .scaleEffect(state.inEdit(for: i) ? 1.1 : 1.0, anchor: .leading)
                        
                        Slider(value: Binding<Double> {
                            switch i {
                            case 0: return brightness
                            case 1: return contrast
                            case 2: return saturation
                            case 3: return highlight
                            case 4: return shadow
                            case 5: return blurRadius
                            case 6: return alpha
                            //case 7: return sharpen
                            default: fatalError()
                            }
                        } set: { newValue in
                            switch i {
                            case 0: brightness = newValue
                            case 1: contrast = newValue
                            case 2: saturation = newValue
                            case 3: highlight = newValue
                            case 4: shadow = newValue
                            case 5: blurRadius = newValue
                            case 6: alpha = newValue
                            //case 7: sharpen = newValue
                            default: ()
                            }
                            
                            let settings: AdjustmentSettings = .init(
                                brightness: brightness,
                                contrast: contrast,
                                saturation: saturation,
                                highlight: highlight,
                                shadow: shadow,
                                blurRadius: blurRadius,
                                alpha: alpha
                                //sharpen: sharpen
                            )
                            self.item.apply(adjustmentSettings: settings)
                            
                        }, in: item.min...item.max, onEditingChanged: { value in
                            if !value {
                                state = .idle
                            } else {
                                memento?.forceSave()
                                state = .edit(i)
                            }
                        })
                        .accentColor(AppColors.white)
                        .contentShape(Rectangle())
                        .opacity(state.getOpacity(for: i))
                    }
                }
            }
            
            Button {
                haptics(.light)
                item.apply(adjustmentSettings: nil)
                resetState()
            } label: {
                Text(toolsAdjVM.strings.default)
                    .font(AppFonts.elmaTrioRegular(12))
                    .foregroundColor(AppColors.whiteWithOpacity)
            }
            .frame(height: 32)
            .background {
                InvisibleTapZoneView {
                    item.apply(adjustmentSettings: nil)
                    resetState()
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .buttonStyle(PlainButtonStyle())
            .opacity(state.getOpacity())
        }
        .onAppear { resetState() }
    }
    
    private func resetState() {
        withAnimation(.interactiveSpring()) {
            brightness = item.adjustmentSettings?.brightness ?? toolsAdjVM.toolItems[0].normal
            contrast = item.adjustmentSettings?.contrast ?? toolsAdjVM.toolItems[1].normal
            saturation = item.adjustmentSettings?.saturation ?? toolsAdjVM.toolItems[2].normal
            highlight = item.adjustmentSettings?.highlight ?? toolsAdjVM.toolItems[3].normal
            shadow = item.adjustmentSettings?.shadow ?? toolsAdjVM.toolItems[4].normal
            blurRadius = item.adjustmentSettings?.blurRadius ?? toolsAdjVM.toolItems[5].normal
            alpha = item.adjustmentSettings?.alpha ?? toolsAdjVM.toolItems[6].normal
//            sharpen = item.adjustmentSettings?.sharpen ?? toolsAdjVM.toolItems[7].normal
        }
    }
}

private struct AdjustToolItem {
    var title: String
    var min: Double
    var max: Double
    var normal: Double
}
