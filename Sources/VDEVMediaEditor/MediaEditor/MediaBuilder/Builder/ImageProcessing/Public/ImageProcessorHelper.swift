//
//  ImageProcessorHelper.swift
//  
//
//  Created by Vladislav Gushin on 18.07.2023.
//

import UIKit
import Photos
import AVFoundation

// MARK - Публичная шляпа
public final class ImageProcessorHelper {
    public static let shared = ImageProcessorHelper()
    public static let renderingQueue = DispatchQueue(label: "w1d1.serial.filteringprocessor.renderingQueue")
    private init() {}
    
    private var innerProcessor = FilteringProcessor()
    
    public func extractImage(
        fromUrl url: URL,
        storeCache: Bool = true) -> CIImage? {
        AssetExtractionUtil.image(fromUrl: url, storeCache: storeCache)
    }
    
    public func warmup(safeURLs: [URL]) {
        SessionCache<Any>.warmup(safeURLs)
    }
    
    public func generateAndSaveContent(
        withOverlayImage overlayImage: CIImage,
        overContentAtURL contentURL: URL,
        withContentMode contentMode: UIView.ContentMode? = nil
    ) async throws -> URL {
        let contentAsset = AVAsset(url: contentURL)
        let isVideo = contentAsset.isPlayable
        
        let filter = FilterDescriptor(
            name: "CISourceOverCompositing",
            params: [
                "inputImage": FilterDescriptor.Param.image(overlayImage, contentMode, URL(fileURLWithPath: ""))
            ],
            customImageTargetKey: "inputBackgroundImage"
        )
        
        if isVideo {
            let canExportHEVCWithAlpha = AVAssetExportSession.allExportPresets().contains(AVAssetExportPresetHEVCHighestQualityWithAlpha)
            let quality: FilteringProcessor.ExportQuality = canExportHEVCWithAlpha ? .HEVCHighestWithAlpha: .highest
            return try await innerProcessor.processAndExport(
                asset: contentAsset,
                filterChain: [filter],
                exportQuality: quality)
        } else {
            guard let processedImage = process(
                imageURL: contentURL,
                filterChain: [filter]
            ) else {
                throw FilteringProcessor.ProcessorError.processImageReturnedNil
            }
            let resultImage = try innerProcessor.generateAndSaveImage(ciImage: processedImage)
            return resultImage
        }
    }
    
    private func process(imageURL: URL, filterChain: [FilterDescriptor]) -> CIImage? {
        guard let image = AssetExtractionUtil.image(fromUrl: imageURL, storeCache: false),
              let filterChain = FilteringProcessor.Processor(filterChain: filterChain) else {
            return nil
        }
        return filterChain.applyFilters(to: image)
    }
}

