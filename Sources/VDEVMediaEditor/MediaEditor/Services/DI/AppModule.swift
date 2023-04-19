//
//  AppModule.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.04.2023.
//

import Foundation
import Resolver

final class AppModule: Module {
    private let dataService: MediaEditorSourceService
    private let baseChallengeId: String
    private let images: VDEVImageConfig
    private let strings: VDEVMediaEditorStrings
    private let output: VDEVMediaEditorOut
    
    init(baseChallengeId: String,
         dataService: MediaEditorSourceService,
         images: VDEVImageConfig,
         strings: VDEVMediaEditorStrings,
         output: VDEVMediaEditorOut) {
        self.dataService = dataService
        self.baseChallengeId = baseChallengeId
        self.images = images
        self.strings = strings
        self.output = output
    }
    
    func bootstrap(with ioc: Resolver) {
        ioc.register {
            MediaEditorInputServiceImpl(self.baseChallengeId) as MediaEditorInputService
        }.scope(.application)
        
        ioc.register {
            self.dataService as MediaEditorSourceService
        }.scope(.application)
        
        ioc.register {
            self.dataService as MediaEditorSourceService
        }.scope(.application)
        
        ioc.register {
            self.images as VDEVImageConfig
        }.scope(.application)
        
        ioc.register {
            self.strings as VDEVMediaEditorStrings
        }.scope(.application)
        
        ioc.register {
            self.output as VDEVMediaEditorOut
        }.scope(.application)
        
        
        ioc.register{ PasteboardService() }.scope(.application)
    }
    
    func setup(with ioc: Resolver) {
        
    }
    
    func ready(with ioc: Resolver) {
        _ = ioc.resolve(MediaEditorInputService.self)
    }
}
