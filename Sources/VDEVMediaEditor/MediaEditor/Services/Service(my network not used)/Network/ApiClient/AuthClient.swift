//
//  AuthClient.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation
import Combine

protocol AuthClient: BaseApiClient {
    var refreshOperation: RefreshOperation { get }

    func refresh() -> AnyPublisher<UserInfo, Error>
}

final class AuthClientImpl: AuthClient {
    private(set) var host: String

    var decoder: JSONDecoder { JSONDecoder() }
    var scheme: String { "https" }

    var refreshOperation: RefreshOperation { RefreshOperation() }

    init(host: String) {
        self.host = host
    }

    func refresh() -> AnyPublisher<UserInfo, Error> {
        fetch(refreshOperation)
            .map { tokenInfo in
                return .init(tokenInfo: tokenInfo)
            }
            .eraseToAnyPublisher()
    }

    private func fetch<Operation: ApiOperationWithBody>(_ operation: Operation) -> AnyPublisher<Operation.Response, Error> {

        let request = makeURLRequest(operation: operation)
            
        
        return URLSession.shared.fetch(for: request, decoder: decoder, with: Operation.Response.self)
    }
}

// MARK: - Models

struct UserInfo {
    var tokenInfo: Tokens?

    var isAuthorized: Bool { tokenInfo?.token != nil }
    var authToken: String? { tokenInfo?.token }

    init(tokenInfo: Tokens?) {
        self.tokenInfo = tokenInfo
    }

    struct Tokens: Decodable {
        let token: String
        let refreshToken: String
    }

    static let guest = UserInfo(tokenInfo: nil)
}

struct RefreshOperation: ApiOperationWithBody {
    typealias Response = UserInfo.Tokens
    typealias Body = RefreshBody

    var encoder: JSONEncoder { JSONEncoder() }

    var body: RefreshBody {
        .init(refreshToken: "123")
    }

    var path: String = "/refresh"

    var params: [String : String] = [:]

    var token: String?

    struct RefreshBody: Encodable {
        let refreshToken: String
    }
}

//    func authWith(operation: RegistrationOperation) -> AnyPublisher<UserInfo, Error> {
//        fetch(operation)
//            .map { tokenInfo in
//                return .init(tokenInfo: tokenInfo)
//            }
//            .eraseToAnyPublisher()
//    }

// func authWith(operation: RegistrationOperation) -> AnyPublisher<UserInfo, Error>
