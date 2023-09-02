//
//  FilteringProcessor+Processor.swift
//  
//
//  Created by Vladislav Gushin on 27.07.2023.
//

import UIKit
import Photos
import AVFoundation

fileprivate extension CIFilter {
    var isBlur: Bool {
        name == "CIGaussianBlur"
    }
}

private enum ProcessingFilter {
    case filter(CIFilter, FilterDescriptor)
    case neural(AIFilter)
    
    init?(filterDescriptor: FilterDescriptor) {
        if let ciFilter: CIFilter = .init(name: filterDescriptor.name) {
            self = .filter(ciFilter, filterDescriptor)
            return
        }
        if let neuralProcessorFilter: AIFilter = .init(filterDescriptor) {
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
            let chain = filterChain.compactMap { ProcessingFilter(filterDescriptor: $0) }
            guard !chain.isEmpty else { return nil }
            self.filterChain = chain
        }
        
        func applyFilters(to sourceImage: CIImage) -> CIImage {
            bootstrap(forSource: sourceImage)
            var imageOutput = sourceImage
                for filter in filterChain {
                    switch filter {
                    case let .neural(neuralFilter):
                        imageOutput = neuralFilter.execute(imageOutput)
                    case let .filter(ciFilter, descriptor):
                        autoreleasepool {
                            if let customImageTargetKey = descriptor.customImageTargetKey {
                                ciFilter.setValue(imageOutput, forKey: customImageTargetKey)
                                imageOutput = ciFilter.outputImage ?? imageOutput
                            } else {
                                if ciFilter.isBlur {
                                    ciFilter.setValue(imageOutput, forKey: kCIInputImageKey)
                                    imageOutput = ciFilter.outputImage?.cropped(to: imageOutput.extent) ?? imageOutput
                                } else {
                                    ciFilter.setValue(imageOutput, forKey: kCIInputImageKey)
                                    imageOutput = ciFilter.outputImage ?? imageOutput
                                }
                            }
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
