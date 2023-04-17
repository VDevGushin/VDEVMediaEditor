//
//  InnerShadowRoundButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.04.2023.
//

import SwiftUI

struct InnerShadowRoundButton: View {
    let imageName: String
    let size: CGFloat
    let shadowRadius: CGFloat
    let title: String?
    let tintColor: Color
    let fontSize: CGFloat
    let action: () -> Void
    
    init(imageName: String,
         size: CGFloat = 44,
         shadowRadius: CGFloat = 2.0,
         title: String? = nil,
         fontSize: CGFloat = 12.0,
         tintColor: Color = AppColors.white,
         action: @escaping () -> Void) {
        self.imageName = imageName
        self.size = size
        self.action = action
        self.shadowRadius = shadowRadius
        self.title = title
        self.tintColor = tintColor
        self.fontSize = fontSize
    }
    
    var body: some View {
        
        Button {
            haptics(.light)
            action()
        } label: {
            VStack(alignment: .center, spacing: 0) {
                
                ZStack {
                    AppColors.blackInvisible
                        .clipShape(Circle())
                    
                    Image(imageName)
                        .cornerRadius(size / 2)
                }
                .frame(width: size, height: size)
                
                .overlay(
                    Circle()
                        .strokeBorder(tintColor, lineWidth: 1)
                )
                
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


struct InnerShadowRoundButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InnerShadowRoundButton(imageName: "TypeStickers",
                                   size: 35,
                                   title: "CLOSE",
                                   tintColor: AppColors.test2) {
                
            }
                                   .previewLayout(.sizeThatFits)
                                   .padding()
                                   .background(Color(.systemBackground))
                                   .previewDisplayName("Close button")
            
        }
    }
}
