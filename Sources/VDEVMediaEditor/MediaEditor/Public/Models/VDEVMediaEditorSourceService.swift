//
//  VDEVMediaEditorSourceService.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.04.2023.
//

import UIKit

// Сервисы для загрузки всякой всячины для редактора
public struct StartMetaConfig {
    public let isAttachedTemplate: Bool
    public let title: String
    public let subTitle: String
    
    public init(isAttachedTemplate: Bool, title: String, subTitle: String) {
        self.isAttachedTemplate = isAttachedTemplate
        self.title = title
        self.subTitle = subTitle.uppercased()
    }
}

public protocol VDEVMediaEditorSourceService {
    func filters(forChallenge baseChallengeId: String) async throws -> [EditorFilter]
    
    func neuralFilters(forChallenge baseChallengeId: String) async throws -> [NeuralEditorFilter]
    
    func textures(forChallenge baseChallengeId: String) async throws -> [EditorFilter]
    
    func masks(forChallenge baseChallengeId: String) async throws -> [EditorFilter]
    
    func editorTemplates(forChallenge baseChallengeId: String,
                         challengeTitle: String,
                         renderSize: CGSize) async throws -> [TemplatePack]
    
    func stickersPack(forChallenge baseChallengeId: String) async throws -> [(String, [StickerItem])]
    
    func startMeta(forChallenge baseChallengeId: String) async -> StartMetaConfig?
}
