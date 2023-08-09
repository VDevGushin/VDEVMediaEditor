//
//  ApiClient.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation
import Combine

public protocol ApiClient: BaseApiClient {
    func execute<Operation: ApiOperation>(_ operation: Operation) -> AnyPublisher<Operation.Response, Error>

    func execute<Operation: ApiOperationWithBody>(_ operation: Operation) -> AnyPublisher<Operation.Response, Error>
    
    func execute<Operation: ApiOperationWithMultipartRequest>(
        _ operation: Operation
    ) async throws -> Operation.Response
    
    func execute<Operation: ApiOperation>(
        _ operation: Operation
    ) async throws -> Operation.Response
    
    func execute<Operation: ApiOperationWithBody>(
        _ operation: Operation
    ) async throws -> Operation.Response
}

public final class ApiClientImpl: ApiClient {
    private(set) public var host: String

    public var decoder: JSONDecoder = {
       let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()
    
    public var scheme: String { "https" }

    public init(host: String) { self.host = host }

    public func execute<Operation: ApiOperation>(_ operation: Operation) -> AnyPublisher<Operation.Response, Error> {

        let request = makeURLRequest(operation: operation)

        return URLSession.shared.fetch(for: request,
                                       decoder: decoder,
                                       with: Operation.Response.self)
    }

    public func execute<Operation: ApiOperationWithBody>(_ operation: Operation) -> AnyPublisher<Operation.Response, Error> {

        let request = makeURLRequest(operation: operation)

        return URLSession.shared.fetch(for: request,
                                       decoder: decoder,
                                       with: Operation.Response.self)
    }
    
    public func execute<Operation: ApiOperationWithMultipartRequest>(
        _ operation: Operation
    ) async throws -> Operation.Response {
        let request = makeURLRequest(operation: operation)
        return try await URLSession.shared.fetch(for: request, with: Operation.Response.self)
    }
    
    public func execute<Operation: ApiOperation>(
        _ operation: Operation
    ) async throws -> Operation.Response {
        let request = makeURLRequest(operation: operation)
        return try await URLSession.shared.fetch(for: request, decoder: decoder, with: Operation.Response.self)
    }
    
    public func execute<Operation: ApiOperationWithBody>(
        _ operation: Operation
    ) async throws -> Operation.Response {
        let request = makeURLRequest(operation: operation)
        return try await URLSession.shared.fetch(for: request, decoder: decoder, with: Operation.Response.self)
    }
}

