//
//  View+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import SwiftUI
import UniformTypeIdentifiers

extension View {
    @ViewBuilder func isVisible(_ visible: Bool) -> some View {
        if visible {
            self
        } 
    }

    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self.frame(width: size.width, height: size.height)
    }
    
    @ViewBuilder
    func with(aspectRatio: CGFloat? ) -> some View {
        if let aspectRatio = aspectRatio {
            self.aspectRatio(aspectRatio, contentMode: .fit)
        } else {
            self
        }
    }
}

enum SafeUTType {
    case plainText
    case url
    case image

    @available(iOS 14.0, *)
    var native: UTType {
        switch self {
        case .plainText: return .plainText
        case .url: return .url
        case .image: return .image
        }
    }
}


extension View {
    @ViewBuilder
    func safeOnDrop(of supportedContentTypes: [SafeUTType], isTargeted: Binding<Bool>?, perform action: @escaping ([NSItemProvider]) -> Bool) -> some View {
        if #available(iOS 14.0, *) {
            onDrop(of: supportedContentTypes.map { $0.native }, isTargeted: isTargeted, perform: action)
        } else {
            self
        }
    }

    @ViewBuilder
    func safeOnDrag(_ data: @escaping () -> NSItemProvider) -> some View {
        if #available(iOS 14.0, *) {
            onDrag(data)
        } else {
            self
        }
    }

    @ViewBuilder
    func safeOnDrag<T: View>(_ data: @escaping () -> NSItemProvider, preview: () -> T) -> some View {
        onDrag(data, preview: preview)
//        if #available(iOS 15.0, *) {
//            onDrag(data, preview: preview)
//        } else if #available(iOS 14.0, *) {
//            safeOnDrag(data)
//        } else {
//            self
//        }
    }
}

extension View {
    @ViewBuilder
    func withParallaxCardEffect() -> some View {
        modifier(ParallaxCardEffectMod())
    }
}

private struct ParallaxCardEffectMod: ViewModifier {
    @State private var offset: CGSize = .zero

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(offset2Angle(true), axis: (x: -1, y: 0, z: 0))
            .rotation3DEffect(offset2Angle(), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(offset2Angle(true) * 0.1 , axis: (x: 0, y: 0, z: 1))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offset = value.translation
                    })
                    .onEnded({ value in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.32, blendDuration: 0.32)) {
                            offset = .zero
                        }
                    })
            )
    }

    func offset2Angle(_ isVertical: Bool = false) -> Angle {
        let progress = (isVertical ? offset.height : offset.width) / (isVertical ? screenSize.height : screenSize.width)
        return .init(degrees: progress * 10)
    }

    var screenSize: CGSize  = {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }

        return window.screen.bounds.size
    }()
}

extension View {
    func viewDidLoad(_ onViewDidLoad: @escaping () -> Void) -> some View {
        return self.modifier(ViewDidLoadModifier(onViewDidLoad: onViewDidLoad))
    }
}


private struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let onViewDidLoad: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    onViewDidLoad()
                }
            }
    }
}
