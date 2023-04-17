//
//  NoShadowRoundButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//

import SwiftUI

struct NoShadowRoundButton: View {
    let image: UIImage
    let size: CGFloat
    let title: String?
    let backgroundColor: Color
    let tintColor: Color
    let fontSize: CGFloat
    let action: () -> Void
    
    init(image: UIImage,
         size: CGFloat = 44,
         title: String? = nil,
         fontSize: CGFloat = 12,
         backgroundColor: Color = AppColors.black,
         tintColor: Color = AppColors.white,
         action: @escaping () -> Void) {
        self.image = image
        self.fontSize = fontSize
        self.size = size
        self.action = action
        self.title = title
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
    }
    
    var body: some View {
        Button {
            haptics(.light)
            action()
        } label: {
            VStack(alignment: .center, spacing: 0) {
                Image(uiImage: image)
                    .frame(width: size, height: size)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: size / 2))
                
                title.map {
                    Text($0)
                        .foregroundColor(tintColor)
                        .font(AppFonts.elmaTrioRegular(fontSize))
                        .padding(.top, 10)
                }
            }
        }
    }
}
