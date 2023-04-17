//
//  PlaceholderMaskLoader.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.03.2023.
//

import UIKit
import Kingfisher

enum PlaceholderMaskLoader {
    static func load(from url: URL?) async -> UIImage? {
        guard let url = url else {
            return nil
        }
        
        guard let cacheResult = try? await ImageCache.default.retrieveImage(
            downloadAndStoreIfNeededFrom: url,
            forKey: url.absoluteString
        ) else {
            return nil
        }
        
        return cacheResult.image
    }
}
