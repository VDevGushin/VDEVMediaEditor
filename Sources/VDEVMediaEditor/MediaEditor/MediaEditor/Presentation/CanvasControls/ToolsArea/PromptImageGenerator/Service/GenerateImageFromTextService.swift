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
    var state: AnyPublisher<State, Never> {  _state.eraseToAnyPublisher() }
    private let client = ApiClientImpl(host: "api.thenextleg.io")
    private var operation: AnyCancellable?
    private var checkOperation: AnyCancellable?
    private var _state = CurrentValueSubject<State, Never>(.notStarted)
    private let defaults = UserDefaults.standard
    private let defaultsKey = "EDIT_ME_AI_MESSAGE_ID"
    private var timerOperation: AnyCancellable?
    
    init() {
        startCheck()
    }
    
    deinit {
        print("ddd")
    }
    
    private func startCheck() {
        guard let messageID = defaults.string(forKey: self.defaultsKey) else {
            return _state.send(.notStarted)
        }
        startCheckTimer(messageID: messageID)
    }
    
    private func stop() {
        timerOperation = nil
    }
    
    private func startCheckTimer(messageID: String) {
        _state.send(.loading)
        stop()
        timerOperation = Timer.publish(every: 15,
                          tolerance: 0.2,
                          on: .main,
                          in: .common)
            .autoconnect()
            .share()
            .merge(with: Just(.init()))
            .sink { [weak self] _ in
                self?.getDataFrom(messageID: messageID)
            }
    }
    
    private func getDataFrom(messageID: String) {
        operation = self.check(messageID: messageID)
            .map { response, messageId -> ProcessingResult in
                switch response.progress {
                case .incoplete:
                    return .notStarted(messageId: messageId)
                case .progress(let progress):
                    if progress >= 100 {
                        guard let image = self.image(from: response.response?.imageUrls) else {
                            return .notStarted(messageId: messageId)
                        }
                        return .success(image: image, messageId: messageId)
                    } else {
                        return .inProgress(progress: progress, messageId: messageId)
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .finished: break
                case .failure(let error):
                    self._state.send(.error(error: error))
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .notStarted(messageId: _):
                    self.stop()
                    self.defaults.removeObject(forKey: self.defaultsKey)
                    self._state.send(.notStarted)
                case .success(image: let image, messageId: _):
                    self.stop()
                    self.defaults.removeObject(forKey: self.defaultsKey)
                    self._state.send(.success(image: image))
                case .inProgress(progress: let progress, messageId: let messageId):
                    let savedMessageId = self.defaults.string(forKey: self.defaultsKey)
                    if savedMessageId == nil {
                        self.defaults.set(messageId, forKey: self.defaultsKey)
                        self._state.send(.inProgress(progress: progress))
                        return
                    }
                    if savedMessageId! != messageId {
                        self.defaults.set(messageId, forKey: self.defaultsKey)
                    }
                    self._state.send(.inProgress(progress: progress))
                }
            })
    }
    
    func execute(message: String) {
        _state.send(.loading)
        cancel()
        operation = send(message: message)
            .delay(for: 2, scheduler: DispatchQueue.global())
            .flatMap { result -> AnyPublisher<(GetMessageOperation.Response, String), Error> in
                guard let messageId = result.messageId else {
                    return Fail(error: "Bad message id").eraseToAnyPublisher()
                }
                return self.check(messageID: messageId)
            }
            .map { response, messageId -> ProcessingResult in
                switch response.progress {
                case .incoplete:
                    return .notStarted(messageId: messageId)
                case .progress(let progress):
                    if progress >= 100 {
                        guard let image = self.image(from: response.response?.imageUrls) else {
                            return .notStarted(messageId: messageId)
                        }
                        return .success(image: image, messageId: messageId)
                    } else {
                        return .inProgress(progress: progress, messageId: messageId)
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .finished: break
                case .failure(let error):
                    self._state.send(.error(error: error))
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .notStarted(messageId: _):
                    self.stop()
                    self.defaults.removeObject(forKey: self.defaultsKey)
                    self._state.send(.notStarted)
                case .success(image: let image, messageId: _):
                    self.stop()
                    self.defaults.removeObject(forKey: self.defaultsKey)
                    self._state.send(.success(image: image))
                case .inProgress(progress: let progress, messageId: let messageId):
                    let savedMessageId = self.defaults.string(forKey: self.defaultsKey)
                    if savedMessageId == nil {
                        self.defaults.set(messageId, forKey: self.defaultsKey)
                        self._state.send(.inProgress(progress: progress))
                        self.startCheckTimer(messageID: messageId)
                        return
                    }
                    if savedMessageId! != messageId {
                        self.defaults.set(messageId, forKey: self.defaultsKey)
                    }
                    self._state.send(.inProgress(progress: progress))
                    self.startCheckTimer(messageID: messageId)
                }
            })
    }
    
    func cancel() {
        operation?.cancel()
        operation = nil
    }
    
    private func send(message: String) -> AnyPublisher<GenerateOperation.Response, Error> {
        client
            .execute(GenerateOperation(message: message))
            .eraseToAnyPublisher()
    }
    
    private func check(messageID: String) -> AnyPublisher<(GetMessageOperation.Response, String), Error> {
        client
            .execute(GetMessageOperation(messageID: messageID))
            .map {
                ($0, messageID)
            }
            .eraseToAnyPublisher()
    }
    
    private func image(from urls: [URL]?) -> UIImage? {
        guard let urls = urls, !urls.isEmpty else {
            return nil
        }
        
        let index = Int.random(in: 0...urls.count-1)
        
        guard let data = try? Data(contentsOf: urls[index]),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
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

extension GenerateImageFromTextService {
    struct GetMessageOperation: ApiOperation {
        typealias Response = Result
        var path: String
        var method: HTTPMethod = .get
        var params: [String : String] = ["expireMins": "2"]
        var token: String? = "Bearer 23bc3127-04af-4dc1-92ff-38bf34f6a982"
        init(messageID: String) {
            path = "/v2/message/\(messageID)"
        }
        
        struct Result: Decodable {
            let progress: Progress
            let response: Response?
            
            struct Response: Decodable {
                enum CodingKeys: String, CodingKey {
                    case imageUrl
                    case imageUrls
                }
                
                let imageUrl: URL?
                let imageUrls: [URL]?
                
                init(from decoder: Decoder) throws {
                    guard let values = try? decoder.container(keyedBy: CodingKeys.self) else {
                        imageUrl = nil
                        imageUrls = nil
                        return
                    }
                    imageUrl = try? values.decode(URL.self, forKey: .imageUrl)
                    imageUrls = try? values.decode([URL].self, forKey: .imageUrls)
                }
            }
            
            enum Progress: Decodable {
                case incoplete
                case progress(Int)
                
                init(from decoder: Decoder) throws {
                    guard let container = try? decoder.singleValueContainer() else {
                        self = .progress(0)
                        return
                    }
                    if let progress = try? container.decode(Int.self) {
                        self = .progress(progress)
                        return
                    }
                    
                    if let _ = try? container.decode(String.self) {
                        self = .incoplete
                        return
                    }
                    
                    throw DecodingError.typeMismatch(Double.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for progress"))
                }
            }
        }
    }
}

// MARK: - State
extension GenerateImageFromTextService {
    enum State {
        case loading
        case notStarted
        case success(image: UIImage)
        case error(error: Error? = nil)
        case inProgress(progress: Int)
    }
    
    enum ProcessingResult {
        case notStarted(messageId: String)
        case success(image: UIImage, messageId: String)
        case inProgress(progress: Int, messageId: String)
    }
}
