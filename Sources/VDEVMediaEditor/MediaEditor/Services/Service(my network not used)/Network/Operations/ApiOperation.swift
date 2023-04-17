//
//  ApiOperation.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation

protocol ApiOperation: Any {
    associatedtype Response: Decodable

    var path: String { get }
    var method: HTTPMethod { get }
    var params: [String: String] { get }
    
    var headers: [String: String]? { get }
    var scheme: String? { get }
    var host: String? { get }
    var token: String? { get set }

    var timeOut: TimeInterval { get }

    mutating func update(token: String?) -> Self
}

extension ApiOperation {
    mutating func update(token: String?) -> Self {
        self.token = token
        return self
    }

    var timeOut: TimeInterval { 20.0 }

    var headers: [String: String]? { nil }
    var scheme: String? { nil }
    var host: String? { nil }
}

protocol ApiOperationWithBody: ApiOperation {
    associatedtype Body: Encodable

    var encoder: JSONEncoder { get }
    
    var body: Body { get }
}

extension ApiOperationWithBody {
    var method: HTTPMethod { .post }
}
