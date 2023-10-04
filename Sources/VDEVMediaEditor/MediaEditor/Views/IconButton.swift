//
//  IconButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 07.02.2023.
//

import SwiftUI

struct IconButton: View {
    var imageName: String
    var color: Color
    let imageWidth: CGFloat = 20
    let buttonWidth: CGFloat = 45

    var body: some View {
        ZStack {
            color
            Image(systemName: imageName)
                .frame(width: imageWidth, height: imageWidth)
                .foregroundColor(AppColors.white)
        }
        .frame(width: buttonWidth, height: buttonWidth)
        .clipShape(RoundedRectangle(cornerRadius: buttonWidth / 2))
    }
}
