//
//  ImageCache+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import Foundation
import Kingfisher
import UIKit

extension ImageCache {
    func retrieveImage(
        forKey key: String,
        options: KingfisherOptionsInfo? = nil,
        callbackQueue: CallbackQueue = .mainCurrentOrAsync
    ) async throws -> ImageCacheResult {
        try await withCheckedThrowingContinuation { continuation in
            retrieveImage(forKey: key, options: options, callbackQueue: callbackQueue) { retrResult in
                switch retrResult {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let cacheResult):
                    continuation.resume(returning: cacheResult)
                }
            }
        }
    }

    func retrieveImage(
        downloadAndStoreIfNeededFrom: URL? = nil,
        forKey key: String,
        options: KingfisherOptionsInfo? = nil,
        callbackQueue: CallbackQueue = .mainCurrentOrAsync
    ) async throws -> ImageCacheResult {
        if !isCached(forKey: key), let downloadURL = downloadAndStoreIfNeededFrom {
            let image: UIImage = try await withCheckedThrowingContinuation { continuation in
                let dataTask = URLSession.shared.dataTask(with: downloadURL) { data, _, error in
                    guard let data = data,
                          let image = UIImage(data: data) else {
                        continuation.resume(throwing: error ?? NSError(domain: "ImageCache", code: 1))
                        return
                    }
                    continuation.resume(returning: image)
                }
                dataTask.resume()
            }
            store(image, forKey: key)
        }
        return try await retrieveImage(forKey: key, options: options, callbackQueue: callbackQueue)
    }
}
