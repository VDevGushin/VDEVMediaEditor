//
//  VDEVMediaEditorSettings.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import Foundation
import Combine

public protocol VDEVMediaEditorResultSettings: AnyObject {
    var needAutoEnhance: Bool { get set }
    var maximumVideoDuration: Double { get }
    var resolution: VDEVMediaResolution { get }
}

public protocol VDEVMediaEditorSettings {
    var needGuideLinesGrid: Bool { get }
    var isInternalModule: Bool { get }
    var aspectRatio: CGFloat? { get }
    
    var baseChallengeId: String { get }
    var title: String { get }
    var withAttach: Bool { get }
    var sourceService: VDEVMediaEditorSourceService { get }
    
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    func getStartTemplate(for size: CGSize, completion: @escaping ([TemplatePack.Variant.Item]?) -> Void)
}
