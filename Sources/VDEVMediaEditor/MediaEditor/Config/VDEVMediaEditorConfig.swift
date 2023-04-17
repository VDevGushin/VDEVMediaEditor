//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 17.04.2023.
//

import Foundation

public struct VDEVMediaEditorConfig {
    // challenge id
    private(set) var baseChallengeId: String
    // network service
    private(set) var networkService: MediaEditorSourceService
    
    public init(challengeId: String, networkService: MediaEditorSourceService) {
        self.baseChallengeId = challengeId
        self.networkService = networkService
    }
}
