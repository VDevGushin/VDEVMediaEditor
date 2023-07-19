//
//  LoadingView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 21.02.2023.
//

import SwiftUI

struct LoadingModel {
    let value: Bool
    let message: String
    
    static let `false`: LoadingModel = .init(value: false, message: "")
    static let `true`: LoadingModel = .init(
        value: true,
        message: DI.resolve(VDEVMediaEditorStrings.self).loading
    )
    static let processing: LoadingModel = .init(
        value: true,
        message: DI.resolve(VDEVMediaEditorStrings.self).processing
    )
}

struct LoadingView: View {
    private var inProgress: Bool
    private let style: UIActivityIndicatorView.Style
    private let color: UIColor
    private let blurStyle: UIBlurEffect.Style
    private let message: String
    private let cornerRadius: CGFloat
    private let showMessage: Bool

    init(inProgress: LoadingModel,
         style: UIActivityIndicatorView.Style,
         color: UIColor = AppColors.gray.uiColor,
         blurStyle: UIBlurEffect.Style = .systemChromeMaterialDark,
         cornerRadius: CGFloat = 15,
         showMessage: Bool = true) {
        self.inProgress = inProgress.value
        self.style = style
        self.color = color
        self.blurStyle = blurStyle
        self.message = inProgress.message
        self.cornerRadius = cornerRadius
        self.showMessage = showMessage
    }
    
    init(inProgress: Bool,
         style: UIActivityIndicatorView.Style,
         color: UIColor = AppColors.whiteWithOpacity.uiColor,
         blurStyle: UIBlurEffect.Style = .systemChromeMaterialDark,
         cornerRadius: CGFloat = 15,
         showMessage: Bool = true) {
        self.inProgress = inProgress
        self.style = style
        self.color = color
        self.blurStyle = blurStyle
        self.message = ""
        self.cornerRadius = cornerRadius
        self.showMessage = showMessage
    }
    
    var body: some View {
        if inProgress {
            VStack(alignment: .center) {
                ActivityIndicator(isAnimating: inProgress, style: style, color: color)
                
                if showMessage {
                    if !message.isEmpty || message != "" {
                        Text(message)
                            .font(AppFonts.gramatika(size: 12))
                            .foregroundColor(Color(color))
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BlurView(style: blurStyle))
            .clipShape(RoundedCorner(radius: cornerRadius))
            .transition(.opacityTransition())
        }
    }
}
