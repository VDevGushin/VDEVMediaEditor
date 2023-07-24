//
//  ImageButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 05.04.2023.
//
import SwiftUI

struct ImageButton: View {
    let image: UIImage
    let size: CGSize
    let tintColor: Color
    let action: () -> Void
    let fontSize: CGFloat
    let title: String?
    let resize: Bool
    
    init(image: UIImage,
         title: String? = nil,
         fontSize: CGFloat = 12,
         size: CGSize = .init(width: 44, height: 44),
         tintColor: Color = AppColors.white,
         resizeImage: Bool = false,
         action: @escaping () -> Void) {
        self.image = image
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
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: size.width, height: size.height)
                        .scaledToFit()
                } else {
                    Image(uiImage: image)
                        .frame(width: size.width, height: size.height)
                }
                
                title.map {
                    Text($0)
                        .foregroundColor(tintColor)
                        .font(AppFonts.elmaTrioRegular(fontSize))
                        .padding(.top, 10)
                }
            }
            .background {
                InvisibleTapZoneView {
                    action()
                }
            }
            .clipShape(Rectangle())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
