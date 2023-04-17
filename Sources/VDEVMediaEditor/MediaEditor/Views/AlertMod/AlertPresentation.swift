//
//  BannerView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 26.03.2023.
//

import SwiftUI
import Combine

fileprivate  struct Strings {
    static let error = "Error"
    static let ok = "OK"
}

struct AlertData: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let detail: String?
    
    init(title: String, detail: String?) {
        self.title = title
        self.detail = detail
    }
    
    init?(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished: return nil
        case .failure(let error):
            self.title = Strings.error
            self.detail = error.localizedDescription
        }
    }
    
    init(_ error: Error) {
        self.title = Strings.error
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
    
    @Binding private var alertData: AlertData?
    
    init(alertData: Binding<AlertData?>) {
        self._alertData = alertData
    }
    
    func body(content: Content) -> some View {
        content
            .alert(item: $alertData) { data in
                Alert(title: data.title, message: data.detail, dismissButtonTitle: Strings.ok)
            }
    }
}

