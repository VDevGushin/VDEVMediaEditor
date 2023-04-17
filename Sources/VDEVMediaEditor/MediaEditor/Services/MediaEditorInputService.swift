//
//  AppInputService.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import Foundation

public protocol MediaEditorInputService {
    var baseChallengeId: String { get }
}

final class MediaEditorInputServiceImpl: MediaEditorInputService {
    private(set) var baseChallengeId: String
    
    init(_ baseChallengeId: String) {
        self.baseChallengeId = baseChallengeId
    }
}
