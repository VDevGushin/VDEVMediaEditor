//
//  InnerRectangleRoundButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 04.04.2023.
//

import SwiftUI

struct InnerRectangleRoundButton: View {
    let imageName: String
    let size: CGSize
    let shadowRadius: CGFloat
    let title: String?
    let tintColor: Color
    let cornerRadius: CGFloat
    let fontSize: CGFloat
    
    let action: () -> Void
    
    init(imageName: String,
         size: CGSize = .init(width: 44, height: 44),
         cornerRadius: CGFloat = 12,
         shadowRadius: CGFloat = 2.0,
         title: String? = nil,
         fontSize: CGFloat = 12.0,
         tintColor: Color = AppColors.white,
         action: @escaping () -> Void) {
        self.imageName = imageName
        self.size = size
        self.fontSize = fontSize
        self.action = action
        self.shadowRadius = shadowRadius
        self.title = title
        self.tintColor = tintColor
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        Button {
            haptics(.light)
            action()
        } label: {
            VStack(alignment: .center, spacing: 0) {
                Image(imageName)
                    .frame(width: size.width, height: size.height)
                    .background(AppColors.blackInvisible)
                    .overlay{
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(tintColor, lineWidth: 1)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                
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

struct InnerRectangleRoundButton_Previews: PreviewProvider {
    static var previews: some View {
        InnerRectangleRoundButton(imageName: "TypeCamera",
                               size: .init(width: 44, height: 44),
                               title: "CLOSE",
                                  tintColor: AppColors.whiteWithOpacity) {
            
        }
                               .previewLayout(.sizeThatFits)
                               .padding()
                               .background(Color(.systemBackground))
                               .previewDisplayName("Round button")
    }
}
