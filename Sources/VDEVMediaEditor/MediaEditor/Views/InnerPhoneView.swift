//
//  InnerPhoneView.swift
//  
//
//  Created by Vladislav Gushin on 29.07.2023.
//

import SwiftUI

extension View {
    func showInnerPhone(_ value: Binding<Bool>) -> some View {
        modifier(InnerPhoneViewModifier(value: value))
    }
}

struct InnerPhoneViewModifier: ViewModifier {
    @Binding var value: Bool
    func body(content: Content) -> some View {
        ZStack {
            AsyncImageView(url: URL.getLocal(fileName: "InnerPhone",
                                             ofType: "jpg")!) {
                Image(uiImage: $0)
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                LoadingView(inProgress: true, style: .medium)
            }
            .edgesIgnoringSafeArea(.all)
            .opacity(value ? 1.0 : 0.0)
            
            content
                .blur(radius: value ? 3 : 0)
                .opacity(value ? 0.5 : 1.0)
        }
    }
}
