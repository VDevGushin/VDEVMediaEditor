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
    
    init(baseChallengeId: String, dataService: MediaEditorSourceService) {
        self.dataService = dataService
        self.baseChallengeId = baseChallengeId
    }
    
    func bootstrap(with ioc: Resolver) {
        ioc.register {
            MediaEditorInputServiceImpl(self.baseChallengeId) as MediaEditorInputService
        }.scope(.application)
        
        ioc.register {
            self.dataService as MediaEditorSourceService
        }.scope(.application)
        
        ioc.register{ PasteboardService() }.scope(.application)
    }
    
    func setup(with ioc: Resolver) {
        
    }
    
    func ready(with ioc: Resolver) {
        _ = ioc.resolve(MediaEditorInputService.self)
    }
}
