//
//  FetchSize.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 23.01.2023.
//

import SwiftUI

extension View {
    func fetchSize(_ size: Binding<CGSize>) -> some View {
        modifier(FetchSize(size: size))
    }
    
    func fetchSize(_ callBack: @escaping (CGSize) -> Void) -> some View {
        modifier(FetchSizeWithCallBack(callBack: callBack))
    }
}

private struct FetchSize: ViewModifier {
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { geometryProxy in
                    Color.clear.preference(key: SizeKey.self, value: geometryProxy.size)
                }.onPreferenceChange(SizeKey.self) { preferences in
                    if size != preferences {
                        size = preferences
                    }
                }
            }
    }
}

private struct FetchSizeWithCallBack: ViewModifier {
    let callBack: (CGSize) -> Void
    
    func body(content: Content) -> some View {
        content
            .background {
                GeometryReader { g in
                    Color.clear
                        .preference(key: SizeKey.self, value: g.frame(in: .global).size)
                }
                .onPreferenceChange(SizeKey.self) { preferences in
                    callBack(preferences)
                }
            }
    }
}

private struct SizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}


