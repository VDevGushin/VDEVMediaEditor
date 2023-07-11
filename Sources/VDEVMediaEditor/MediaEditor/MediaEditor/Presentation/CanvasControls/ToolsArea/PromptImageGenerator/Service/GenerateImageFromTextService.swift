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
    
    func execute() {
        cancel()
        
        operation = self.check(messageID: "mP5lq1WC5mpqFrhJEzbx")
//        operation = send(message: "Tiny cute adorable ginger tabby kitten studio light")
//            .flatMap { [weak self] result -> AnyPublisher<GetMessageOperation.Response, Error> in
//                guard let self = self else {
//                    return Fail(error: "Self is nil").eraseToAnyPublisher()
//                }
//                guard let messageId = result.messageId else {
//                    return Fail(error: "Bad message id").eraseToAnyPublisher()
//                }
//
//                return self.check(messageID: messageId)
//            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { state in
                switch state {
                case .finished: break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { result in
                dump(result)
            })
    }
    
    func cancel() {
        operation?.cancel()
        operation = nil
    }
    
    private func check(messageID: String) -> AnyPublisher<GetMessageOperation.Response, Error> {
        client
            .execute(GetMessageOperation(messageID: messageID))
            .eraseToAnyPublisher()
    }
    
    private func send(message: String) -> AnyPublisher<GenerateOperation.Response, Error> {
        client
            .execute(GenerateOperation(message: message))
            .eraseToAnyPublisher()
    }
    
    private func image(from url: URL?) -> AnyPublisher<UIImage, Error> {
        guard let url = url,
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return Fail(error: "Can not get image").eraseToAnyPublisher()
        }
        return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}

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
                let imageUrl: URL
                let imageUrls: [URL]
            }
            
            enum Progress: Decodable {
                case incoplete
                case progress(Double)
                
                init(from decoder: Decoder) throws {
                       let container = try decoder.singleValueContainer()
                       if let progress = try? container.decode(Double.self) {
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

extension GenerateImageFromTextService {
    enum State {
        case notStarted
        case success(url: URL)
        case error(error: Error? = nil)
        case inProgress(progress: Int)
    }
}
