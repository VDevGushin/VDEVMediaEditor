//
//  StickersDataSource.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import UIKit
import Resolver

public struct StickerItem: GridToolItem {
    static let cellAspect: CGFloat = 1

    var url: URL
    var coverUrl: URL? { url }
    static var contentMode: UIView.ContentMode { .scaleAspectFit }
}

final class StickersDataSource: SectionedDataSource, ObservableObject {
    
    @Published var sections: [Section<StickerItem>] = []

    @Published var isLoading: Bool = false
    
    @Injected private var sourceService: MediaEditorSourceService

    typealias ItemModel = StickerItem
    private let challengeId: String

    init(challengeId: String) {
        self.challengeId = challengeId
    }

    func text(for indexPath: IndexPath) -> String? { nil }

    func selection(for indexPath: IndexPath) -> Bool { false }

    @MainActor
    func load() async {
        isLoading = true
        sections = (try? await loadStickers(forChallenge: challengeId)) ?? []
        isLoading = false
    }
}

private extension StickersDataSource {
    func loadStickers(forChallenge baseChallengeId: String)
    async throws -> [StickersDataSource.Sect] {
        try await sourceService.stickersPack(forChallenge: baseChallengeId).map {
            return StickersDataSource.Sect(name: $0.0, items: $0.1)
        }
    }
}
