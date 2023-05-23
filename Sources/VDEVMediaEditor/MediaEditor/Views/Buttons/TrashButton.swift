//
//  TrashButton.swift
//  
//
//  Created by Vladislav Gushin on 23.05.2023.
//

import SwiftUI

struct ChangeTemplateButton: View {
    private let size: CGSize = .init(width: 35, height: 35)
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
                Image(systemName: "arrow.uturn.right.square")
                    .resizable()
                    .scaledToFit()
                    .frame(imageSize)
                    .foregroundColor(AppColors.black)
            }
            .contentShape(Circle())
            .clipShape(Circle())
            .frame(size)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}


struct TrashButton2: View {
    private let size: CGSize = .init(width: 35, height: 35)
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
                Image(systemName: "clear")
                    .resizable()
                    .scaledToFit()
                    .frame(imageSize)
                    .foregroundColor(AppColors.black)
            }
            .contentShape(Circle())
            .clipShape(Circle())
            .frame(size)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct TrashButton: View {
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
                Image(systemName: "trash")
                    .resizable()
                    .scaledToFit()
                    .frame(imageSize)
                    .foregroundColor(AppColors.red)
            }
            .contentShape(Circle())
            .clipShape(Circle())
            .frame(size)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

struct TrashButton_Previews: PreviewProvider {
    static var previews: some View {
        TrashButton(action: {
            print("test")
        })
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemBackground))
    }
}
