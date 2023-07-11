//
//  PromptImageGeneratorViewModel.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import Foundation
import Combine

final class GenerateImageFromTextService {
    struct GenerateOperation: ApiOperationWithBody {
        typealias Response = Result
        var body: Body { .init(msg: message) }
        var encoder: JSONEncoder = .init()
        var path: String { "/v2/imagine" }
        var method: HTTPMethod { .post }
        var params: [String : String] = [:]
        var token: String? = "Bearer 23bc3127-04af-4dc1-92ff-38bf34f6a982"
        //var token: String? = "Bearer 3f403066-f11b-403c-97a0-18ed113d8bda"
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
    
    struct GetMessageOperation: ApiOperation {
        typealias Response = Result
        var path: String
        var method: HTTPMethod = .get
        var params: [String : String] = ["expireMins": "2"]
        var token: String? = "Bearer 23bc3127-04af-4dc1-92ff-38bf34f6a982"
        // var token: String? = "Bearer 3f403066-f11b-403c-97a0-18ed113d8bda"
        init(messageID: String) {
            path = "/v2/message/\(messageID)"
        }
        
        struct Result: Decodable {
            //let progress: Int?
            let progressImageUrl: String?
//            let createdAt: String?
            let imageUrl: String?
            let imageUrls: [String]?
        }
    }
    
    private let client = ApiClientImpl(host: "api.thenextleg.io")
    private var operation: AnyCancellable?
    
    func execute() {
        cancel()
        operation = client
            .execute(GenerateOperation(message: "Полный пляж народу"))
            .flatMap { result -> AnyPublisher<GetMessageOperation.Response, Error> in
                guard let messageId = result.messageId else {
                    return Fail(error: "Bad message id").eraseToAnyPublisher()
                }
                return self.client.execute(GetMessageOperation(messageID: messageId)).eraseToAnyPublisher()
            }
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
}

final class PromptImageGeneratorViewModel: ObservableObject {
    @Published private(set) var state: VMState = .initial
    private var operation: AnyCancellable?
    private let generateImageFromTextService = GenerateImageFromTextService()
    
    init() {
    }
    
    func submit() {
        generateImageFromTextService.execute()
    }
    
    func cancelLoadCoreML() {
        generateImageFromTextService.cancel()
    }
}

extension PromptImageGeneratorViewModel {
    enum VMState {
        case processing
        case ready
        case initial
        case error(Error)
    }
}

extension String: Error {}
