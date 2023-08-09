//
//  ToolAdjustments.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import SwiftUI

struct ToolAdjustments: View {
    @Injected private var strings: VDEVMediaEditorStrings
    @EnvironmentObject private var vm: CanvasEditorViewModel
    private weak var memento: MementoObject? // for save state
    
    private let item: CanvasItemModel
    
    private var toolItems: [AdjustToolItem] = []
    
    @State private var brightness: Double = 0
    @State private var contrast: Double = 0
    @State private var saturation: Double = 0
    @State private var highlight: Double = 0
    @State private var shadow: Double = 0
    @State private var blurRadius: Double = 0
    @State private var alpha: Double = 0
    @State private var sharpen: Double = 0.40
    
    @Binding private var state: ToolsEditState
    
    init(_ item: CanvasItemModel,
         state: Binding<ToolsEditState>,
         memento: MementoObject? = nil) {
        self.item = item
        self._state = state
        self.memento = memento
        
        
        toolItems = [
            AdjustToolItem(
                title: strings.brightness,
                min: AdjustmentSettings.DefaultValues.currentBrightnessValue.value - 0.2,
                max: AdjustmentSettings.DefaultValues.currentBrightnessValue.value + 0.2,
                normal: AdjustmentSettings.DefaultValues.currentBrightnessValue.value
            ),
            AdjustToolItem(
                title: strings.contrast,
                min: AdjustmentSettings.DefaultValues.currentContrastValue.value - 0.2,
                max: AdjustmentSettings.DefaultValues.currentContrastValue.value + 0.2,
                normal: AdjustmentSettings.DefaultValues.currentContrastValue.value
            ),
            AdjustToolItem(
                title: strings.saturation,
                min: AdjustmentSettings.DefaultValues.currentSaturationValue.value - 1,
                max: AdjustmentSettings.DefaultValues.currentSaturationValue.value + 1,
                normal: AdjustmentSettings.DefaultValues.currentSaturationValue.value
            ),
            AdjustToolItem(
                title: strings.highlight,
                min: 0,
                max: AdjustmentSettings.DefaultValues.currentHighlightValue.value,
                normal: AdjustmentSettings.DefaultValues.currentHighlightValue.value
            ),
            AdjustToolItem(
                title: strings.shadow,
                min: AdjustmentSettings.DefaultValues.currentShadowValue.value - 1,
                max: AdjustmentSettings.DefaultValues.currentShadowValue.value + 1,
                normal: AdjustmentSettings.DefaultValues.currentShadowValue.value
            ),
            AdjustToolItem(
                title: strings.blurRadius,
                min: 0,
                max: 15,
                normal: AdjustmentSettings.DefaultValues.currentGaussianValue.value
            ),
            AdjustToolItem(
                title: strings.alpha,
                min: 0,
                max: 1,
                normal: AdjustmentSettings.DefaultValues.currentAlphaValue.value
            ),
            AdjustToolItem(
                title: strings.sharpen,
                min: AdjustmentSettings.DefaultValues.currentSharpenValue.value,
                max: 2,
                normal: AdjustmentSettings.DefaultValues.currentSharpenValue.value
            ),
        ]
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 18) {
                ForEach(0..<toolItems.count, id: \.self) { i in
                    let item = toolItems[i]
                    HStack {
                        Text(item.title)
                            .font(AppFonts.elmaTrioRegular(12))
                            .foregroundColor(AppColors.whiteWithOpacity)
                            .frame(maxWidth: 80, alignment: .leading)
                        
                        Slider(value: Binding<Double> {
                            switch i {
                            case 0: return brightness
                            case 1: return contrast
                            case 2: return saturation
                            case 3: return highlight
                            case 4: return shadow
                            case 5: return blurRadius
                            case 6: return alpha
                            case 7: return sharpen
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
                            case 7: sharpen = newValue
                            default: ()
                            }
                            
                            let settings: AdjustmentSettings = .init(
                                brightness: brightness,
                                contrast: contrast,
                                saturation: saturation,
                                highlight: highlight,
                                shadow: shadow,
                                blurRadius: blurRadius,
                                alpha: alpha,
                                sharpen: sharpen
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
                Text(strings.default)
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
            brightness = item.adjustmentSettings?.brightness ?? toolItems[0].normal
            contrast = item.adjustmentSettings?.contrast ?? toolItems[1].normal
            saturation = item.adjustmentSettings?.saturation ?? toolItems[2].normal
            highlight = item.adjustmentSettings?.highlight ?? toolItems[3].normal
            shadow = item.adjustmentSettings?.shadow ?? toolItems[4].normal
            blurRadius = item.adjustmentSettings?.blurRadius ?? toolItems[5].normal
            alpha = item.adjustmentSettings?.alpha ?? toolItems[6].normal
            sharpen = item.adjustmentSettings?.sharpen ?? toolItems[7].normal
        }
    }
}

extension ToolAdjustments {
    private struct AdjustToolItem {
        var title: String
        var min: Double
        var max: Double
        var normal: Double
    }
}
