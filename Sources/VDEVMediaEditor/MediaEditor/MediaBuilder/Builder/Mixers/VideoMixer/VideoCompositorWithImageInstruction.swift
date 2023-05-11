//
//  VideoCompositorWithImageInstruction.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 01.03.2023.
//

import UIKit
import AVKit
import CoreImage

final class VideoCompositorWithImageInstruction: NSObject, AVVideoCompositionInstructionProtocol {
    var layerInstructions: [LayerInstruction] = []
    var timeRange: CMTimeRange = .zero
    var canvasSize: CGSize = .zero
    
    private(set) var enablePostProcessing = true
    private(set) var containsTweening = true
    private(set) var requiredSourceTrackIDs: [NSValue]? = nil
    private(set) var passthroughTrackID: CMPersistentTrackID = kCMPersistentTrackID_Invalid

    final class LayerInstruction {
        enum Body {
            case video(trackId: CMPersistentTrackID, preferredTransform: CGAffineTransform)
            case image(ciImage: CIImage)
        }

        let body: Body
        let transform: Transform

        init(assetTrack: AVAssetTrack, transform: Transform) {
            self.body = .video(trackId: assetTrack.trackID, preferredTransform: assetTrack.preferredTransform)
            self.transform = transform
        }

        init(ciImage: CIImage, transform: Transform) {
            self.body = .image(ciImage: ciImage)
            self.transform = transform
        }
    }
}

final class VideoCompositorWithImage: NSObject, AVVideoCompositing {
    enum CompositorError: Error {
        case compositorSupportsOnlySelfInstructions
        case problemWithPixelBufferInit
        case problemWithCGContextInit
    }

    var sourcePixelBufferAttributes: [String : Any]? {
        ["\(kCVPixelBufferPixelFormatTypeKey)": kCVPixelFormatType_32BGRA]
    }

    var requiredPixelBufferAttributesForRenderContext: [String : Any] {
        ["\(kCVPixelBufferPixelFormatTypeKey)": kCVPixelFormatType_32BGRA]
    }

    private let colorSpace = CGColorSpaceCreateDeviceRGB()
    private lazy var imageContext = CIContext()

    func renderContextChanged(_ newRC: AVVideoCompositionRenderContext) {
        // do anything in here you need to before you start writing frames
    }

    func startRequest(_ request: AVAsynchronousVideoCompositionRequest) {
        guard let instruction = request.videoCompositionInstruction as? VideoCompositorWithImageInstruction else {
            request.finish(with: CompositorError.compositorSupportsOnlySelfInstructions)
            return
        }

        let frameSize = request.renderContext.size
        let canvasSize = instruction.canvasSize

        guard let buffer = request.renderContext.newPixelBuffer() else {
            request.finish(with: CompositorError.problemWithPixelBufferInit)
            return
        }

        var outImage = CIImage(color: .clear)

        for layerInstruction in instruction.layerInstructions {
            autoreleasepool {
                let frameImage: CIImage
                switch layerInstruction.body {
                case .image(let ciImage):
                    frameImage = ciImage
                case .video(let trackId, let preferredTransform):
                    frameImage = request.sourceFrame(byTrackID: trackId).map {
                        prepareFrameBuffer($0, preferredTransform: preferredTransform, canvasSize: canvasSize)
                    } ?? CIImage(color: .clear)
                }
                outImage = frameImage
                    .composited(
                        with: outImage,
                        canvasSize: canvasSize,
                        transform: layerInstruction.transform
                    )
            }
        }
        
        outImage = outImage
            .cropped(to: CGRect(origin: .zero, size: canvasSize))
            .frame(frameSize, contentMode: .scaleAspectFill)
            .cropped(to: CGRect(origin: .zero, size: frameSize))

        imageContext.render(outImage, to: buffer)

        request.finish(withComposedVideoFrame: buffer)
        CVBufferRemoveAllAttachments(buffer)
    }

    func prepareFrameBuffer(_ frameBuffer: CVPixelBuffer,
                            preferredTransform: CGAffineTransform,
                            canvasSize: CGSize) -> CIImage {
        // Basic transform. rotate portrait or landscape if needed
        var frameImage = CIImage(cvImageBuffer: frameBuffer).transformed(by: preferredTransform)

        // If there was some special transform, need to add additional 180 degrees
        if preferredTransform != .identity {
            let newRect = frameImage.extent.applying(.identity.rotated(by: .pi))
            frameImage = frameImage
                .transformed(by: .identity.rotated(by: .pi))
            // after rotation, frame is below zero, becase rotation originon is (0, 0)
            // so we translate image back to normal position
                .transformed(by: .identity.translatedBy(x: -newRect.origin.x, y: -newRect.origin.y))
        }

        return frameImage
    }
}
