//
//  NetworkClient.swift
//  W1D1NetworkLayer
//
//  Created by Алексей Лысенко on 03.04.2022.
//

import Foundation
import Apollo
import UIKit

extension NetworkClient {
    typealias EditorColorFilter = GetChallengeEditorFilterQuery.Data.BaseChallenge.AppEditorFilter
    typealias EditorMasksFilter = GetChallengeEditorMasksFiltersQuery.Data.BaseChallenge.AppEditorMask
    typealias EditorTexturesFilter = GetChallengeEditorTexturesFiltersQuery.Data.BaseChallenge.AppEditorTexture
    typealias EditorTemplate = GetChallengeEditorTemplatesQuery.Data.BaseChallenge.AppEditorTemplate
    typealias AttachedEditorTemplate = GetChallengeMetaQuery.Data.BaseChallenge.AppAttachedEditorTemplate
    typealias StickerPack = GetChallengeStickerPacksFullQuery.Data.BaseChallenge.AppStickerPack
    typealias BaseChallenge = GetChallengeMetaQuery.Data.BaseChallenge
}

protocol NetworkClient {
    func removeBackground(for image: UIImage) async throws -> (UIImage, URL)
    func filters(forChallenge baseChallengeId: GraphQLID) async throws -> [EditorColorFilter]
    func masks(forChallenge baseChallengeId: GraphQLID) async throws -> [EditorMasksFilter]
    func textures(forChallenge baseChallengeId: GraphQLID) async throws -> [EditorTexturesFilter]
    func editorTemplates(forChallenge baseChallengeId: GraphQLID, renderSize: CGSize) async throws -> [EditorTemplate]
    func stickers(forChallenge baseChallengeId: GraphQLID) async throws -> [StickerPack]
    func challengeMeta(for baseChallengeId: GraphQLID) async throws -> BaseChallenge?
}

enum NetworkClientError: Error {
    case couldNotBuildURL
    case badRequestResult
}

final class NetworkClientImpl: NetworkClient {
    static private let APIDomain = "app.w1d1.com"
    static private let demoAPIDomain = "v2.w1d1.com"
    static private var currentAPIDomain: String { APIDomain }
    
    private let apollo: ApolloClient
    
    init() {
        CachePolicy.default = .fetchIgnoringCacheData
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        
        let client = URLSessionClient()
        let provider = NetworkInterceptorProvider(store: store, client: client)
        let url = URL(string: "https://\(NetworkClientImpl.currentAPIDomain)/graphql")!

        let requestChainTransport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                                  endpointURL: url)
        
        apollo = ApolloClient(networkTransport: requestChainTransport,
                              store: store)
    }
    
    func removeBackground(for image: UIImage) async throws -> (UIImage, URL) {
        enum RemBgError: Error {
            case noPngData
        }
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var postData = Data()
    
        let paramName = "image"
        
        postData += "--\(boundary)\r\n"
        postData += "Content-Disposition:form-data; name=\"\(paramName)\""

        guard let pngData = image.pngData() else {
            throw RemBgError.noPngData
        }
        
        let filename = "\(UUID().uuidString).png"
        postData += "; filename=\"\(filename)\"\r\n"
        postData += "Content-Type: \"content-type header\"\r\n\r\n"
        postData.append(pngData)
        postData += "\r\n"
        postData += "--\(boundary)--\r\n";
         
        guard let requestURL = URL(string: "https://\(NetworkClientImpl.APIDomain)/api/v2/fileProcessing/removeBackground") else {
            throw NetworkClientError.couldNotBuildURL
        }

        var request = URLRequest(url: requestURL, timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        
        return try await withCheckedThrowingContinuation { c in
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    c.resume(throwing: error)
                    return
                }
                
                guard let data = data,
                    let image = UIImage(data: data),
                      let pngData = image.pngData() else {
                    c.resume(throwing: NetworkClientError.badRequestResult)
                    return
                }
                
                let tempFileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).png")
                do {
                    try pngData.write(to: tempFileURL)
                    
                    c.resume(returning: (image, tempFileURL))
                } catch {
                    c.resume(throwing: error)
                }
            }.resume()
        }
    }
    
    
    func filters(forChallenge baseChallengeId: GraphQLID) async throws -> [EditorColorFilter] {
        let requestRes = try await apollo
            .fetch(
                query: GetChallengeEditorFilterQuery(baseChallengeId: baseChallengeId),
                queue: .global()
            )
        return requestRes.data?.baseChallenge.appEditorFilters ?? []
    }
    
    func masks(forChallenge baseChallengeId: GraphQLID) async throws -> [EditorMasksFilter] {
        let requestRes = try await apollo
            .fetch(
                query: GetChallengeEditorMasksFiltersQuery(baseChallengeId: baseChallengeId),
                queue: .global()
            )
        return requestRes.data?.baseChallenge.appEditorMasks ?? []
    }
    
    func textures(forChallenge baseChallengeId: GraphQLID) async throws -> [EditorTexturesFilter] {
        let requestRes = try await apollo
            .fetch(
                query: GetChallengeEditorTexturesFiltersQuery(baseChallengeId: baseChallengeId),
                queue: .global()
            )
        
        return requestRes.data?.baseChallenge.appEditorTextures ?? []
    }
    
    func stickers(forChallenge baseChallengeId: GraphQLID) async throws -> [StickerPack] {
        let requestRes = try await apollo
            .fetch(
                query: GetChallengeStickerPacksFullQuery(baseChallengeId: baseChallengeId),
                queue: .global()
            )
        
        return requestRes.data?.baseChallenge.appStickerPacks ?? []
    }
    
    func editorTemplates(forChallenge baseChallengeId: GraphQLID, renderSize: CGSize) async throws -> [EditorTemplate] {
        let requestRes = try await apollo
            .fetch(
                query: GetChallengeEditorTemplatesQuery(baseChallengeId: baseChallengeId, screenHeight: Int(renderSize.height), screenWidth: Int(renderSize.width)),
                queue: .global()
            )
        
        
        return requestRes.data?.baseChallenge.appEditorTemplates ?? []
    }
    
    func challengeMeta(for baseChallengeId: GraphQLID) async throws -> BaseChallenge? {
        try await apollo
            .fetch(
                query: GetChallengeMetaQuery(baseChallengeId: baseChallengeId),
                queue: .global()
            ).data?.baseChallenge
    }
}
