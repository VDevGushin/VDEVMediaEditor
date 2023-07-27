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
    private let renderContext =  CIContext(options: [.useSoftwareRenderer: false])
    
    deinit {
        renderContext.clearCaches()
    }
    
    func process(
        image: UIImage,
        filteringChain: [FilterDescriptor]
    ) -> CIImage? {
        guard let image = image.rotatedCIImage,
              let filterChain = Processor(filterChain: filteringChain) else { return nil }
        return filterChain.applyFilters(to: image)
    }
    
    func makeAVVideoComposition(
        for asset: AVAsset,
        filterChain: [FilterDescriptor],
        resize: (CGSize, UIView.ContentMode)? = nil
    ) -> AVVideoComposition {
        let filterChain = Processor(filterChain: filterChain)
        let composition = AVMutableVideoComposition(
            asset: asset,
            applyingCIFiltersWithHandler: { [resize] request in
                var imageOutput: CIImage = request.sourceImage
                autoreleasepool {
                    var resizeImage: CIImage? = nil
                    if let resize = resize {
                        resizeImage = imageOutput
                            .resized(to: resize.0, withContentMode: resize.1)
                            .cropped(to: CGRect(origin: .zero, size: resize.0))
                    }
                    if let resizeImage = resizeImage {
                        imageOutput = resizeImage
                    }
                    
                    if let filteredImage = filterChain?.applyFilters(to: imageOutput) {
                        imageOutput = filteredImage
                    }
                }
                request.finish(with: imageOutput, context: nil)
            })
       
        if !asset.tracks(withMediaCharacteristic: .containsHDRVideo).isEmpty {
            composition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2
            composition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2
            composition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2
        }
        
        if let resize = resize { composition.renderSize = resize.0 }
        return composition
    }
    
    func createCGImage(from ciImage: CIImage) -> CGImage? {
        renderContext.createCGImage(ciImage, from: ciImage.extent)
    }
    
    func generateAndSavePNGImage(ciImage: CIImage) throws -> URL {
        try generateAndSaveImage(ciImage: ciImage)
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
    
    /// Generates JPG image on the internal storage and returns local URL
    /// - Parameter ciImage: image to generate JPG from
    /// - Parameter jpgQuality: float number from 0.0 to 1.0 representing compression quality
    /// - Throws: Any error while generating png oand saving it
    /// - Returns: local URL of newly generated JPG file
    func generateAndSave(
        ciImage: CIImage,
        withJPGQuality jpgQuality: CGFloat = 1.0
    ) throws -> URL {
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
    
    /// Generates png image on the internal storage and returns local URL
    /// - Parameter ciImage: image to generate png from
    /// - Throws: Any error while generating png oand saving it
    /// - Returns: local URL of newly generated PNG file
    func generateAndSaveImage(ciImage: CIImage) throws -> URL {
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
}

// MARK: - Generage videos for temlates
extension FilteringProcessor {
    func makePlaceHolderVideoAsset(
        asset: AVAsset,
        containerSize: CGSize,
        videoSize: CGSize,
        filterChain: [FilterDescriptor],
        exportQuality: FilteringProcessor.ExportQuality,
        trasform: Transform,
        mask: CGImage?
    ) async throws -> URL {
        let filterChain = Processor(filterChain: filterChain)
        let composition = VideoComposition(
            asset: asset,
            applyingCIFiltersWithHandler: { [weak self, containerSize, trasform, mask] request in
                guard let self = self else { return }
                var imageOutput = request.sourceImage
                autoreleasepool {
                    guard let newFramedImage = imageOutput.resized(
                        to: videoSize,
                        context: self.renderContext
                    ) else {
                        return
                    }
                    
                    imageOutput = newFramedImage
                        .transform(canvasSize: containerSize, transform: trasform)
                        .cropped(to: CGRect(origin: .zero, size: containerSize))
                    
                    if let filteredImage = filterChain?.applyFilters(to: imageOutput) {
                        imageOutput = filteredImage
                    }
                    
                    if let mask = mask {
                        imageOutput = imageOutput.createMask(
                            maskCG: mask,
                            for: containerSize,
                            context: self.renderContext
                        )
                    }
                }
                request.finish(with: imageOutput, context: self.renderContext)
            })
        
        
        if !asset.tracks(withMediaCharacteristic: .containsHDRVideo).isEmpty {
            composition.colorPrimaries = AVVideoColorPrimaries_ITU_R_709_2
            composition.colorTransferFunction = AVVideoTransferFunction_ITU_R_709_2
            composition.colorYCbCrMatrix = AVVideoYCbCrMatrix_ITU_R_709_2
        }
        
        composition.renderSize = containerSize
        
        return try await processAndExportComposition(
            composition,
            ofAsset: asset,
            exportQuality: exportQuality
        )
    }
}

// MARK: - Save
fileprivate extension FilteringProcessor {
    func processAndExportComposition(
        _ composition: AVVideoComposition,
        ofAsset asset: AVAsset,
        exportQuality: ExportQuality
    ) async throws -> URL {
        guard let export = AVAssetExportSession(
            asset: asset,
            presetName: exportQuality.presetId
        ) else {
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
    
    func generateURLInCacheDir(withExtension extension: String) throws -> URL {
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
            let canExportHEVCWithAlpha = AVAssetExportSession.allExportPresets().contains(AVAssetExportPresetHEVCHighestQualityWithAlpha)
            switch self {
            case .low: return AVAssetExportPresetLowQuality
            case .medium: return AVAssetExportPresetMediumQuality
            case .highest: return AVAssetExportPresetHighestQuality
            case .HEVCHighest: return AVAssetExportPresetHEVCHighestQuality
            case .HEVCHighestWithAlpha: return  canExportHEVCWithAlpha ?  AVAssetExportPresetHEVCHighestQualityWithAlpha : AVAssetExportPresetHighestQuality
            case .default: return AVAssetExportPresetPassthrough
            }
        }
    }
}

final class VideoComposition: AVMutableVideoComposition {
    deinit {
        Log.d("❌ Deinit[VideoComposition]: VideoComposition")
    }
}

// MARK: - Not use
fileprivate extension FilteringProcessor {
    func resizeAndExport(
        _ asset: AVAsset,
        container: CGRect,
        withContentMode contentMode: UIView.ContentMode?,
        exportQuality: ExportQuality
    ) async throws -> URL {
        let composition = AVMutableVideoComposition(asset: asset) { [container, contentMode] request in
            var imageOutput: CIImage = .init()
            autoreleasepool {
                imageOutput = request.sourceImage.resized(to: container.size, withContentMode: contentMode ?? .bottomLeft)
            }
            request.finish(with: imageOutput, context: nil)
        }
        composition.renderSize = container.size
        
        return try await processAndExportComposition(composition, ofAsset: asset, exportQuality: exportQuality)
    }
}
