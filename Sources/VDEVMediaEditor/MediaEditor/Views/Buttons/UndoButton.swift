//
//  UndoButton.swift
//  
//
//  Created by Vladislav Gushin on 25.04.2023.
//

import SwiftUI

struct UndoButton: View {
    @Injected private var images: VDEVImageConfig
    
    private let size: CGSize = .init(width: 35, height: 35)
    private let imageSize: CGSize = .init(width: 16, height: 16)
    
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
                Image(systemName: "arrow.uturn.left")
                    .resizable()
                    .scaledToFit()
                    .frame(imageSize)
            }
            .contentShape(Circle())
            .clipShape(Circle())
            .frame(size)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

