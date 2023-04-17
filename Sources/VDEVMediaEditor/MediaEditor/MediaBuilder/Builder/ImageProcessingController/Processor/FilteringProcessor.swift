//
//  FilteringProcessor.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 26.02.2023.
//

import UIKit
import Photos
import AVFoundation

final class FilteringProcessor {
    static let shared = FilteringProcessor()
    private let renderContext = CIContext()
    static let renderingQueue = DispatchQueue(label: "w1d1.serial.filteringprocessor.renderingQueue")
    
    private init() {}


    func process(image: UIImage, filteringChain: [FilterDescriptor]) -> CIImage? {
        guard let image = image.rotatedCIImage else { return nil }
        let filterChain = Processor(filterChain: filteringChain)
        return filterChain.applyFilters(to: image)
    }

    func makeAVVideoComposition(
        for asset: AVAsset,
        filterChain: [FilterDescriptor],
        resize: (CGSize, UIView.ContentMode)? = nil
    ) -> AVVideoComposition {
        let filterChain = Processor(filterChain: filterChain)

        let composition = AVMutableVideoComposition(asset: asset, applyingCIFiltersWithHandler: { [filterChain] request in
            autoreleasepool {
                var imageOutput = filterChain.applyFilters(to: request.sourceImage)
                if let resize = resize {
                    imageOutput = imageOutput
                        .resized(to: resize.0, withContentMode: resize.1)
                        .cropped(to: CGRect(origin: .zero, size: resize.0))
                }
                request.finish(with: imageOutput, context: nil)
            }
        })
        // https://developer.apple.com/av-foundation/Incorporating-HDR-video-with-Dolby-Vision-into-your-apps.pdf
        if #available(iOS 14.0, *) {
            if !asset.tracks(withMediaCharacteristic: .containsHDRVideo).isEmpty {
                composition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2
                composition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2
                composition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2
            }
        }
        if let resize = resize { composition.renderSize = resize.0 }
        return composition
    }

    func processAndExport(
        asset: AVAsset,
        containerSize: CGSize,
        videoSize: CGSize,
        filterChain: [FilterDescriptor],
        exportQuality: FilteringProcessor.ExportQuality,
        trasform: Transform,
        mask: CGImage?
        
    ) async throws -> URL {
        
        let filterChain = FilteringProcessor.Processor(filterChain: filterChain)
        
        let composition = AVMutableVideoComposition(asset: asset, applyingCIFiltersWithHandler: { [filterChain] request in
            
            autoreleasepool {
                var imageOutput = filterChain.applyFilters(to: request.sourceImage)
                
                imageOutput = imageOutput
                    .frame(videoSize, contentMode: .scaleAspectFill)
                
                let container = CIImage(color: .clear)
                    .frame(containerSize, contentMode: .scaleAspectFill)
                
                imageOutput = imageOutput
                    .composited(with: container, canvasSize: containerSize, transform: trasform)
                    .cropped(to: .init(origin: .zero, size: containerSize))
                
                if let mask = mask {
                    imageOutput = imageOutput.createMask(maskCG: mask, for: containerSize)
                }
            
                request.finish(with: imageOutput, context: nil)
            }
        })
        
        if #available(iOS 14.0, *) {
            if !asset.tracks(withMediaCharacteristic: .containsHDRVideo).isEmpty {
                composition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2
                composition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2
                composition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2
            }
        }
        
        composition.renderSize = containerSize
        
        return try await processAndExportComposition(composition, ofAsset: asset, exportQuality: exportQuality)
    }

    func processAndExport(
        asset: AVAsset,
        filterChain: [FilterDescriptor],
        resize: (CGSize, UIView.ContentMode)? = nil,
        exportQuality: ExportQuality
    ) async throws -> URL {
        let composition = makeAVVideoComposition(for: asset, filterChain: filterChain, resize: resize)
        return try await processAndExportComposition(composition, ofAsset: asset, exportQuality: exportQuality)
    }

    func createCGImage(from ciImage: CIImage) -> CGImage? {
        renderContext.createCGImage(ciImage, from: ciImage.extent)
    }
    
    /// Generates JPG image on the internal storage and returns local URL
    /// - Parameter ciImage: image to generate JPG from
    /// - Parameter jpgQuality: float number from 0.0 to 1.0 representing compression quality
    /// - Throws: Any error while generating png oand saving it
    /// - Returns: local URL of newly generated JPG file
    func generateAndSave(ciImage: CIImage, withJPGQuality jpgQuality: CGFloat = 1.0) throws -> URL {
        let generatedImagePath = try generateURLInCacheDir(withExtension: "jpg")
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        try renderContext
            .writeJPEGRepresentation(of: ciImage,
                                     to: generatedImagePath,
                                     colorSpace: colorSpace,
                                     options: [
                                        kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption : jpgQuality
                                     ])
        return generatedImagePath
    }
    
    public func resizeAndExport(
        _ asset: AVAsset,
        container: CGRect,
        withContentMode contentMode: UIView.ContentMode?,
        exportQuality: ExportQuality
    ) async throws -> URL {
        let composition = AVMutableVideoComposition(asset: asset) { request in
            autoreleasepool {
                let imageOutput = request.sourceImage.resized(to: container.size, withContentMode: contentMode ?? .bottomLeft)
                request.finish(with: imageOutput, context: nil)
            }
        }
        composition.renderSize = container.size

        return try await processAndExportComposition(composition, ofAsset: asset, exportQuality: exportQuality)
    }
}

