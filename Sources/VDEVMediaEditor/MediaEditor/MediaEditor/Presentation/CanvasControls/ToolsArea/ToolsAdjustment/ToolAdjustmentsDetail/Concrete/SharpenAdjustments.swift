//
//  SharpenAdjustments.swift
//  
//
//  Created by Vladislav Gushin on 05.09.2023.
//

import SwiftUI

struct SharpenAdjustments: View {
    @Injected var strings: VDEVMediaEditorStrings
    @Binding private var state: ToolsEditState
    @State private var value: Double = AllAdjustmentsFilters.sharpen.value.normal
    @State private var radius: Double = AllAdjustmentsFilters.sharpen.radius.normal
    
    private weak var memento: MementoObject?
    private let title: String
    private let item: CanvasItemModel
    private let filter = AllAdjustmentsFilters.sharpen
    private let onClose: () -> Void
    
    init(
        _ title: String,
        item: CanvasItemModel,
        memento: MementoObject?,
        state: Binding<ToolsEditState>,
        onClose: @escaping () -> Void
    ) {
        self.title = title
        self.item = item
        self.memento = memento
        self._state = state
        self.onClose = onClose
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(title)
                    .font(AppFonts.elmaTrioRegular(12))
                    .foregroundColor(AppColors.whiteWithOpacity)
                    .frame(maxWidth: 80, alignment: .center)
                
                Slider(value:
                        Binding<Double> {
                    return value
                } set: { newValue in
                    if newValue == filter.value.normal { makeHaptics(.light) }
                    value = newValue
                    let settings: AdjustmentSettings = makeSettings(value: value, radius: radius)
                    self.item.apply(adjustmentSettings: settings)
                }, in: filter.value.min...filter.value.max, onEditingChanged: { value in
                    if !value {
                        state = .idle
                    } else {
                        memento?.forceSave()
                        state = .edit
                    }
                })
                .accentColor(AppColors.white)
                .contentShape(Rectangle())
            }
            
            HStack {
                Text(strings.radius)
                    .font(AppFonts.elmaTrioRegular(12))
                    .foregroundColor(AppColors.whiteWithOpacity)
                    .frame(maxWidth: 80, alignment: .center)
                
                Slider(value:
                        Binding<Double> {
                    return radius
                } set: { newValue in
                    if newValue == filter.radius.normal { makeHaptics(.light) }
                    radius = newValue
                    let settings: AdjustmentSettings = makeSettings(value: value, radius: radius)
                    self.item.apply(adjustmentSettings: settings)
                }, in: filter.radius.min...filter.radius.max, onEditingChanged: { value in
                    if !value {
                        state = .idle
                    } else {
                        memento?.forceSave()
                        state = .edit
                    }
                })
                .accentColor(AppColors.white)
                .contentShape(Rectangle())
            }
            
            HStack {
                Button {
                    haptics(.light)
                    onClose()
                } label: {
                    Text(strings.close)
                        .font(AppFonts.elmaTrioRegular(12))
                        .foregroundColor(AppColors.redWithOpacity)
                }
                .frame(height: 32)
                .background {
                    InvisibleTapZoneView { onClose() }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                Button {
                    haptics(.light)
                    reset()
                } label: {
                    Text(strings.default)
                        .font(AppFonts.elmaTrioRegular(12))
                        .foregroundColor(AppColors.whiteWithOpacity)
                }
                .frame(height: 32)
                .background {
                    InvisibleTapZoneView {
                        reset()
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .opacity(state.getOpacity())
        }
        .onAppear {
            startState()
        }
    }
    
    private func startState() {
        withAnimation(.interactiveSpring()) {
            value = item.adjustmentSettings?.sharpness?.sharpness ?? filter.value.normal
            radius = item.adjustmentSettings?.sharpness?.radius ?? filter.radius.normal
        }
    }
    
    private func reset() {
        withAnimation(.interactiveSpring()) {
            value = filter.value.normal
            radius = filter.radius.normal
            let settings: AdjustmentSettings = makeSettings(value: value, radius: radius)
            item.apply(adjustmentSettings: settings)
        }
    }
    
    private func makeSettings(value: Double, radius: Double) -> AdjustmentSettings {
        .init(
            brightness: item.adjustmentSettings?.brightness,
            contrast: item.adjustmentSettings?.contrast,
            saturation: item.adjustmentSettings?.saturation,
            highlight: item.adjustmentSettings?.highlight,
            shadow: item.adjustmentSettings?.shadow,
            blurRadius: item.adjustmentSettings?.blurRadius,
            alpha: item.adjustmentSettings?.alpha,
            temperature: item.adjustmentSettings?.temperature,
            vignette: item.adjustmentSettings?.vignette,
            sharpness: (value, radius)
        )
    }
}
