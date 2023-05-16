//
//  IsometricView.swift
//  
//
//  Created by Vladislav Gushin on 16.05.2023.
//

import SwiftUI

struct IsometricVideo: View {
    let model: EditorPreview.Content
    @EnvironmentObject private var vm: CanvasEditorViewModel
    
    @State private var animate: Bool = true
    @State private var b: CGFloat = -0.2
    @State private var c: CGFloat = -0.3
    
    var body: some View {
        IsometricView(depth: animate == true ? 45 : 0) {
            if animate {
                ZStack {
                    AsyncImageView(url: model.cover) { img in
                        Image(uiImage: img)
                            .resizable()
                            .aspectRatio(vm.ui.aspectRatio, contentMode: .fill)
                            .clipped()
                    } placeholder: {
                        AppColors.blackWithOpacity
                    }
                    
                    ResultVideoPlayer(assetURL: model.url,
                                      cornerRadius: 0,
                                      aspectRatio: vm.ui.aspectRatio)
                }
            } else {
                ResultVideoPlayer(assetURL: model.url,
                                  cornerRadius: 15,
                                  aspectRatio: vm.ui.aspectRatio)
            }
        } bottom: {
            AsyncImageView(url: model.cover) { img in
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(vm.ui.aspectRatio, contentMode: .fill)
                    .clipped()
            } placeholder: {
                AppColors.blackWithOpacity
            }
        } side: {
            AsyncImageView(url: model.cover) { img in
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(vm.ui.aspectRatio, contentMode: .fill)
                    .clipped()
            } placeholder: {
                AppColors.blackWithOpacity
            }
        }
        .modifier(CustomProjection(b: b, c: c))
        .rotation3DEffect(.degrees(animate == true ? 45: 0), axis: (x: 0, y: 0, z: 1))
        .scaleEffect(animate == true ? 0.3: 1)
        .offset(x: animate == true ? 12: 0)
        .onAppear {
            withAnimation(.interactiveSpring(response: 0.4,
                                             dampingFraction: 0.6,
                                             blendDuration: 0.6)){
                animate = false
                b = 0
                c = 0
            }
        }
        .onTapGesture {
            makeHaptics()
            if animate == true {
                withAnimation(.interactiveSpring(response: 0.4,
                                                 dampingFraction: 0.9,
                                                 blendDuration: 0.6)){
                    animate = false
                    b = 0
                    c = 0
                }
            } else {
                withAnimation(.interactiveSpring(response: 0.4,
                                                 dampingFraction: 0.6,
                                                 blendDuration: 0.6)){
                    animate = true
                    b = -0.2
                    c = -0.3
                }
            }
        }
    }
}

struct IsometricImage: View {
    let image: UIImage
    @State private var animate: Bool = true
    @State private var b: CGFloat = -0.2
    @State private var c: CGFloat = -0.3

    var body: some View {
        IsometricView(depth: animate == true ? 45 : 0) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        } bottom: {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        } side: {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        }
        .modifier(CustomProjection(b: b, c: c))
        .rotation3DEffect(.degrees(animate == true ? 45: 0), axis: (x: 0, y: 0, z: 1))
        .scaleEffect(animate == true ? 0.3: 1)
        .offset(x: animate == true ? 12: 0)
        .onAppear {
            withAnimation(.interactiveSpring(response: 0.4,
                                             dampingFraction: 0.6,
                                             blendDuration: 0.6)){
                animate = false
                b = 0
                c = 0
            }
        }
        .onTapGesture {
            makeHaptics()
            if animate == true {
                withAnimation(.interactiveSpring(response: 0.4,
                                                 dampingFraction: 0.9,
                                                 blendDuration: 0.6)){
                    animate = false
                    b = 0
                    c = 0
                }
            } else {
                withAnimation(.interactiveSpring(response: 0.4,
                                                 dampingFraction: 0.6,
                                                 blendDuration: 0.6)){
                    animate = true
                    b = -0.2
                    c = -0.3
                }
            }
        }
    }
}

private struct TestIsometric: View {
    @State private var animate: Bool = false
    @State private var b: CGFloat = 0
    @State private var c: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 20) {
            IsometricView(depth: animate == true ? 25 : 0) {
                Color.red
            } bottom: {
                Color.black
            } side: {
                Color.black
            }
            .modifier(CustomProjection(b: b, c: c))
            .frame(width: 180, height: 330)
            
            .rotation3DEffect(.degrees(animate == true ? 45: 0), axis: (x: 0, y: 0, z: 1))
            .scaleEffect(animate == true ? 0.2: 1)
            .offset(x: animate == true ? 12: 0)
            
            HStack {
                Button("View1") {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                        animate = true
                        b = -0.2
                        c = -0.3
                    }
                }
                .buttonStyle(.bordered)
                .tint(.blue)
                
                Button("Reset") {
                    withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
                        animate = false
                        b = 0
                        c = 0
                    }
                }
                .buttonStyle(.bordered)
                .tint(.blue)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

private struct CustomProjection: GeometryEffect {
    var b: CGFloat
    var c: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatablePair(b, c)
        }
        set {
            b = newValue.first
            c = newValue.second
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        return .init(.init(a: 1, b: b, c: c, d: 1, tx: 0, ty: 0))
    }
}

struct TestIsometric_Previews: PreviewProvider {
    static var previews: some View {
        TestIsometric()
    }
}

private struct IsometricView<Content: View, Bottom: View, Side: View> : View {
    var content: Content
    var bottom: Bottom
    var side: Side
    
    var depth: CGFloat
    
    init(depth: CGFloat,
         @ViewBuilder content: @escaping () -> Content,
         @ViewBuilder bottom: @escaping () -> Bottom,
         @ViewBuilder side: @escaping () -> Side) {
        self.depth = depth
        self.content = content()
        self.bottom = bottom()
        self.side = side()
    }
    
    var body: some View {
        Color.clear
            .overlay {
                GeometryReader { proxy in
                    let size = proxy.size
                    
                    ZStack {
                        content
                        DepthView(isBottom: true, size: size)
                        DepthView(isBottom: false, size: size)
                    }
                    .frame(width: size.width, height: size.height)
                }
            }
    }
    
    @ViewBuilder
    func DepthView(isBottom: Bool = false, size: CGSize) -> some View {
        ZStack {
            if isBottom {
                bottom
                    .scaleEffect(y: depth, anchor: .bottom)
                    .frame(height: depth, alignment: .bottom)
                    .overlay {
                        Rectangle()
                            .fill(Color.black.opacity(0.25))
                            .blur(radius: 2.5)
                    }
                    .clipped()
                    .projectionEffect(.init(.init(a: 1, b: 0, c: 1, d: 1, tx: 0, ty: 0)))
                    .offset(y: depth)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            } else {
                side
                    .scaleEffect(x: depth, anchor: .trailing)
                    .frame(width: depth, alignment: .trailing)
                    .overlay {
                        Rectangle()
                            .fill(Color.black.opacity(0.25))
                            .blur(radius: 2.5)
                    }
                    .clipped()
                    .projectionEffect(.init(.init(a: 1, b: 1, c: 0, d: 1, tx: 0, ty: 0)))
                    .offset(x: depth)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
