//
//  SeeAnswersButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import SwiftUI

struct SeeAnswersButton: View {
    struct Strings {
        static let see = "SEE"
        static let answers = "ANSWERS"
    }
    
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
                
                Text("\(Strings.see) \(number) \(Strings.answers)")
                    .font(AppFonts.elmaTrioRegular(13))
                    .foregroundColor(AppColors.whiteWithOpacity1)
                    .shadow(radius: 5)
            }
            .frame(height: height)
            .frame(minHeight: 100)
        }
    }
}