// MARK: - Save
extension FilteringProcessor {
    /// Generates png image on the internal storage and returns local URL
    /// - Parameter ciImage: image to generate png from
    /// - Throws: Any error while generating png oand saving it
    /// - Returns: local URL of newly generated PNG file
    private func generateAndSaveImage(ciImage: CIImage) throws -> URL {
        let generatedImagePath = try generateURLInCacheDir(withExtension: "png")
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
        try renderContext
            .writePNGRepresentation(of: ciImage,
                                    to: generatedImagePath,
                                    format: .RGBA8,
                                    colorSpace: colorSpace,
                                    options: [:])

        return generatedImagePath
    }
    
    private func processAndExportComposition(
        _ composition: AVVideoComposition,
        ofAsset asset: AVAsset,
        exportQuality: ExportQuality
    ) async throws -> URL {
        
        guard let export = AVAssetExportSession(asset: asset,
                                                presetName: exportQuality.presetId) else {
            throw ProcessorError.couldNotMakeExportSession
        }

        let outURL = try generateURLInCacheDir(withExtension: "mp4")

        export.outputFileType = .mp4
        export.outputURL = outURL
        export.videoComposition = composition
        export.shouldOptimizeForNetworkUse = false

        return try await withCheckedThrowingContinuation { c in
            export.exportAsynchronously { [weak export] in
                if let error = export?.error {
                    Log.e(error)
                    c.resume(throwing: error)
                    return
                }
                Log.d(outURL)
                c.resume(returning: outURL)
            }
        }
    }
    
    private func generateURLInCacheDir(withExtension extension: String) throws -> URL {
        let imageIdentifier = UUID().uuidString
        let tmpDirURL = FileManager.default.temporaryDirectory
        return tmpDirURL.appendingPathComponent(imageIdentifier).appendingPathExtension(`extension`)
    }
}

// MARK: - Helpers
extension FilteringProcessor {
    enum ProcessorError: Error {
        case imageReturnedNull
        case processImageReturnedNil
        
        case couldNotMakeExportSession
        case couldNotMakeOutputURL
    }
    
    enum ExportQuality {
        case low
        case medium
        case highest

        case HEVCHighest
        case HEVCHighestWithAlpha
        
        case `default`

        var presetId: String {
            switch self {
            case .low: return AVAssetExportPresetLowQuality
            case .medium: return AVAssetExportPresetMediumQuality
            case .highest: return AVAssetExportPresetHighestQuality
            case .HEVCHighest: return AVAssetExportPresetHEVCHighestQuality
            case .HEVCHighestWithAlpha: return AVAssetExportPresetHEVCHighestQualityWithAlpha
            case .default: return AVAssetExportPresetPassthrough
                
            }
        }
    }
}

private extension FilteringProcessor {
    final class Processor {
        private var filterChain: [FilterDescriptor]
        private var filters: [CIFilter]
        private var bootstrapped: Bool = false
        
        init(filterChain: [FilterDescriptor]) {
            self.filterChain = filterChain
            self.filters = filterChain.compactMap { CIFilter(name: $0.name) }
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
            guard !bootstrapped else { return }
            
            for (offset, filter) in filters.enumerated() {
                guard let descriptor = filterChain[safe: offset] else {
                    continue
                }
                
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
