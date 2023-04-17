//
//  RoundButton.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 02.02.2023.
//

import SwiftUI

struct RoundButton: View {
    let systemName: String
    let size: CGSize
    let action: () -> Void

    init(systemName: String,
         size: CGSize = .init(width: 45, height: 45),
         action: @escaping () -> Void) {
        self.systemName = systemName
        self.size = size
        self.action = action
    }

    var body: some View {
        Button {
            haptics(.light)
            action()
        } label: {
            Image(systemName: systemName)
                .font(Font.footnote.weight(.heavy))
                .foregroundColor(AppColors.white)
                .frame(width: size.width, height: size.height)
                .background(AppColors.blackWithOpacity)
                .cornerRadius(size.width / 2)
                .padding()
        }
        .contentShape(Circle())
    }
}

