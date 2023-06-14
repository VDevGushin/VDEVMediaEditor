//
//  ChangeTemplateButton.swift
//  
//
//  Created by Vladislav Gushin on 09.06.2023.
//

import SwiftUI

struct ChangeTemplateButton: View {
    private let size: CGSize = .init(width: 30, height: 30)
    private let imageSize: CGSize = .init(width: 24, height: 24)
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
                Image(systemName: "arrow.clockwise.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(imageSize)
                    .foregroundColor(AppColors.blackWithOpacity3)
            }
            .contentShape(Circle())
            .clipShape(Circle())
            .frame(size)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct ChangeTemplateButton_Previews: PreviewProvider {
    static var previews: some View {
        ChangeTemplateButton(action: {
            print("test")
        })
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
        
    }
}
