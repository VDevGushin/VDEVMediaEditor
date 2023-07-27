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
    let loadingType: LoadingType
    
    static let `false`: LoadingModel = .init(
        value: false,
        message: "",
        loadingType: .loading
    )
    static let `true`: LoadingModel = .init(
        value: true,
        message: DI.resolve(VDEVMediaEditorStrings.self).loading,
        loadingType: .loading
    )
    static let processing: LoadingModel = .init(
        value: true,
        message: DI.resolve(VDEVMediaEditorStrings.self).processing,
        loadingType: .processing
    )
    static let buildMedia: LoadingModel = .init(
        value: true,
        message: DI.resolve(VDEVMediaEditorStrings.self).processing,
        loadingType: .buildMedia
    )
}

enum LoadingType {
    case loading
    case processing
    case buildMedia
}

struct LoadingView: View {
    private var inProgress: Bool
    private let style: UIActivityIndicatorView.Style
    private let color: UIColor
    private let blurStyle: UIBlurEffect.Style
    private let message: String
    private let cornerRadius: CGFloat
    private let showMessage: Bool
    private let onClose: (() -> Void)?
    private let loadingType: LoadingType
    
    init(inProgress: LoadingModel,
         style: UIActivityIndicatorView.Style,
         color: UIColor = AppColors.gray.uiColor,
         blurStyle: UIBlurEffect.Style = .systemChromeMaterialDark,
         cornerRadius: CGFloat = 15,
         showMessage: Bool = true,
         onClose: (() -> Void)? = nil) {
        self.inProgress = inProgress.value
        self.style = style
        self.color = color
        self.blurStyle = blurStyle
        self.message = inProgress.message
        self.cornerRadius = cornerRadius
        self.showMessage = showMessage
        self.onClose = onClose
        self.loadingType = inProgress.loadingType
    }
    
    init(inProgress: Bool,
         style: UIActivityIndicatorView.Style,
         color: UIColor = AppColors.whiteWithOpacity.uiColor,
         blurStyle: UIBlurEffect.Style = .systemChromeMaterialDark,
         cornerRadius: CGFloat = 15,
         showMessage: Bool = true,
         onClose: (() -> Void)? = nil) {
        self.inProgress = inProgress
        self.style = style
        self.color = color
        self.blurStyle = blurStyle
        self.message = ""
        self.cornerRadius = cornerRadius
        self.showMessage = showMessage
        self.onClose = onClose
        self.loadingType = .loading
    }
    
    var body: some View {
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
                        .transition(.opacity)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            switch loadingType {
            case .loading:
                BlurView(style: blurStyle)
            case .processing:
                BlurView(style: blurStyle)
            case .buildMedia:
                TransparentBlurView(removeAllFilters: false)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .clipShape(RoundedCorner(radius: cornerRadius))
        .overlay(alignment: .topTrailing) {
            onClose.map { action in
                CloseButton { action() }
            }
        }
        .visible(inProgress, animation: .easeOut(duration: 0.4))
    }
}
