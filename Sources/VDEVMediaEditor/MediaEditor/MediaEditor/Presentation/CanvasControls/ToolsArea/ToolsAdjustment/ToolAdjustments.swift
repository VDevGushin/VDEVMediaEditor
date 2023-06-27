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
    
    @Binding private var state: ToolsEditState
    
    init(_ item: CanvasItemModel,
         state: Binding<ToolsEditState>,
         memento: MementoObject? = nil) {
        self.item = item
        self._state = state
        self.memento = memento
        
        let colorFilters = CIFilter(name: "CIColorControls")!
        
        let currentContrastValue: Double = colorFilters.value(forKey: kCIInputContrastKey) as? Double ?? 0.0
        let currentBrightnessValue: Double = colorFilters.value(forKey: kCIInputBrightnessKey) as? Double ?? 0.0
        let currentSaturationValue: Double = colorFilters.value(forKey: kCIInputSaturationKey) as? Double ?? 1.0
        
        toolItems = [
            AdjustToolItem(title: strings.brightness, min: -0.5, max: 0.5, normal: currentBrightnessValue),
            AdjustToolItem(title: strings.contrast, min: 0, max: 2, normal: currentContrastValue),
            AdjustToolItem(title: strings.saturation, min: 0, max: 2, normal: currentSaturationValue),
            AdjustToolItem(title: strings.highlight, min: 0, max: 1, normal: 0.5),
            AdjustToolItem(title: strings.shadow, min: -1, max: 1, normal: 0)
        ]
    }
    
    var body: some View {
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
                        default: fatalError()
                        }
                    } set: { newValue in
                        switch i {
                        case 0: brightness = newValue
                        case 1: contrast = newValue
                        case 2: saturation = newValue
                        case 3: highlight = newValue
                        case 4: shadow = newValue
                        default: ()
                        }
                        
                        let settings: AdjustmentSettings = .init(
                            brightness: brightness,
                            contrast: contrast,
                            saturation: saturation,
                            highlight: highlight,
                            shadow: shadow
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
                    haptics(.light)
                    item.apply(adjustmentSettings: nil)
                    resetState()
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .buttonStyle(PlainButtonStyle())
            .opacity(state.getOpacity())
        }
        .onAppear { resetState() }
        .padding(.top)
    }
    
    private func resetState() {
        withAnimation(.interactiveSpring()) {
            brightness = item.adjustmentSettings?.brightness ?? toolItems[0].normal
            contrast = item.adjustmentSettings?.contrast ?? toolItems[1].normal
            saturation = item.adjustmentSettings?.saturation ?? toolItems[2].normal
            highlight = item.adjustmentSettings?.highlight ?? toolItems[3].normal
            shadow = item.adjustmentSettings?.shadow ?? toolItems[4].normal
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
