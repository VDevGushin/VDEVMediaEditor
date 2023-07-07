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
    @InjectedOptional private var imageResultChecker: ImageResultChecker?
    
    var state: AnyPublisher<State, Never> { _state.eraseToAnyPublisher() }
    private let client = ApiClientImpl(host: "api.thenextleg.io")
    private var _state = CurrentValueSubject<State, Never>(.loading)
    private var imageResultCheckerObserver: AnyCancellable?
    private var executeTask: Task<Void, Error>?
    
    init() {
        guard let imageResultChecker = imageResultChecker else {
            _state.send(.inaccessible)
            return
        }
        
        imageResultCheckerObserver = imageResultChecker
            .state
            .sink(self) { wSelf, value in
                switch value {
                case .notStarted:
                    wSelf._state.send(.notStarted)
                case .inProgress(progress: let progress,
                                 progressImageUrl: let progressImageUrl):
                    wSelf._state.send(.inProgress(progress: progress,
                                                  progressImageUrl: progressImageUrl))
                case .success(image: let image):
                    wSelf._state.send(.success(image: image))
                    wSelf.imageResultCheckerObserver?.cancel()
                    wSelf.removeMessageID()
                case .error(error: let error):
                    wSelf._state.send(.error(error: error))
                }
            }
    }
    
    deinit {
        cancel()
    }
    
    func removeMessageID() {
        Task { await imageResultChecker?.removeMessageID(force: true) }
    }
    
    func execute(message: String) {
        executeTask?.cancel()
        guard let imageResultChecker = imageResultChecker else {
            _state.send(.inaccessible)
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
                _state.send(.error(error: error))
            }
        }
    }
    
    func cancel() {
        executeTask?.cancel()
        executeTask = nil
    }
    
    private func send(message: String) async throws -> MESSAGEID {
        let response = try await client.execute(GenerateOperation(message: message))
        guard let messageID = response.messageId else {
            throw "No message id"
        }
        return messageID
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
        case inaccessible
        case notStarted
        case success(image: UIImage)
        case error(error: Error)
        case inProgress(progress: Int,
                        progressImageUrl: URL?)
    }
}
