//
//  PublishButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.04.2023.
//

import SwiftUI
import Resolver

struct PublishButton: View {
    @Injected private var strings: VDEVMediaEditorStrings
    
    private let size: CGSize = .init(width: 75, height: 45)
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
                RoundedRectangle(cornerRadius: 15)
                    .fill(AppColors.white)
                    .shadow(color: AppColors.whiteWithOpacity,
                            radius: 8, x: 0, y: 0)
                
                Text(strings.publish)
                    .font(AppFonts.elmaTrioRegular(14))
                    .foregroundColor(AppColors.black)
                    .shadow(radius: 5)
            }
            .frame(size)
        }
    }
}

struct PublishButton_Previews: PreviewProvider {
    static var previews: some View {
        PublishButton(action: {
            print("test")
        })
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
    }
}
