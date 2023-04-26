//
//  VDEVMediaEditorSettings.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import Foundation

public protocol VDEVMediaEditorSettings {
    var baseChallengeId: String { get }
    var title: String { get }
    var withAttach: Bool { get }
    var resolution: VDEVMediaResolution { get }
    var sourceService: VDEVMediaEditorSourceService { get }
}
