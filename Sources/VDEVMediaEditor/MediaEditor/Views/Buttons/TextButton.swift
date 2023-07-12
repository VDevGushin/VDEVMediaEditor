//
//  TextButton.swift
//  
//
//  Created by Vladislav Gushin on 12.07.2023.
//

import SwiftUI

struct TextButton: View {
    private let size: CGSize = .init(width: 100, height: 45)
    private let title: String
    private let action: () -> Void
    
    init(title: String,
        action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button {
            haptics(.light)
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.whiteWithOpacity)
                
                Text(title)
                    .font(AppFonts.elmaTrioRegular(14))
                    .foregroundColor(AppColors.black)
                    .shadow(radius: 5)
            }
            .frame(size)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
