//
//  TransparentBlurView.swift
//  
//
//  Created by Vladislav Gushin on 25.07.2023.
//

import SwiftUI

extension View {
    func transparentBlurBackground(
        radius: CGFloat = 9,
        blurStyle: UIBlurEffect.Style = .regular,
        opacity: @escaping () -> CGFloat
    ) -> some View {
        modifier(
            TransparentBlurViewMod(
                radius: radius,
                blurStyle: blurStyle,
                opacity: opacity
            )
        )
    }
    
    func transparentBlurBackground(
        radius: CGFloat = 9,
        blurStyle: UIBlurEffect.Style = .regular
    ) -> some View {
        modifier(
            TransparentBlurViewMod(
                radius: radius,
                blurStyle: blurStyle,
                opacity: { return 1 }
            )
        )
    }
}

private struct TransparentBlurViewMod: ViewModifier {
    let radius: CGFloat
    let blurStyle: UIBlurEffect.Style
    let opacity: () -> CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(
                TransparentBlurView(
                    removeAllFilters: true,
                    blurStyle: blurStyle
                )
                .blur(radius: radius, opaque: true)
                .clipShape(
                    RoundedCorner(
                        radius: 16,
                        corners: [.topLeft, .topRight]
                    )
                )
                .edgesIgnoringSafeArea([.bottom, .trailing, .leading])
                .opacity(opacity())
            )
    }
}

struct TransparentBlurView: UIViewRepresentable {
    let removeAllFilters: Bool
    let blurStyle: UIBlurEffect.Style
    init(
        removeAllFilters: Bool = false,
        blurStyle: UIBlurEffect.Style = .systemUltraThinMaterialDark
    ) {
        self.removeAllFilters = removeAllFilters
        self.blurStyle = blurStyle
    }
    
    func makeUIView(context: Context) -> TransparentBlurViewHelper {
        let view = TransparentBlurViewHelper(
            removeAllFilters: removeAllFilters,
            blurStyle: blurStyle
        )
        return view
    }
    
    func updateUIView(_ uiview: TransparentBlurViewHelper, context: Context) { }
}

final class TransparentBlurViewHelper: UIVisualEffectView {
    init(
        removeAllFilters: Bool,
        blurStyle: UIBlurEffect.Style
    ) {
        super.init(effect: UIBlurEffect (style: blurStyle))
        
        if subviews.indices.contains(1) {
            subviews[1].alpha = 0
        }
        
        if let backdropLayer = layer.sublayers?.first {
            if removeAllFilters {
                backdropLayer.filters = []
            } else {
                backdropLayer.filters?.removeAll(where: { filter in
                    String(describing: filter) != "gaussianBlur" })
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    }
}
