//
//  FilteringProcessor+Processor.swift
//  
//
//  Created by Vladislav Gushin on 27.07.2023.
//

import UIKit
import Photos
import AVFoundation

extension FilteringProcessor {
    final class Processor {
        private var filterChain: [FilterDescriptor]
        private var filters: [CIFilter]
        private var bootstrapped: Bool = false
        
        init?(filterChain: [FilterDescriptor]) {
            let _filters = filterChain.compactMap { CIFilter(name: $0.name) }
            guard !_filters.isEmpty else { return nil}
            self.filterChain = filterChain
            self.filters = _filters
        }
        
        func applyFilters(to sourceImage: CIImage) -> CIImage {
            bootstrapIfNeeded(forSource: sourceImage)
            var imageOutput = sourceImage
            autoreleasepool {
                filters.enumerated().forEach { (offset, filter) in
                    if let customImageTargetKey = filterChain[offset].customImageTargetKey {
                        filter.setValue(imageOutput, forKey: customImageTargetKey)
                    } else {
                        filter.setValue(imageOutput, forKey: kCIInputImageKey)
                    }
                    imageOutput = filter.outputImage ?? imageOutput
                }
            }
            return imageOutput
        }
        
        private func bootstrapIfNeeded(forSource source: CIImage) {
            for (offset, filter) in filters.enumerated() {
                guard let descriptor = filterChain[safe: offset] else { continue }
                for (key, value) in descriptor.params ?? [:] where value != .unsupported {
                    if case let FilterDescriptor.Param.image(image, contentMode, url) = value {
                        let uniqKey = [
                            "resized-content-mode",
                            url.absoluteString,
                            "\(contentMode?.rawValue ?? -1)",
                            "\(source.extent.width)|\(source.extent.height)"
                        ].joined(separator: "-")
                        let modifiedImage = SessionCache<CIImage>.data(
                            fromIdentifier: uniqKey,
                            storeCache: true,
                            extractor: image.resized(to: source.extent.size, withContentMode: contentMode ?? .bottomLeft)
                        )
                        filter.setValue(modifiedImage, forKey: key)
                    } else {
                        filter.setValue(value.valueForParams, forKey: key)
                    }
                }
            }
            bootstrapped = true
        }
    }
}
