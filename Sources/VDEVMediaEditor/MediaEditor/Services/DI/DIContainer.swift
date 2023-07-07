//
//  DIContainer.swift
//  
//
//  Created by Vladislav Gushin on 27.04.2023.
//

import Foundation

let DI = DIContainer.shared

@propertyWrapper
struct Injected<Service> {
    private var service: Service

    init() {
        self.service = DIContainer.shared.resolve(Service.self)
    }

    var wrappedValue: Service { service }
}

@propertyWrapper
struct InjectedOptional<Service> {
    private var service: Service?

    init() {
        self.service = DIContainer.shared.resolveOptional(Service.self)
    }

    var wrappedValue: Service? { service }
}

final class DIContainer {
    static let shared = DIContainer()
    
    private init() {}
    
    private var services: [String: Any] = [:]
    
    func register<Service>(type: Service.Type, service: Any) {
        services["\(type)"] = service
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        guard let service = services["\(type)"] as? Service else {
            let serviceName = String(describing: Service.self)
            fatalError("No service of type \(serviceName) registered!")
        }
        return service
    }
    
    func resolveOptional<Service>(_ type: Service.Type) -> Service? {
        guard let service = services["\(type)"] as? Service else {
            _ = String(describing: Service.self)
            return nil
        }
        return service
    }
    
    func clean() { services.removeAll() }
}
