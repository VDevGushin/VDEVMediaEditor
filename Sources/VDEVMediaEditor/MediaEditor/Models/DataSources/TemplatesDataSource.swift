//
//  TemplatesDataSource.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 16.02.2023.
//

import UIKit
import CollectionConcurrencyKit
import Resolver

class TemplatesDataSource: SectionedDataSource, ObservableObject {
    typealias ItemModel = TemplatePack
    
    @Injected private var sourceService: MediaEditorSourceService

    @Published var sections: [Section<TemplatePack>] = []
    @Published var isLoading: Bool = false
    private let challengeId: String
    private let challengeTitle: String
    private let renderSize: CGSize

    init(challengeId: String, challengeTitle: String, renderSize: CGSize) {
        self.challengeId = challengeId
        self.challengeTitle = challengeTitle
        self.renderSize = renderSize
    }

    func text(for indexPath: IndexPath) -> String? { nil }
    func selection(for indexPath: IndexPath) -> Bool { false }

    @MainActor func load() async {
        await MainActor.run { sections = [.init(items: [])] }
        isLoading = true
        
        let newItems = try? await sourceService.editorTemplates(
            forChallenge: challengeId,
            challengeTitle: challengeTitle,
            renderSize: renderSize
        )

        await MainActor.run { sections = [.init(items: [nil] + (newItems ?? []))] }
        isLoading = false
    }
}
