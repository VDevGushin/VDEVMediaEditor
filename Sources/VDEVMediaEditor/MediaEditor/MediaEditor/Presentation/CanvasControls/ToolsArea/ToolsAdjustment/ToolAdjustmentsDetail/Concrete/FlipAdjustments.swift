//
//  FlipAdjustments.swift
//  
//
//  Created by Vladislav Gushin on 26.09.2023.
//

import SwiftUI

struct FlipAdjustments: View {
    @Injected private var processingWatcher: ItemProcessingWatcher
    @Injected private var strings: VDEVMediaEditorStrings
    
    @Binding private var state: ToolsEditState
    
    @State private var vertical: Bool = AllAdjustmentsFilters.flip.normalVertical
    @State private var horizontal: Bool = AllAdjustmentsFilters.flip.normalHorizontal
    
    private weak var memento: MementoObject?
    
    private let title: String
    
    private let item: CanvasItemModel
    
    private let filter = AllAdjustmentsFilters.flip
    
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
            Toggle(
                strings.vertical,
                isOn: Binding<Bool> {
                    return vertical
                } set: { newValue in
                    memento?.forceSave()
                    vertical = newValue
                    let settings: AdjustmentSettings = makeSettings(
                        vertical: newValue,
                        horizontal: horizontal
                    )
                    self.item.apply(adjustmentSettings: settings)
                }
            )
            .toggleStyle(iOSCheckboxToggleStyleInvert())
            .font(AppFonts.elmaTrioRegular(15))
            .foregroundColor(AppColors.whiteWithOpacity)
            .frame(
                maxWidth: .infinity,
                alignment: .trailing
            )
            
            Toggle(
                strings.horizontal,
                isOn: Binding<Bool> {
                    return horizontal
                } set: { newValue in
                    memento?.forceSave()
                    horizontal = newValue
                    let settings: AdjustmentSettings = makeSettings(
                        vertical: vertical,
                        horizontal: newValue
                    )
                    self.item.apply(adjustmentSettings: settings)
                }
            )
            .toggleStyle(iOSCheckboxToggleStyleInvert())
            .font(AppFonts.elmaTrioRegular(15))
            .foregroundColor(AppColors.whiteWithOpacity)
            .frame(
                maxWidth: .infinity,
                alignment: .trailing
            )
            
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
            vertical = item.adjustmentSettings?.flipVertical?.value ?? filter.normalVertical
            horizontal = item.adjustmentSettings?.flipHorizontal?.value ?? filter.normalHorizontal
        }
    }
    
    private func reset() {
        withAnimation(.interactiveSpring()) {
            vertical = filter.normalVertical
            horizontal = filter.normalHorizontal
            let settings: AdjustmentSettings = makeSettings(
                vertical: vertical,
                horizontal: horizontal
            )
            item.apply(adjustmentSettings: settings)
        }
    }
    
    private func makeSettings(
        vertical: Bool,
        horizontal: Bool
    ) -> AdjustmentSettings {
        
        let verticalInput: FlipFilterInput? = .init(
            value: vertical,
            flipType: FlipType.vertical
        )
        
        let horizontalInput: FlipFilterInput? = .init(
            value: horizontal,
            flipType: FlipType.horizontal
        )
        
        return .init(
            brightness: item.adjustmentSettings?.brightness,
            contrast: item.adjustmentSettings?.contrast,
            saturation: item.adjustmentSettings?.saturation,
            highlight: item.adjustmentSettings?.highlight,
            shadow: item.adjustmentSettings?.shadow,
            blurRadius: item.adjustmentSettings?.blurRadius,
            alpha: item.adjustmentSettings?.alpha,
            temperature: item.adjustmentSettings?.temperature,
            vignette: item.adjustmentSettings?.vignette,
            sharpness: item.adjustmentSettings?.sharpness,
            flipVertical: verticalInput,
            flipHorizontal: horizontalInput
        )
    }
}
