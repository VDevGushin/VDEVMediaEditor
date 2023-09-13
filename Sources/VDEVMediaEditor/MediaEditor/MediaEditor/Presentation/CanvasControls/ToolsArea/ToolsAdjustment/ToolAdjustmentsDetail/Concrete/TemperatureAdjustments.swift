//
//  TemperatureAdjustments.swift
//  
//
//  Created by Vladislav Gushin on 05.09.2023.
//

import SwiftUI

struct TemperatureAdjustments: View {
    @Injected private var processingWatcher: ItemProcessingWatcher
    @Injected private var strings: VDEVMediaEditorStrings
    @Binding private var state: ToolsEditState
    @State private var value: Double = AllAdjustmentsFilters.temperature.normal
    
    private weak var memento: MementoObject?
    private let title: String
    private let item: CanvasItemModel
    private let filter = AllAdjustmentsFilters.temperature
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
                
                Slider(
                    value: Binding<Double> {
                        return value
                    } set: { newValue in
                        if newValue == filter.normal { makeHaptics(.light) }
                        value = newValue
                        let settings: AdjustmentSettings = makeSettings(value: value)
                        self.item.apply(adjustmentSettings: settings)
                    },
                    in: filter.min...filter.max,
                    onEditingChanged: { value in
                        if !value {
                            state = .idle
                            processingWatcher.finishProcessing()
                        } else {
                            memento?.forceSave()
                            processingWatcher.startProcessing()
                            state = .edit
                        }
                    })
                .accentColor(AppColors.white)
                .contentShape(Rectangle())
                .alignmentGuide(VerticalAlignment.center) { $0[VerticalAlignment.center]}
                .padding(.top, 20)
                .overlay(alignment: .top) {
                    GeometryReader { gp in
                        VStack {
                            Text(
                                ValueCalc.make(
                                    value: value,
                                    max: filter.max,
                                    min: filter.min
                                )
                            )
                            .font(AppFonts.elmaTrioRegular(12))
                            .foregroundColor(AppColors.whiteWithOpacity)
                            Spacer().frame(height: 6)
                        }
                        .alignmentGuide(HorizontalAlignment.leading) {
                            return $0[HorizontalAlignment.leading] - (gp.size.width - $0.width) * (value - filter.min) / ( filter.max - filter.min)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            
            AdjustmentsDetailButtons(state: $state) {
                reset()
            } doneAction: {
                onClose()
            }
        }
        .onAppear {
            startState()
        }
    }
    
    private func startState() {
        withAnimation(.interactiveSpring()) {
            value = item.adjustmentSettings?.temperature ?? filter.normal
        }
    }
    
    private func reset() {
        withAnimation(.interactiveSpring()) {
            value = filter.normal
            let settings: AdjustmentSettings = makeSettings(value: value)
            item.apply(adjustmentSettings: settings)
        }
    }
    
    private func makeSettings(value: Double) -> AdjustmentSettings {
        .init(
            brightness: item.adjustmentSettings?.brightness,
            contrast: item.adjustmentSettings?.contrast,
            saturation: item.adjustmentSettings?.saturation,
            highlight: item.adjustmentSettings?.highlight,
            shadow: item.adjustmentSettings?.shadow,
            blurRadius: item.adjustmentSettings?.blurRadius,
            alpha: item.adjustmentSettings?.alpha,
            temperature: value,
            vignette: item.adjustmentSettings?.vignette,
            sharpness: item.adjustmentSettings?.sharpness
        )
    }
}
