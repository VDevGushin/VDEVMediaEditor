//
//  ShareButton.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import SwiftUI
import Resolver

struct ShareButton: View {
    @Injected private var images: VDEVImageConfig
    @Injected private var strings: VDEVMediaEditorStrings
    
    private let size: CGSize = .init(width: 100, height: 45)
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
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColors.shareButtonsColors)
                
                HStack {
                    Image(uiImage: images.common.share)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(strings.shareOrSave)
                        .font(AppFonts.elmaTrioRegular(13))
                        .foregroundColor(AppColors.whiteWithOpacity1)
                        .shadow(radius: 5)
                }
            }
            .frame(size)
        }
    }
}
