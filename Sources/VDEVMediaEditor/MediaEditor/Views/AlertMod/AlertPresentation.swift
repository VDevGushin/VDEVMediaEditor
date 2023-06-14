//
//  BannerView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 26.03.2023.
//

import SwiftUI
import Combine


struct AlertData: Identifiable, Equatable {
    @Injected private var strings: VDEVMediaEditorStrings
    
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
    
    func showRemoveAlert(isPresented: Binding<Bool>,
                         onComfirm: @escaping () -> Void,
                         onCancel: @escaping () -> Void) -> some View {
        modifier(RemoveAllLayersAlertModifier(isPresented: isPresented,
                                              onComfirm: onComfirm, onCancel: onCancel))
    }
}

struct RemoveAllLayersAlertModifier: ViewModifier {
    @Injected private var strings: VDEVMediaEditorStrings
    @Binding private var isPresented: Bool
    private let onComfirm: () -> Void
    private let onCancel: () -> Void
    
    init(isPresented: Binding<Bool>,
         onComfirm: @escaping () -> Void,
         onCancel: @escaping () -> Void) {
        self._isPresented = isPresented
        self.onComfirm = onComfirm
        self.onCancel = onCancel
    }
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                Alert(
                    title: Text(strings.removeAllLayersTitle),
                    message: Text(strings.removeAllLayersSubTitle),
                    primaryButton: .default(
                        Text(strings.confirm),
                        action: confirmAction
                    ),
                    secondaryButton: .destructive(
                        Text(strings.cancel),
                        action: onCancel
                    )
                )
            }
    }
    
    private func confirmAction() {
        onComfirm()
        isPresented = false
    }
    
    private func cancelAction() {
        isPresented = false
    }
}

struct AlertModifier: ViewModifier {
    @Injected private var strings: VDEVMediaEditorStrings
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

