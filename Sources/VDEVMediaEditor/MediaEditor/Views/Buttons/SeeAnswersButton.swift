//
//  SeeAnswersButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import SwiftUI
import Resolver

struct SeeAnswersButton: View {
    @Injected private var strings: VDEVEditorStrings
    
    private let height: CGFloat = 40
    private let action: () -> Void
    private let number: Int
    
    init(number: Int, action: @escaping () -> Void) {
        self.action = action
        self.number = number
    }
    
    var body: some View {
        Button {
            haptics(.light)
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.shareButtonsColors)
                
                Text("\(strings.see) \(number) \(strings.answers)")
                    .font(AppFonts.elmaTrioRegular(13))
                    .foregroundColor(AppColors.whiteWithOpacity1)
                    .shadow(radius: 5)
            }
            .frame(height: height)
            .frame(minHeight: 100)
        }
    }
}
