//
//  CloseButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 07.04.2023.
//

import SwiftUI

struct CloseButton: View {
    private let imageName: String = "Xmark"
    private let size: CGSize = .init(width: 35, height: 35)
    private let imageSize: CGSize = .init(width: 12, height: 12)
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button {
            haptics(.light)
            action()
        } label: {
            ZStack {
                AppColors.blackInvisible
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(imageSize)
            }
            .contentShape(Circle())
            .clipShape(Circle())
            .frame(size)
        }
    }
}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton(action: {
            print("test")
        })
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
    }
}
