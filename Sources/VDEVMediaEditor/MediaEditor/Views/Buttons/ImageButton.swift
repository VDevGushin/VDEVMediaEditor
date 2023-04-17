//
//  ImageButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//
import SwiftUI

struct ImageButton: View {
    let imageName: String
    let size: CGSize
    let tintColor: Color
    let action: () -> Void
    let fontSize: CGFloat
    let title: String?
    let resize: Bool
    
    init(imageName: String,
         title: String? = nil,
         fontSize: CGFloat = 12,
         size: CGSize = .init(width: 44, height: 44),
         tintColor: Color = AppColors.white,
         resizeImage: Bool = false,
         action: @escaping () -> Void) {
        self.imageName = imageName
        self.size = size
        self.action = action
        self.tintColor = tintColor
        self.fontSize = fontSize
        self.title = title
        self.resize = resizeImage
    }
    
    var body: some View {
        Button {
            haptics(.light)
            action()
        } label: {
            VStack(alignment: .center, spacing: 0) {
                if resize {
                    Image(imageName)
                        .resizable()
                        .frame(width: size.width, height: size.height)
                        .scaledToFit()
                } else {
                    Image(imageName)
                        .frame(width: size.width, height: size.height)
                }
                
                title.map {
                    Text($0)
                        .foregroundColor(tintColor)
                        .font(AppFonts.elmaTrioRegular(fontSize))
                        .padding(.top, 10)
                }
            }
            .clipShape(Rectangle())
        }
    }
}

struct ImageButton_Previews: PreviewProvider {
    static var previews: some View {
        ImageButton(imageName: "BackArrow", size: .init(width: 35, height: 35), tintColor: AppColors.white, action: {
            
        })
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
    }
}
