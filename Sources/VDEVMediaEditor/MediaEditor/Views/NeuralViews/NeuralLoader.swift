//
//  NeuralLoader.swift
//  
//
//  Created by Vladislav Gushin on 22.08.2023.
//

import SwiftUI

enum ProgresOperationType {
    case simple
    case neural(UIImage?)
    
    static func simple(fromAdjustment: Bool) -> ProgresOperationType? {
        guard fromAdjustment else {
            return .simple
        }
        return nil
    }
    
    static func neural(
        withNeural: Bool,
        fromAdjustment: Bool = false,
        image: UIImage? = nil
    ) -> ProgresOperationType? {
        if withNeural {
            return .neural(image)
        }
        if !fromAdjustment {
            return .simple
        }
        return nil
    }
}

struct NeuralLoader: View {
    @Injected private var strings: VDEVMediaEditorStrings
    private var message: String = ""
    let progresOperationType: ProgresOperationType?
    let guideLinesColor: Color
    
    init(
        message: String? = nil,
        progresOperationType: ProgresOperationType?,
        guideLinesColor: Color
    ) {
        self.progresOperationType = progresOperationType
        self.guideLinesColor = guideLinesColor
        self.message = message ?? strings.doingSomeMagic
    }
    
    var body: some View {
        progresOperationType.map {
            switch $0 {
            case .simple:
                ActivityIndicator(
                    isAnimating: true,
                    style: .medium,
                    color: .init(guideLinesColor)
                )
            case let .neural(image):
                ZStack {
                    image.map {
                        Image(uiImage: $0)
                            .resizable()
                            .scaledToFill()
                    }
                    
                    ZStack {
                        TransparentBlurView(
                            removeAllFilters: false,
                            blurStyle: .systemChromeMaterialDark
                        )
                        
                        AnimatedGradientViewVertical(
                            color: AppColors.redWithOpacity,
                            duration: 3
                        )
                    }
                    
                    VStack(alignment: .center) {
                        Text(message)
                            .multilineTextAlignment(.center)
                            .font(AppFonts.gramatika(size: 16))
                            .foregroundColor(AppColors.white)
                        
                        ActivityIndicator(
                            isAnimating: true,
                            style: .medium,
                            color: .init(guideLinesColor)
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}
