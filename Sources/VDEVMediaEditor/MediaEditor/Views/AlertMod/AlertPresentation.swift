//
//  BannerView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 26.03.2023.
//

import SwiftUI
import Combine
import Resolver

struct AlertData: Identifiable, Equatable {
    @Injected private var strings: VDEVEditorStrings
    
    let id = UUID()
    private(set) var title: String = ""
    private(set) var detail: String?
    
    init(title: String, detail: String?) {
        self.title = title
        self.detail = detail
    }
    
    init?(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished: return nil
        case .failure(let error):
            self.title = strings.error
            self.detail = error.localizedDescription
        }
    }
    
    init(_ error: Error) {
        self.title = strings.error
        self.detail = error.localizedDescription
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}

extension View {
    func showAlert(with alertData: Binding<AlertData?>) -> some View {
        modifier(AlertModifier(alertData: alertData))
    }
}

struct AlertModifier: ViewModifier {
    @Injected private var strings: VDEVEditorStrings
    @Binding private var alertData: AlertData?
    
    init(alertData: Binding<AlertData?>) {
        self._alertData = alertData
    }
    
    func body(content: Content) -> some View {
        content
            .alert(item: $alertData) { data in
                Alert(title: data.title, message: data.detail, dismissButtonTitle: strings.ok)
            }
    }
}

