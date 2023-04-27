//
//  MasksDataSource.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.02.2023.
//

import UIKit


class MasksDataSource: SectionedDataSource, ObservableObject {
    typealias ItemModel = EditorFilter
    
    @Injected private var sourceService: VDEVMediaEditorSourceService

    @Published var sections: [Section<ItemModel>] = []
    @Published var isLoading: Bool = false
    private let challengeId: String
    private let item: CanvasItemModel

    init(challengeId: String, item: CanvasItemModel) {
        self.challengeId = challengeId
        self.item = item
    }

    func text(for indexPath: IndexPath) -> String? {
        indexPath.item == 0 ? "No mask" : nil
    }

    func selection(for indexPath: IndexPath) -> Bool {
        item.masks == sections[indexPath.section].items[indexPath.item]
    }

    @MainActor func load() async {
        await MainActor.run { sections = [Section(items: [nil])] }
        isLoading = true
        let newItems = try? await sourceService.masks(forChallenge: challengeId)
        await MainActor.run { sections = [Section(items: [nil] + (newItems ?? []))] }
        isLoading = false
    }
}
