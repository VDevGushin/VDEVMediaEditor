//
//  URLRequest+Ex.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation

extension URLRequest {
    init(components: URLComponents) {
        guard let url = components.url else {
            preconditionFailure("Unable to get URL from URLComponents: \(components)")
        }

        self = Self(url: url)
            .add(headers: ["Content-Type": "application/json"])
    }

    func add(timeOut: TimeInterval) -> Self {
        map { $0.timeoutInterval = timeOut }
    }

    func add(httpMethod: HTTPMethod) -> Self {
        map { $0.httpMethod = httpMethod.rawValue }
    }

    func add<Body: Encodable>(body: Body, encoder: JSONEncoder = JSONEncoder()) -> Self {
        map {
            do {
                $0.httpBody = try encoder.encode(body)
            } catch {
                Log.e(error)
                preconditionFailure("Failed to encode request Body: \(body) due to Error: \(error)")
            }
        }
    }

    func add(headers: [String: String]?) -> Self {
        guard let headers = headers, !headers.isEmpty else { return self }

        return map {
            let allHTTPHeaderFields = $0.allHTTPHeaderFields ?? [:]
            let updatedAllHTTPHeaderFields = headers.merging(allHTTPHeaderFields, uniquingKeysWith: { $1 })
            $0.allHTTPHeaderFields = updatedAllHTTPHeaderFields
        }
    }

    func set(auth token: String?) -> Self {
        guard let token = token, !token.isEmpty else { return self }

        return map {
            var allHTTPHeaderFields = $0.allHTTPHeaderFields ?? [:]
            allHTTPHeaderFields["Authorization"] = token
            $0.allHTTPHeaderFields = allHTTPHeaderFields
        }
    }

    func map(_ trasform: (inout Self) -> ()) -> Self {
        var request = self
        trasform(&request)
        return request
    }
}
