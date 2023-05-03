//
//  VDEVMediaEditorSettings.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import Foundation
import Combine

public protocol VDEVMediaEditorSettings {
    var baseChallengeId: String { get }
    var title: String { get }
    var withAttach: Bool { get }
    var maximumVideoDuration: Double { get }
    var resolution: VDEVMediaResolution { get }
    var isInternalModule: Bool { get }
    var aspectRatio: CGFloat? { get }
    var sourceService: VDEVMediaEditorSourceService { get }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    
    func getStartTemplate(for size: CGSize, completion: @escaping ([TemplatePack.Variant.Item]?) -> Void)
}
