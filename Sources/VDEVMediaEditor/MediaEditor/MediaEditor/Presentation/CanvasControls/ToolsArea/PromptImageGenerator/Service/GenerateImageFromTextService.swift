//
//  GenerateImageFromTextService.swift
//  
//
//  Created by Vladislav Gushin on 11.07.2023.
//

import Foundation
import Combine
import UIKit

final class GenerateImageFromTextService {
    var state: AnyPublisher<State, Never> { _state.eraseToAnyPublisher() }
    private let client = ApiClientImpl(host: "api.thenextleg.io")
    private var operation: AnyCancellable?
    private var _state = CurrentValueSubject<State, Never>(.notStarted)
    private let imageResultChecker = DIContainer.shared.resolveOptional(ImageResultChecker.self)
    private var imageResultCheckerObserver: AnyCancellable?
    private var executeTask: Task<Void, Error>?
    
    init() {
        guard let imageResultChecker = imageResultChecker else { return }
        imageResultCheckerObserver = imageResultChecker
            .state
            .sink { [weak self] in
                switch $0 {
                case .notStarted: break
                case .inProgress(progress: let progress,
                                 progressImageUrl: let progressImageUrl):
                    self?._state.send(.inProgress(progress: progress,
                                                  progressImageUrl: progressImageUrl))
                case .success(image: let image):
                    self?._state.send(.success(image: image))
                case .error(error: let error):
                    self?._state.send(.error(error: error))
                }
            }
    }
    
    deinit {
        cancel()
    }
    
    func execute(message: String) {
        executeTask?.cancel()
        guard let imageResultChecker = imageResultChecker else {
            _state.send(.notStarted)
            return
        }
        
        _state.send(.loading)
        
        executeTask = Task(priority: .background) {
            await imageResultChecker.removeMessageID()
            do {
                try Task.checkCancellation()
                let messageID = try await send(message: message)
                try Task.checkCancellation()
                await imageResultChecker.save(messageID: messageID)
                _state.send(.loading)
            } catch {
                await imageResultChecker.removeMessageID()
                _state.send(.error(error: error))
            }
        }
    }
    
    func cancel() {
        operation?.cancel()
        operation = nil
    }
    
    private func send(message: String) async throws -> MESSAGEID {
        try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else { return }
            self.operation = self.client
                .execute(GenerateOperation(message: message))
                .sink(receiveCompletion: { state in
                    switch state {
                    case .finished: break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { result in
                    guard let messageid = result.messageId else {
                        continuation.resume(throwing: "No message id")
                        return
                    }
                    continuation.resume(returning: messageid)
                })
        }
    }
}

// MARK: - Request operation
struct GenerateOperation: ApiOperationWithBody {
    typealias Response = Result
    var body: Body { .init(msg: message) }
    var encoder: JSONEncoder = .init()
    var path: String { "/v2/imagine" }
    var method: HTTPMethod { .post }
    var params: [String : String] = [:]
    var token: String? = "Bearer 23bc3127-04af-4dc1-92ff-38bf34f6a982"
    private let message: String
    
    init(message: String) {
        self.message = message
    }
    
    struct Result: Decodable {
        let success: Bool
        let messageId: String?
        let createdAt: String
    }
    
    struct Body: Encodable {
        let msg: String
        let ref: String = ""
        let webhookOverride: String = ""
    }
}

// MARK: - State
extension GenerateImageFromTextService {
    enum State {
        case loading
        case notStarted
        case success(image: UIImage)
        case error(error: Error)
        case inProgress(progress: Int, progressImageUrl: URL?)
    }
}
