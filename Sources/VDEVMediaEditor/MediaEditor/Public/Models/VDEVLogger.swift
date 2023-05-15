//
//  VDEVLogger.swift
//  
//
//  Created by Vladislav Gushin on 15.05.2023.
//

import Foundation

public enum VDEVLogEvent: String {
    case e
    case i
    case d
    case v
    case w
    case s
}

public protocol VDEVLogger {
    func e(_ message: Any)
    func i(_ message: Any)
    func d(_ message: Any)
    func v(_ message: Any)
    func w(_ message: Any)
    func s(_ message: Any)
}
