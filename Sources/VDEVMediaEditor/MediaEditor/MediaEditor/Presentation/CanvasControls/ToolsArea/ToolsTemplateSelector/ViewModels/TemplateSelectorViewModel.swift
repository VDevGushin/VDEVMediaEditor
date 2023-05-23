//
//  TemplateSelectorViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 16.02.2023.
//

import Foundation
import Combine

final class TemplateSelectorViewModel: ObservableObject {
    @Published var templatePack: TemplatePack?
    @Published var selectedVariantIdx: Int?
    @Published var templatePackForPreview: TemplatePack?
    @Published var isLoading: Bool = false
    @Published private(set) var templatesDataSource: TemplatesDataSource
    @Published private(set) var layers: [TemplatePack.Variant.Item] = []
    @Published private(set) var canShowDoneButton: Bool = false

    private var challengeTitle: String
    private let fitCanvasSize: CGSize
    private let challengeId: String
    private var onClose: ([TemplatePack.Variant.Item]) -> Void
    private var storage: Set<AnyCancellable> = Set()

    init(fitCanvasSize: CGSize,
         challengeId: String,
         challengeTitle: String = "",
         onClose: @escaping ([TemplatePack.Variant.Item]) -> Void) {
        self.fitCanvasSize = fitCanvasSize
        self.challengeId = challengeId
        self.challengeTitle = challengeTitle
        self.onClose = onClose
        self.templatesDataSource = TemplatesDataSource(challengeId: self.challengeId,
                                                       challengeTitle: "",
                                                       renderSize: self.fitCanvasSize)

        $layers
            .map { !$0.isEmpty }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.canShowDoneButton = value
            }
            .store(in: &storage)
        
    }

    var selectedVariant: (packId: String, variantId: String)? {
        guard let templatePack = templatePack,
              let selectedVariantIdx = selectedVariantIdx else { return nil }
        return (templatePack.id, templatePack.variants[selectedVariantIdx].id)
    }

    @MainActor
    func setTemplatePack(_ templatePack: TemplatePack, variantIdx: Int) {

        self.templatePack = templatePack
        self.selectedVariantIdx = variantIdx
        self.challengeTitle = templatePack.name
        
        rebuildTemplatesDataSource()

        isLoading = true
        layers = templatePack.makeVariantLayers(variantIdx: variantIdx)
        isLoading = false
        select()
    }

    func exit() {
        onClose([])
    }

    func select() {
        onClose(layers)
    }

    func resetDataSource() {
        templatePackForPreview = nil
        challengeTitle = ""
        rebuildTemplatesDataSource()
    }

    func clearSelectedTool() {
        templatePackForPreview = nil
    }

    private func rebuildTemplatesDataSource() {
        self.templatesDataSource = TemplatesDataSource(challengeId: self.challengeId,
                                                       challengeTitle: self.challengeTitle,
                                                       renderSize: self.fitCanvasSize)
    }
}

