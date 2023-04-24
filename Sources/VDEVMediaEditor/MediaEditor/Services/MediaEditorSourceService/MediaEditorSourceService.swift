//
//  MediaEditorSourceService.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.04.2023.
//

import UIKit

public protocol MediaEditorSourceService {
    func filters(forChallenge baseChallengeId: String) async throws -> [EditorFilter]
    
    func textures(forChallenge baseChallengeId: String) async throws -> [EditorFilter]
    
    func masks(forChallenge baseChallengeId: String) async throws -> [EditorFilter]
    
    func editorTemplates(forChallenge baseChallengeId: String, challengeTitle: String, renderSize: CGSize) async throws -> [TemplatePack]
    
    func stickersPack(forChallenge baseChallengeId: String) async throws -> [(String, [StickerItem])]
    
    func challengeTitle(baseChallengeId: String) async throws -> String?
}
