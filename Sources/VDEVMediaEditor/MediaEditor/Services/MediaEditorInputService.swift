//
//  AppInputService.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import Foundation

public protocol MediaEditorInputService {
    var baseChallengeId: String { get }
    var title: String { get }
}

final class MediaEditorInputServiceImpl: MediaEditorInputService {
    private(set) var baseChallengeId: String
    private(set) var title: String = ""
    private let service: MediaEditorSourceService
    
    init(_ baseChallengeId: String, service: MediaEditorSourceService) {
        self.baseChallengeId = baseChallengeId
        self.service = service
        getTitle()
    }
    
    private func getTitle() {
        Task {
            let title =  try? await service.challengeTitle(baseChallengeId: baseChallengeId) ?? ""
            await MainActor.run { [weak self] in self?.title = title ?? "" }
        }
    }
}
