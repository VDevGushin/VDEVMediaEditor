//
//  SessionCache.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import Foundation
import CoreImage

private var sessionCaches = [String: Any]()
class SessionCache<T> {
    static func data(from url: URL, storeCache: Bool, extractor: @autoclosure (() -> T?)) -> T? {
        return data(fromIdentifier: url.absoluteString, storeCache: storeCache, extractor: extractor())
    }

    static func data(fromIdentifier identifier: String, storeCache: Bool, extractor: @autoclosure (() -> T?)) -> T? {
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
}

