//
//  LoadingView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 21.02.2023.
//

import SwiftUI

struct LoadingModel {
    let value: Bool
    let message: String?
    let loadingType: LoadingType
    let color: UIColor
    let blurStyle: UIBlurEffect.Style
    let cornerRadius: CGFloat
    let onClose: (() -> Void)?
    
    static func `false`(
        color: UIColor = AppColors.gray.uiColor,
        blurStyle: UIBlurEffect.Style = .systemChromeMaterialDark,
        cornerRadius: CGFloat = 15
    ) -> LoadingModel {
        .init(
            value: false,
            message: nil,
            loadingType: .loading,
            color: color,
            blurStyle: blurStyle,
            cornerRadius: cornerRadius,
            onClose: nil
        )
    }
    
    static func `true`(
        color: UIColor = AppColors.gray.uiColor,
        blurStyle: UIBlurEffect.Style = .systemChromeMaterialDark,
        cornerRadius: CGFloat = 15
    ) -> LoadingModel {
        .init(
            value: true,
            message: DI.resolve(VDEVMediaEditorStrings.self).loading,
            loadingType: .loading,
            color: color,
            blurStyle: blurStyle,
            cornerRadius: cornerRadius,
            onClose: nil
        )
    }
    
    static func processing(
        color: UIColor = AppColors.gray.uiColor,
        blurStyle: UIBlurEffect.Style = .systemChromeMaterialDark,
        cornerRadius: CGFloat = 15
    ) -> LoadingModel {
        .init(
            value: true,
            message: DI.resolve(VDEVMediaEditorStrings.self).processing,
            loadingType: .processing,
            color: color,
            blurStyle: blurStyle,
            cornerRadius: cornerRadius,
            onClose: nil
        )
    }
    
    static func buildMedia(
        color: UIColor = AppColors.gray.uiColor,
        blurStyle: UIBlurEffect.Style = .systemChromeMaterialDark,
        cornerRadius: CGFloat = 15,
        onClose: @escaping () -> Void
    ) -> LoadingModel {
        .init(
            value: true,
            message: DI.resolve(VDEVMediaEditorStrings.self).processing,
            loadingType: .buildMedia,
            color: color,
            blurStyle: blurStyle,
            cornerRadius: cornerRadius,
            onClose: onClose
        )
    }
    
    static func mergeAll(
        color: UIColor = AppColors.gray.uiColor,
        blurStyle: UIBlurEffect.Style = .systemChromeMaterialDark,
        cornerRadius: CGFloat = 15
    ) -> LoadingModel {
        .init(
            value: true,
            message: nil,
            loadingType: .loading,
            color: color,
            blurStyle: blurStyle,
            cornerRadius: cornerRadius,
            onClose: nil
        )
    }
}

enum LoadingType {
    case loading
    case processing
    case buildMedia
}

struct LoadingView: View {
    private var inProgress: Bool
    private let color: UIColor
    private let blurStyle: UIBlurEffect.Style
    private let message: String?
    private let cornerRadius: CGFloat
    private let onClose: (() -> Void)?
    private let loadingType: LoadingType
    
    init(model: LoadingModel) {
        self.inProgress = model.value
        self.color = model.color
        self.blurStyle = model.blurStyle
        self.message = model.message
        self.cornerRadius = model.cornerRadius
        self.onClose = model.onClose
        self.loadingType = model.loadingType
    }
    
    init(inProgress: Bool) {
        let model: LoadingModel = inProgress ? .true() : .false()
        self.inProgress = model.value
        self.color = model.color
        self.blurStyle = model.blurStyle
        self.message = model.message
        self.cornerRadius = model.cornerRadius
        self.onClose = model.onClose
        self.loadingType = model.loadingType
    }
    
    init(
        inProgress: Bool,
        color: UIColor,
        cornerRadius: CGFloat = 15
    ) {
        let model: LoadingModel = inProgress ? .true(color: color, cornerRadius: cornerRadius) : .false(color: color, cornerRadius: cornerRadius)
        self.inProgress = model.value
        self.color = model.color
        self.blurStyle = model.blurStyle
        self.message = model.message
        self.cornerRadius = model.cornerRadius
        self.onClose = model.onClose
        self.loadingType = model.loadingType
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            ActivityIndicator(
                isAnimating: inProgress,
                style: .medium,
                color: color
            )
            
            message.map { message in
                if !message.isEmpty || message != "" {
                    Text(message)
                        .font(AppFonts.gramatika(size: 12))
                        .foregroundColor(Color(color))
                        .multilineTextAlignment(.center)
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
            onClose
                .map { action in
                    CloseButton { action() }
                }
        }
        .visible(
            inProgress,
            animation: .easeOut(duration: 0.4)
        )
        .allowsHitTesting(inProgress ? true : false)
    }
}
