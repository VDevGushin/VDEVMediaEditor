//
//  NoShadowRoundButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//

import SwiftUI

struct NoShadowRoundButton: View {
    let imageName: String
    let size: CGFloat
    let title: String?
    let backgroundColor: Color
    let tintColor: Color
    let fontSize: CGFloat
    let action: () -> Void
    
    init(imageName: String,
         size: CGFloat = 44,
         title: String? = nil,
         fontSize: CGFloat = 12,
         backgroundColor: Color = AppColors.black,
         tintColor: Color = AppColors.white,
         action: @escaping () -> Void) {
        self.imageName = imageName
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
                Image(imageName)
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

struct NoShadowRoundButton_Previews: PreviewProvider {
    static var previews: some View {
        NoShadowRoundButton(imageName: "Bg",
                            size: 35,
                            backgroundColor: AppColors.black,
                            tintColor: AppColors.white, action: {
            
        })
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
        .previewDisplayName("Round button")
    }
}
