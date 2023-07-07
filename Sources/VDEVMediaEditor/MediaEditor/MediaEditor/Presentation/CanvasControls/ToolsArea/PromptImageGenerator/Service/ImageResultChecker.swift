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

enum AIGenerationError: Error, LocalizedError {
    case error(Error)
    case errorDescription(String)
    case common(error: Error?, description: String?)
    
    var localizedDescription: String {
        switch self {
        case let .errorDescription(description):
            return description
        case let .error(error):
            return error.localizedDescription
        case let .common(error: error, description: description):
            return description ?? error?.localizedDescription ?? ""
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case let .errorDescription(description):
            return NSLocalizedString(description, comment: "")
        case let .error(error):
            return NSLocalizedString(error.localizedDescription, comment: "")
        case let .common(error: error, description: description):
            let message = description ?? error?.localizedDescription ?? ""
            return NSLocalizedString(message, comment: "")
        }
    }
}

extension UserDefaults {
    private var defaultsKey: String { "EDIT_ME_AI_MESSAGE_ID" }
    @objc dynamic var MESSAGEID: String? {
        get { string(forKey: defaultsKey) }
        set { setValue(newValue, forKey: defaultsKey) }
    }
}

extension ImageResultChecker {
    struct Config {
        let numberOfAttempt: Int = 3
        let timerInterval: Double = 8
    }
}

final class ImageResultChecker: ObservableObject {
    var state: AnyPublisher<State, Never> {  _state.eraseToAnyPublisher() }
    private var _state = CurrentValueSubject<State, Never>(.notStarted)
    private let client = ApiClientImpl(host: "api.thenextleg.io")
    private var attempt: Int = 0
    private let config: Config
    private var timerOperation: AnyCancellable?
    private var userDefaultsOperation: AnyCancellable?
    private var fetchTask: Task<Void, Error>?
    
    @Published private var savedMessageID: String? = UserDefaults.standard.MESSAGEID {
        didSet { UserDefaults.standard.MESSAGEID = savedMessageID }
    }
    
    init(config: Config) {
        self.config = config
        userDefaultsOperation = UserDefaults.standard.publisher(for: \.MESSAGEID)
            .sink(self) { wSelf, newValue in
                wSelf.stop()
                guard let newValue = newValue else {
                    return wSelf.setState(value: .notStarted)
                }
                wSelf.setState(value: .inProgress(progress: 0, progressImageUrl: nil))
                wSelf.startCheck(messageID: newValue)
            }
    }
    
    deinit { stop() }
    
    private func startCheck(messageID: MESSAGEID) {
        timerOperation = Timer.publish(every: config.timerInterval,
                                       tolerance: 0.2,
                                       on: .current,
                                       in: .common)
        .autoconnect()
        .share()
        .merge(with: Just(.init()))
        .sink(self) { wSelf, _ in
            wSelf.fetchTask = Task(priority: .background) {
                let processingResult: ProcessingResponse
                do {
                    let response = try await wSelf.check(messageID: messageID)
                    processingResult = try .createFrom(response)
                } catch {
                    await wSelf.incrementAttemp()
                    processingResult = .error(error: error, messageId: messageID)
                }
                await wSelf.processingResult(processingResult)
            }
        }
    }
    
    @MainActor
    func getMessageID() async -> MESSAGEID? {
        savedMessageID
    }
    
    @MainActor
    func save(messageID: MESSAGEID) async {
        if messageID != savedMessageID {
            savedMessageID = messageID
        }
    }
    
    @MainActor
    func removeMessageID(force: Bool = false) async {
        if force {
            savedMessageID = nil
        } else {
            if savedMessageID != nil {
                savedMessageID = nil
            }
        }
    }
}

extension ImageResultChecker {
    enum State {
        case notStarted
        case inProgress(progress: Int, progressImageUrl: URL?)
        case success(image: UIImage)
        case error(error: Error)
    }
}

