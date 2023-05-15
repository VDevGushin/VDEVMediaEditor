//
//  CanvasUISettingsViewModel.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 02.02.2023.
//

import SwiftUI
import Combine


final class CanvasUISettingsViewModel: ObservableObject {
    @Injected private var settings: VDEVMediaEditorSettings
    
    @Published var mainLayerBackgroundColor: Color = .init(hexadecimal: "0d0e0e")
    @Published var showVerticalCenter: Bool = false
    @Published var showHorizontalCenter: Bool = false
    
    // получаем фактический размер канваса редактора
    @Published var editorSize: CGSize = .zero
    @Published private(set) var guideLinesColor: Color = AppColors.white
    @Published private(set) var aspectRatio: CGFloat? = nil

    var canvasCornerRadius: CGFloat { 16 }
    var bottomBarHeight: CGFloat { 76 }
    
    var needGuideLinesGrid: Bool {
        settings.needGuideLinesGrid
    }

    private var storage: Set<AnyCancellable> = Set()
    private var colorOp: AnyCancellable?

    init() {
        // необходимо инверсить гайд цвета при смене главного фона
        // чтобы не сливались цвета
        colorOp = $mainLayerBackgroundColor
            .receive(on: DispatchQueue.global())
            .map { UIColor($0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                let color = Color(uiColor: value.contrast(dark: .orange))
                self.guideLinesColor = color
            }
        
        aspectRatio = settings.aspectRatio
    }
    
    func setAspectRatio(_ value: CGFloat?) {
        withAnimation(.interactiveSpring()) {
            self.aspectRatio = value
        }
    }
}
