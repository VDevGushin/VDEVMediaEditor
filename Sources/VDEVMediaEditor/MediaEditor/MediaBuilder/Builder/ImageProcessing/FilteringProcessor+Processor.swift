//
//  FilteringProcessor+Processor.swift
//  
//
//  Created by Vladislav Gushin on 27.07.2023.
//

import UIKit
import Photos
import AVFoundation

private enum ProcessingFilter {
    case filter(CIFilter, FilterDescriptor)
    case neural(NeuralFilter)
    
    init?(filterDescriptor: FilterDescriptor) {
        if let ciFilter = CIFilter(name: filterDescriptor.name) {
            self = .filter(ciFilter, filterDescriptor)
            return
        }
        if let neuralProcessorFilter = NeuralFilter(descriptor: filterDescriptor) {
            self = .neural(neuralProcessorFilter)
            return
        }
        return nil
    }
}

extension FilteringProcessor {
    final class Processor {
        private var filterChain: [ProcessingFilter]
        
        init?(filterChain: [FilterDescriptor]) {
            guard !filterChain.isEmpty else { return nil }
            self.filterChain = filterChain.compactMap {
                ProcessingFilter(filterDescriptor: $0)
            }
        }
        
        func applyFilters(to sourceImage: CIImage) -> CIImage {
            bootstrap(forSource: sourceImage)
            var imageOutput = sourceImage
            autoreleasepool {
                for filter in filterChain {
                    switch filter {
                    case let .neural(neuralFilter):
                        imageOutput = neuralFilter.execute(imageOutput) ?? imageOutput
                    case let .filter(ciFilter, descriptor):
                        if let customImageTargetKey = descriptor.customImageTargetKey {
                            ciFilter.setValue(imageOutput, forKey: customImageTargetKey)
                        } else {
                            ciFilter.setValue(imageOutput, forKey: kCIInputImageKey)
                        }
                        imageOutput = ciFilter.outputImage ?? imageOutput
                    }
                }
            }
            return imageOutput
        }
        
        private func bootstrap(forSource source: CIImage) {
            for filter in filterChain {
                switch filter {
                case .neural: continue
                case let .filter(ciFilter, descriptor):
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
                            ciFilter.setValue(modifiedImage, forKey: key)
                        } else {
                            ciFilter.setValue(value.valueForParams, forKey: key)
                        }
                    }
                }
            }
        }
    }
}
