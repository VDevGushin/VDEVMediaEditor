//
//  SessionCache.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import Foundation
import CoreImage

private var sessionCaches = [String: Any]()
public final class SessionCache<T> {
    public static func data(from url: URL, storeCache: Bool, extractor: @autoclosure (() -> T?)) -> T? {
        return data(fromIdentifier: url.absoluteString, storeCache: storeCache, extractor: extractor())
    }

    public static func data(fromIdentifier identifier: String, storeCache: Bool, extractor: @autoclosure (() -> T?)) -> T? {
        let type = String(describing: T.self)
        var sessionCache = (sessionCaches[type] as? [String: T]) ?? [:]
        if let cached = sessionCache[identifier] {
            return cached
        }
        if let newData = extractor() {
            if storeCache {
                sessionCache[identifier] = newData
                sessionCaches[type] = sessionCache
            }
            return newData
        }
        return nil
    }
    
    public static func warmup(_ urls: [URL]) {
        DispatchQueue.global(qos: .background).async {
            urls.forEach {
                _ = AssetExtractionUtil.image(fromUrl: $0, storeCache: true)
            }
        }
    }
}
