//
//  TransparentBlurView.swift
//  
//
//  Created by Vladislav Gushin on 25.07.2023.
//

import SwiftUI

struct TransparentBlurView: UIViewRepresentable {
    var removeAllFilters: Bool = false
    
    func makeUIView(context: Context) -> TransparentBlurViewHelper {
        let view = TransparentBlurViewHelper(removeAllFilters: removeAllFilters)
        return view
    }
    
    func updateUIView(_ uiview: TransparentBlurViewHelper, context: Context) { }
}

final class TransparentBlurViewHelper: UIVisualEffectView {
    init(removeAllFilters: Bool) {
        super.init(effect: UIBlurEffect (style: .systemUltraThinMaterialDark))
        
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
