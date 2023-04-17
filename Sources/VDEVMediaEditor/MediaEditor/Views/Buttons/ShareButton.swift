//
//  ShareButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import SwiftUI

struct ShareButton: View {
    struct Strings {
        static let publish = "SHARE"
    }
    
    private let height: CGFloat = 40
    private let action: () -> Void
    private let shareImage = "Share"
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button {
            haptics(.light)
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.shareButtonsColors)
                
                HStack {
                    Image(shareImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(Strings.publish)
                        .font(AppFonts.elmaTrioRegular(13))
                        .foregroundColor(AppColors.whiteWithOpacity1)
                        .shadow(radius: 5)
                }
            }
            .frame(height: height)
            .frame(minHeight: 100)
        }
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        ShareButton(action: {
            print("test")
        })
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
    }
}
