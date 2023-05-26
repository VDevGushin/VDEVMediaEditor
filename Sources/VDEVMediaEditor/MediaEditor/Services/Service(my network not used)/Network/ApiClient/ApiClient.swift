//
//  ApiClient.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation
import Combine

protocol ApiClient: BaseApiClient {
    func execute<Operation: ApiOperation>(_ operation: Operation) -> AnyPublisher<Operation.Response, Error>
    func execute<Operation: ApiOperationWithBody>(_ operation: Operation) -> AnyPublisher<Operation.Response, Error>
}

final class ApiClientImpl: ApiClient {
    private(set) var host: String

    var decoder: JSONDecoder { JSONDecoder() }
    var scheme: String { "https" }

    init(host: String) { self.host = host }

    func execute<Operation: ApiOperation>(_ operation: Operation) -> AnyPublisher<Operation.Response, Error> {

        let request = makeURLRequest(operation: operation)

        return URLSession.shared.fetch(for: request,
                                       decoder: decoder,
                                       with: Operation.Response.self)
    }

    func execute<Operation: ApiOperationWithBody>(_ operation: Operation) -> AnyPublisher<Operation.Response, Error> {

        let request = makeURLRequest(operation: operation)

        return URLSession.shared.fetch(for: request,
                                       decoder: decoder,
                                       with: Operation.Response.self)
    }
}

