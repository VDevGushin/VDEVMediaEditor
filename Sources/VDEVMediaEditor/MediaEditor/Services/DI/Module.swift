//
//  Module.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.04.2023.
//

import Foundation
import Resolver

/// Represents application' most abstract parts of business logic
protocol Module {

    /// Called before application started. Used for declaring module's dependencies. Must not be used for business logic
    func bootstrap(with ioc: Resolver)

    /// Called after all modules' `bootstrap` methods called. Used for setup mudule dependent entities. Nothing should be started at this point - do this in `ready`
    func setup(with ioc: Resolver)

    /// Вызывается после построения контейнера и инициализации сервисов
    func ready(with ioc: Resolver)
}

extension Array where Element == Module {
    func bootstrap() {
        for module in self {
            let resolver = Resolver()
            Resolver.main.add(child: resolver)
            module.bootstrap(with: resolver)
        }

        forEach { $0.setup(with: Resolver.root) }
        forEach { $0.ready(with: Resolver.root) }
    }
}
