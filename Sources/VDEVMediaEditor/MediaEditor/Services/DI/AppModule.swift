//
//  AppModule.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.04.2023.
//

import Foundation
import Resolver

final class AppModule: Module {
    private let baseChallengeId: String
    private let dataService: MediaEditorSourceService
    private let images: VDEVImageConfig
    private let strings: VDEVMediaEditorStrings
    private let uiConfig: VDEVUIConfig
    
    init(baseChallengeId: String,
         dataService: MediaEditorSourceService,
         images: VDEVImageConfig,
         strings: VDEVMediaEditorStrings,
         uiConfig: VDEVUIConfig) {
        self.dataService = dataService
        self.baseChallengeId = baseChallengeId
        self.images = images
        self.strings = strings
        self.uiConfig = uiConfig
    }
    
    func bootstrap(with ioc: Resolver) {
        ioc.register {
            self.dataService as MediaEditorSourceService
        }.scope(.cached)
        
        ioc.register {
            MediaEditorInputServiceImpl(self.baseChallengeId, service: $0.resolve()) as MediaEditorInputService
        }.scope(.cached)
        
        ioc.register {
            self.dataService as MediaEditorSourceService
        }.scope(.cached)
        
        ioc.register {
            self.images as VDEVImageConfig
        }.scope(.cached)
        
        ioc.register {
            self.strings as VDEVMediaEditorStrings
        }.scope(.cached)
        
        ioc.register {
            self.uiConfig as VDEVUIConfig
        }.scope(.cached)
        
        
        ioc.register{ PasteboardService() }.scope(.cached)
    }
    
    func setup(with ioc: Resolver) {
        
    }
    
    func ready(with ioc: Resolver) {
    }
}
