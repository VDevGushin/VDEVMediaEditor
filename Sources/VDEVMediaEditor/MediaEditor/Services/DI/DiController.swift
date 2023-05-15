//
//  DiController.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.04.2023.
//

import Foundation

struct DiController {
    static func register(with container: DIContainer = DIContainer.shared,
                         settings: VDEVMediaEditorSettings,
                         dataService: VDEVMediaEditorSourceService,
                         images: VDEVImageConfig,
                         strings: VDEVMediaEditorStrings,
                         resultSettings: VDEVMediaEditorResultSettings,
                         logger: VDEVLogger?) {
        container.register(type: VDEVMediaEditorSettings.self, service: settings)
        container.register(type: VDEVMediaEditorResultSettings.self, service: resultSettings)
        container.register(type: VDEVMediaEditorSourceService.self, service: dataService)
        container.register(type: VDEVImageConfig.self, service: images)
        container.register(type: VDEVMediaEditorStrings.self, service: strings)
        container.register(type: PasteboardService.self, service: PasteboardService())
        
        if let logger = logger {
            container.register(type: VDEVLogger.self, service: logger)
        }
    }
    
    static func clean(with container: DIContainer = DIContainer.shared) {
        container.clean()
    }
}
