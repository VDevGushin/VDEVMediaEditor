//
//  HeadWithTitle.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import SwiftUI

struct HeadWithTitle: View {
    let title: String
    let returnPressed: () -> ()

    var body: some View {
        HStack {
            Button {
                makeHaptics()
                returnPressed()
            } label: {
                HStack(spacing: 15) {
                    
                    Image("BackArrow")
                        .frame(width: 30, height: 30)
                        .background(
                            BlurView(style: .systemChromeMaterialDark)
                                .clipShape(Circle())
                        )
                    
                    
                    Text(title)
                        .font(.gramatika(size: 24))
                        .shadow(radius: 5)

                    Spacer()
                }
            }
        }
        .foregroundColor(AppColors.white)
    }
}
