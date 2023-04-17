//
//  ApiController.swift
//  Network
//
//  Created by Vladislav Gushin on 07.12.2022.
//

import Foundation
import Combine

protocol ApiController {
    func auth(phone: String) -> AnyPublisher<UserInfo, Error>

    var onUserInfoChanged: CurrentValueSubject<UserInfo, Never> { get }
}

final class ApiControllerImpl: ApiController {
    private let apiClient: ApiClient
    private let authClient: AuthClient?

    private var authOp: AnyCancellable?

    private(set) var onUserInfoChanged = CurrentValueSubject<UserInfo, Never>(.guest)

    private(set) var userInfo: UserInfo = .guest {
        didSet { onUserInfoChanged.send(userInfo) }
    }

    init(apiClient: ApiClient, authClient: AuthClient? = nil) {
        self.authClient = authClient
        self.apiClient = apiClient
    }

    func auth(phone: String) -> AnyPublisher<UserInfo, Error> {
        self.execute(operation: RegistrationOperation(phoneNumber: phone))
            .map { [weak self] tokens in
                guard let self = self else { return .guest }
                self.userInfo = .init(tokenInfo: tokens)
                return self.userInfo
            }
            .eraseToAnyPublisher()
    }

    private func execute<Operation: ApiOperation>(operation: Operation, maxAttempts: Int = 3) -> AnyPublisher<Operation.Response, Error> {

        apiClient.execute(operation)
            .tryCatch { [weak self] error in
                Log.e(error)
                guard let self = self else { throw error }

                if error.isUnauthorized {

                    guard let authClient = self.authClient else { throw error }

                    return authClient
                        .refresh()
                        // .retry(3)
                        .mapError { _ in  return error } //возвращаю ошибку основной операции
                        .flatMap { model in
                            var operation = operation
                            return self.execute(operation: operation.update(token: model.authToken),
                                                maxAttempts: maxAttempts - 1)
                        }
                }

                throw error
            }
            // .retry(maxAttempts)
            .eraseToAnyPublisher()
    }
}
