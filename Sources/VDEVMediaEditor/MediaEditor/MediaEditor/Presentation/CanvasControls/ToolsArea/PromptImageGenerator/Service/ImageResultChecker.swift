//
//  ImageResultChecker.swift
//  
//
//  Created by Vladislav Gushin on 12.07.2023.
//

import Foundation
import Combine
import UIKit

typealias MESSAGEID = String

extension UserDefaults {
    private var defaultsKey: String { "EDIT_ME_AI_MESSAGE_ID" }
    @objc dynamic var MESSAGEID: String? {
        get { string(forKey: defaultsKey) }
        set { setValue(newValue, forKey: defaultsKey) }
    }
}

final class ImageResultChecker: ObservableObject {
    var state: AnyPublisher<State, Never> {  _state.eraseToAnyPublisher() }
    private let client = ApiClientImpl(host: "api.thenextleg.io")
    
    private let defaults = UserDefaults.standard
    private var _state = CurrentValueSubject<State, Never>(.notStarted)
    private var timerOperation: AnyCancellable?
    
    private var operation: AnyCancellable?
    private var userDefaultsOperation: AnyCancellable?
    private var attempt: Int = 0
    
    private func checkAttempt() async -> Bool {
        attempt >= 2
    }
    
    private func incrementAttemp() async {
        attempt += 1
    }
    
    @Published private var MESSAGEID: String? = UserDefaults.standard.MESSAGEID {
        didSet {
            UserDefaults.standard.MESSAGEID = MESSAGEID
        }
    }
    
    init() {
        userDefaultsOperation = UserDefaults.standard.publisher(for: \.MESSAGEID)
            .sink(receiveValue: { [weak self] newValue in
                guard let self = self else { return }
                guard let newValue = newValue else {
                    self.setState(value: .notStarted)
                    return self.stop()
                }
                self.setState(value: .inProgress(progress: 0, progressImageUrl: nil))
                self.startCheck(messageID: newValue)
            })
    }
    
    deinit {
        stop()
    }
    
    private func startCheck(messageID: MESSAGEID) {
        stop()
        timerOperation = Timer.publish(every: 15,
                                       tolerance: 0.2,
                                       on: .current,
                                       in: .common)
        .autoconnect()
        .share()
        .merge(with: Just(.init()))
        .sink { [weak self] _ in
            guard let self = self else { return }
            Task(priority: .background) {
                let processingResult: ProcessingResult
                do {
                    let (response, messageId) = try await self.check(messageID: messageID)
                    switch response.progress {
                    case .incoplete:
                        processingResult = .incoplete(messageId: messageId)
                    case .progress(let progress):
                        if progress >= 100 {
                            guard let image = self.image(from: response.response?.imageUrls) else {
                                processingResult = .error(messageId: messageId)
                                return
                            }
                            processingResult = .success(image: image, messageId: messageId)
                        } else {
                            processingResult = .inProgress(progress: progress,
                                                           messageId: messageId,
                                                           progressImageUrl: response.progressImageUrl)
                        }
                    }
                } catch {
                    await self.incrementAttemp()
                    processingResult = .error(messageId: messageID)
                }
                
                switch processingResult {
                case .incoplete(messageId: _):
                    await self.removeMessageID()
                    self.setState(value: .notStarted)
                    self.stop()
                case .error(messageId: _):
                    if await self.checkAttempt() {
                        await self.removeMessageID()
                        self.setState(value: .notStarted)
                        self.stop()
                    }
                case .success(image: let image, messageId: _):
                    await self.removeMessageID()
                    self.setState(value: .success(image: image))
                    self.stop()
                case .inProgress(progress: let progress,
                                 messageId: let messageId,
                                 progressImageUrl: let progressImageUrl):
                    let savedMessageId = await self.getMessageID()
                    
                    if savedMessageId == nil {
                        await self.save(messageID: messageId)
                        self.setState(value: .inProgress(progress: progress,
                                                         progressImageUrl: progressImageUrl))
                        return
                    }
                    
                    if savedMessageId! != messageId {
                        await self.save(messageID: messageId)
                    }
                    
                    self.setState(value: .inProgress(progress: progress,
                                                     progressImageUrl: progressImageUrl))
                }
            }
        }
    }
    
    @MainActor
    func getMessageID() async -> MESSAGEID? {
        MESSAGEID
    }
    
    @MainActor
    func save(messageID: MESSAGEID) async {
        if messageID != MESSAGEID {
            MESSAGEID = messageID
        }
    }
    
    @MainActor
    func removeMessageID() async {
        if MESSAGEID != nil {
            MESSAGEID = nil
        }
    }
    
    func setState(value: State) {
        _state.send(value)
    }
    
    private func stop() {
        timerOperation?.cancel()
        operation?.cancel()
        timerOperation = nil
        operation = nil
        attempt = 0
        setState(value: .notStarted)
    }
    
    private func check(
        messageID: String
    ) async throws -> (GetMessageOperation.Response, MESSAGEID) {
        
        try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else {
                return continuation.resume(throwing: "Nil is Error")
            }
            self.operation = self.client
                .execute(GetMessageOperation(messageID: messageID))
                .map {
                    ($0, messageID)
                }
                .sink(receiveCompletion: { state in
                    switch state {
                    case .finished: break
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }, receiveValue: { value in
                    continuation.resume(returning: value)
                })
        }
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

extension ImageResultChecker {
    enum ProcessingResult {
        case incoplete(messageId: String)
        case error(messageId: String)
        case success(image: UIImage, messageId: String)
        case inProgress(progress: Int, messageId: String, progressImageUrl: URL?)
    }
    
    enum State {
        case notStarted
        case inProgress(progress: Int, progressImageUrl: URL?)
        case success(image: UIImage)
        case error(error: Error)
    }
    
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
            let progressImageUrl: URL?
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
