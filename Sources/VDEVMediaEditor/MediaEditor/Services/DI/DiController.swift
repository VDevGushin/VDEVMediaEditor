//
//  DiController.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.04.2023.
//

import Foundation

struct DiController {
    static func register(
        with container: DIContainer = DIContainer.shared,
        settings: VDEVMediaEditorSettings,
        dataService: VDEVMediaEditorSourceService,
        images: VDEVImageConfig,
        strings: VDEVMediaEditorStrings,
        resultSettings: VDEVMediaEditorResultSettings,
        logger: VDEVLogger?,
        networkModulesConfig: [VDEVNetworkModuleConfig]
    ) {
        let resolutionService = ResolutionService(resolution: resultSettings.resolution)
        
        container.register(type: VDEVMediaEditorSettings.self,
                           service: settings)
        container.register(type: VDEVMediaEditorResultSettings.self,
                           service: resultSettings)
        container.register(type: VDEVMediaEditorSourceService.self,
                           service: dataService)
        container.register(type: VDEVImageConfig.self,
                           service: images)
        container.register(type: VDEVMediaEditorStrings.self,
                           service: strings)
        container.register(type: PasteboardService.self,
                           service: PasteboardService())
        container.register(type: ResolutionService.self,
                           service: resolutionService)
        container.register(type: MementoService.self,
                           service: MementoService(settings: settings))
        
        registerNetworkConfig(with: container, networkModulesConfig: networkModulesConfig)
        
        if let logger = logger {
            container.register(type: VDEVLogger.self,
                               service: logger)
        }
        
        container.register(type: RemoveLayersService.self,
                           service: RemoveLayersService())
        
        if settings.canMergeAllLayers {
            container.register(type: MergeLayersService.self,
                               service: MergeLayersService())
        }
        
        container.register(type: ItemProcessingWatcher.self, service: ItemProcessingWatcherImpl())
    }
    
    static func clean(with container: DIContainer = DIContainer.shared) {
        container.clean()
    }
    
    private static func registerNetworkConfig(
        with container: DIContainer,
        networkModulesConfig: [VDEVNetworkModuleConfig]
    ) {
        let networkConfig = VDEVNetworkConfig()
        networkModulesConfig.forEach {
            networkConfig.add($0.type, $0)
        }
        container.register(type: VDEVNetworkConfig.self, service: networkConfig)
    }
}
