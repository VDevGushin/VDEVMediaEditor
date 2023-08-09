//
//  BaseApiClient.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation

public protocol BaseApiClient {
    var scheme: String { get }
    var host: String { get }
    var decoder: JSONDecoder { get }
}

public extension BaseApiClient {
    func makeURLRequest<Operation: ApiOperation>(operation: Operation) -> URLRequest {
        URLRequest(components: makeURLComponents(operation: operation))
            .add(httpMethod: operation.method)
            .add(timeOut: operation.timeOut)
            .add(headers: operation.headers)
            .set(auth: operation.token)
    }

    func makeURLRequest<Operation: ApiOperationWithBody>(operation: Operation) -> URLRequest {
        URLRequest(components: makeURLComponents(operation: operation))
            .add(httpMethod: operation.method)
            .add(timeOut: operation.timeOut)
            .add(headers: operation.headers)
            .set(auth: operation.token)
            .add(body: operation.body, encoder: operation.encoder)
    }
    
    func makeURLRequest<Operation: ApiOperationWithMultipartRequest>(operation: Operation) -> URLRequest {
        URLRequest(components: makeURLComponents(operation: operation))
            .add(httpMethod: operation.method)
            .add(timeOut: operation.timeOut)
            .add(headers: operation.headers)
            .addHeaderForContentType(operation.multipartRequest.httpContentTypeHeadeValue)
            .set(auth: operation.token)
            .add(body: operation.multipartRequest.httpBody)
    }

    private func makeURLComponents<Operation: ApiOperation>(operation: Operation) -> URLComponents {
        var components = URLComponents()
        components.scheme = operation.scheme ?? self.scheme
        components.host = operation.host ?? self.host
        components.path = operation.path
        
        if !operation.params.isEmpty {
            components.queryItems = operation.params.map { .init(name: $0.key, value: $0.value) }
        }
        
        return components
    }
}
