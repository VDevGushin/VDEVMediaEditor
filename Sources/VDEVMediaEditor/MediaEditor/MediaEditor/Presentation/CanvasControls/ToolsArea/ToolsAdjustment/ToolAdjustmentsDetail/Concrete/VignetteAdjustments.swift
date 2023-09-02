//
//  VignetteAdjustments.swift
//  
//
//  Created by Vladislav Gushin on 05.09.2023.
//

import SwiftUI

struct VignetteAdjustments: View {
    @Injected var strings: VDEVMediaEditorStrings
    @Binding private var state: ToolsEditState
    @State private var value: Double = AllAdjustmentsFilters.vignette.normal
    
    private weak var memento: MementoObject?
    private let title: String
    private let item: CanvasItemModel
    private let filter = AllAdjustmentsFilters.vignette
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
                    value = newValue
                    let settings: AdjustmentSettings = makeSettings(value: value)
                    self.item.apply(adjustmentSettings: settings)
                }, in: filter.min...filter.max, onEditingChanged: { value in
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
            value = item.adjustmentSettings?.vignette?.0 ?? filter.normal
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
        guard let imageModel: CanvasImageModel = CanvasImageModel.toTypeOptional(model: item) else {
            return .init(
                brightness: item.adjustmentSettings?.brightness,
                contrast: item.adjustmentSettings?.contrast,
                saturation: item.adjustmentSettings?.saturation,
                highlight: item.adjustmentSettings?.highlight,
                shadow: item.adjustmentSettings?.shadow,
                blurRadius: item.adjustmentSettings?.blurRadius,
                alpha: item.adjustmentSettings?.alpha,
                temperature: item.adjustmentSettings?.temperature,
                vignette:  item.adjustmentSettings?.vignette
            )
        }
    
        return .init(
            brightness: item.adjustmentSettings?.brightness,
            contrast: item.adjustmentSettings?.contrast,
            saturation: item.adjustmentSettings?.saturation,
            highlight: item.adjustmentSettings?.highlight,
            shadow: item.adjustmentSettings?.shadow,
            blurRadius: item.adjustmentSettings?.blurRadius,
            alpha: item.adjustmentSettings?.alpha,
            temperature: item.adjustmentSettings?.temperature,
            vignette: (value, imageModel.image.size.rect),
            sharpness: item.adjustmentSettings?.sharpness
        )
    }
}



