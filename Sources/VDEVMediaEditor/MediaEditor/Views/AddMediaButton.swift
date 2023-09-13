//
//  AddMediaButton.swift
//  
//
//  Created by Vladislav Gushin on 17.09.2023.
//

import SwiftUI

struct AddMediaButton: View {
    @Binding private var title: String
    @Binding private var isVisible: Bool
    private let cornerRadius: CGFloat
    private let action: () -> Void
    
    init(
        isVisible: Binding<Bool>,
        title: Binding<String>,
        cornerRadius: CGFloat,
        action: @escaping () -> Void
    ) {
        self._isVisible = isVisible
        self._title = title
        self.cornerRadius = cornerRadius
        self.action = action
    }
    
    var body: some View {
        if isVisible {
            Button(action: {
                makeHaptics()
                action()
                Log.d("Add new layer")
            }) {
                Text(title)
                    .font(AppFonts.elmaTrioRegular(13))
                    .foregroundColor(AppColors.whiteWithOpacity)
                    .padding()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .center
                    )
                    .background(
                        AnimatedGradientViewVerticalInvert(
                            color: AppColors.whiteWithOpacity2,
                            duration: 10
                        )
                    )
                    .clipShape(RoundedCorner(radius: cornerRadius))
            }
        }
    }
}
