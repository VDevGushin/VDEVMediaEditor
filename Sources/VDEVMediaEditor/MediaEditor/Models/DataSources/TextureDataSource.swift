//
//  TextureDataSource.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.02.2023.
//

import UIKit
import Resolver

class TextureDataSource: SectionedDataSource, ObservableObject {
    typealias ItemModel = EditorFilter
    
    @Injected private var sourceService: VDEVMediaEditorSourceService

    @Published var sections: [Section<EditorFilter>] = []
    @Published var isLoading: Bool = false
    private let challengeId: String
    private let item: CanvasItemModel

    init(challengeId: String, item: CanvasItemModel) {
        self.challengeId = challengeId
        self.item = item
    }

    func text(for indexPath: IndexPath) -> String? {
        indexPath.item == 0 ? "No texture" : nil
    }

    func selection(for indexPath: IndexPath) -> Bool {
        item.textures == sections[indexPath.section].items[indexPath.item]
    }

    @MainActor func load() async {
        await MainActor.run { sections = [.init(items: [nil])] }
        isLoading = true
        let newItems = try? await sourceService.textures(forChallenge: challengeId)
        await MainActor.run { sections = [.init(items: [nil] + (newItems ?? []))] }
        isLoading = false
    }
}
