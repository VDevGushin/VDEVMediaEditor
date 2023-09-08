//
//  AdjustmentsDetailButtons.swift
//  
//
//  Created by Vladislav Gushin on 08.09.2023.
//

import SwiftUI

struct AdjustmentsDetailButtons: View {
    @Injected private var strings: VDEVMediaEditorStrings
    @Binding private var state: ToolsEditState
    private let resetAction: () -> Void
    private let doneAction: () -> Void
    
    init(
        state: Binding<ToolsEditState>,
        resetAction: @escaping () -> Void,
        doneAction: @escaping () -> Void
    ) {
        self._state = state
        self.resetAction = resetAction
        self.doneAction = doneAction
    }
    
    var body: some View {
        HStack {
            Button {
                haptics(.light)
                resetAction()
            } label: {
                Text(strings.default)
                    .font(AppFonts.elmaTrioRegular(12))
                    .foregroundColor(AppColors.whiteWithOpacity)
            }
            .frame(height: 32)
            .background {
                InvisibleTapZoneView {
                    resetAction()
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Button {
                haptics(.light)
                doneAction()
            } label: {
                Text(strings.done)
                    .font(AppFonts.elmaTrioRegular(14))
                    .foregroundColor(AppColors.greenWithOpacity)
            }
            .frame(height: 32)
            .background {
                InvisibleTapZoneView { doneAction() }
            }
            .buttonStyle(PlainButtonStyle())
        }
        .opacity(state.getOpacity())
    }
}