private extension ImageResultChecker {
    private func processingResult(_ processingResult: ProcessingResponse) async {
        switch processingResult {
            // Сервер не смог справиться
        case .incoplete(messageId: _):
            self.setState(value: .error(error: "Incomplete"))
            await self.removeMessageID()
            // После 3 попыток достать результат, оставить попытки
        case .error(error: let error, messageId: _):
            if await self.checkAttempt() {
                self.setState(value: .error(error: error))
                self.stop()
            }
        case .success(image: let image, messageId: _):
            // посылаем результат
            self.setState(value: .success(image: image))
            // отсанавливаем таймер
           
            // удалять id можно только после получения результата во вью
            // (GenerateImageFromTextService)
        case .inProgress(progress: let progress,
                         messageId: let messageId,
                         progressImageUrl: let progressImageUrl):
            switch await self.getMessageID() {
            case nil:
                await self.save(messageID: messageId)
                self.setState(value: .inProgress(progress: progress,
                                                 progressImageUrl: progressImageUrl))
            case let value:
                if value != messageId {
                    await self.save(messageID: messageId)
                }
                self.setState(value: .inProgress(progress: progress,
                                                 progressImageUrl: progressImageUrl))
            }
        }
    }
    
    @MainActor
    private func checkAttempt() async -> Bool {
        attempt >= config.numberOfAttempt - 1
    }
    
    @MainActor
    private func incrementAttemp() async {
        attempt += 1
    }
    
    private func setState(value: State) {
        _state.send(value)
    }
    
    private func stop() {
        fetchTask?.cancel()
        timerOperation?.cancel()
        timerOperation = nil
        fetchTask = nil
        attempt = 0
    }
    
    func check(
        messageID: String
    ) async throws -> (GetMessageOperation.Response, MESSAGEID) {
        let response = try await client.execute(GetMessageOperation(messageID: messageID))
        return (response, messageID)
    }
}

private extension ImageResultChecker {
    enum ProcessingResponse: Equatable {
        static func == (lhs: ProcessingResponse, rhs: ProcessingResponse) -> Bool {
            switch (lhs, rhs) {
            case (.incoplete, .incoplete): return true
            case (.error, .error): return true
            case (.inProgress, .inProgress): return false
            default: return false
            }
        }
        
        case incoplete(messageId: String)
        case error(error: Error, messageId: String)
        case success(image: UIImage, messageId: String)
        case inProgress(progress: Int, messageId: String, progressImageUrl: URL?)
        
        static func createFrom(_ value: (ImageResultChecker.GetMessageOperation.Response, MESSAGEID)) throws -> ProcessingResponse {
            let response = value.0
            let messageId = value.1
            
            switch response.progress {
            case .incoplete:
                return .incoplete(messageId: messageId)
            case .progress(let progress):
                if progress >= 100 {
                    do {
                        let image = try ProcessingResponse.image(from: response.response?.imageUrls)
                        return .success(image: image, messageId: messageId)
                    } catch {
                        throw AIGenerationError.common(error: error,
                                                       description: response.response?.description)
                    }
                } else {
                    return .inProgress(progress: progress,
                                                   messageId: messageId,
                                                   progressImageUrl: response.progressImageUrl)
                }
            }
        }
        
        private static func image(from urls: [URL]?) throws -> UIImage {
            guard let urls = urls, !urls.isEmpty else {
                throw "Can't get generated image"
            }
            let index = Int.random(in: 0...urls.count-1)
            let data = try Data(contentsOf: urls[index])
            guard let image = UIImage(data: data) else {
                throw "Can't get generated image"
            }
            return image
        }
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
                    case description
                }
                
                let imageUrl: URL?
                let imageUrls: [URL]?
                let description: String?
                
                init(from decoder: Decoder) throws {
                    guard let values = try? decoder.container(keyedBy: CodingKeys.self) else {
                        imageUrl = nil
                        imageUrls = nil
                        description = nil
                        return
                    }
                    imageUrl = try? values.decode(URL.self, forKey: .imageUrl)
                    imageUrls = try? values.decode([URL].self, forKey: .imageUrls)
                    description = try? values.decode(String.self, forKey: .description)
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
                    throw DecodingError.typeMismatch(Double.self,
                                                     DecodingError.Context(codingPath: decoder.codingPath,
                                                                           debugDescription: "Wrong type for progress"))
                }
            }
        }
    }
}
