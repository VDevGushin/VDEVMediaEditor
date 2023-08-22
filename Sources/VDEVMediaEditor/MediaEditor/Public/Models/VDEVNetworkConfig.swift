//
//  VDEVNetworkConfig.swift
//  
//
//  Created by Vladislav Gushin on 13.08.2023.
//

import Foundation

public enum VDEVNetworkModuleConfigType: String {
    case image2image
}

public protocol VDEVNetworkModuleConfig {
    var type: VDEVNetworkModuleConfigType { get }
    var host: String { get }
    var path: String { get }
    var timeOut: TimeInterval { get }
    var headers: [String: String]? { get }
    var token: String? { get }
}

public final class VDEVNetworkConfig {
    private(set) var modules: [VDEVNetworkModuleConfigType: VDEVNetworkModuleConfig] = [:]
    
    @discardableResult
    func add(
        _ type: VDEVNetworkModuleConfigType,
        _ module: VDEVNetworkModuleConfig
    ) -> Self {
        modules[type] = module
        return self
    }
    
    subscript (type: VDEVNetworkModuleConfigType) -> VDEVNetworkModuleConfig? {
        modules[type]
    }
}
