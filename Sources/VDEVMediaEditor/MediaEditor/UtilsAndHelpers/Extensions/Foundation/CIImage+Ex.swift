//
//  CIImage+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import UIKit
import Kingfisher

extension CIImage {
    func autoEnhance() -> CIImage {
        var ciImage = self
        //let adjustments = ciImage.autoAdjustmentFilters()
        let adjustments = ciImage.autoAdjustmentFilters(options: [.redEye: false, .enhance: true, .crop: false, .level: false])
        for filter in adjustments {
            filter.setValue(ciImage, forKey: kCIInputImageKey)
            if let outputImage = filter.outputImage { ciImage = outputImage }
        }
        return ciImage
    }
    
    func originCropped(to contanier: CGRect) -> CIImage {
        transformed(by: .init(translationX: -contanier.origin.x, y: -contanier.origin.y))
            .cropped(to: CGRect(origin: .zero, size: contanier.size))
    }
    
    func resized(to size: CGSize, withContentMode contentMode: UIView.ContentMode) -> CIImage {
        return frame(size, contentMode: contentMode)
            .composedAndCropped(to: CGRect(origin: .zero, size: size))
    }
    
    // Повышение стабильности (были проблемы с рендером видосов из шаблонов)
    func resized(to size: CGSize, context: CIContext) -> CIImage? {
        guard let filter = CIFilter(name: "CILanczosScaleTransform") else {
            return nil
        }
        let sourceImage = self
        let scale: CGFloat = max(size.width / (sourceImage.extent.width),
                                 size.height / (sourceImage.extent.height))
        filter.setValue(sourceImage, forKey: kCIInputImageKey)
        filter.setValue(scale, forKey: kCIInputScaleKey)
        
        guard let outputCIImage = filter.outputImage,
              let outputCGImage = context.createCGImage(outputCIImage,
                                                        from: outputCIImage.extent)
        else {
            return nil
        }
        let resImage = UIImage(cgImage: outputCGImage)
        guard let ciImage = resImage.rotatedCIImage else { return nil }
        return ciImage
    }
}

// MARK: - Trasforms
extension CIImage {
    func transform(
        canvasSize: CGSize,
        transform: Transform
    ) -> CIImage {
        let assetSize = extent.size
        let halfCanvas = canvasSize / 2
        let contentCenretize = assetSize / 2
        let affine = CGAffineTransform.identity
        // move before actions, to make scale and rotation against (0.5, 0.5)
            .translatedBy(
                x: -contentCenretize.width,
                y: -contentCenretize.height
            )
        // rotate
            .concatenating(.identity.rotated(by: -transform.radians))
        // scale
            .concatenating(.identity.scaledBy(x: transform.scale, y: transform.scale))
        // move back
            .concatenating(.identity.translatedBy(
                x: contentCenretize.width,
                y: contentCenretize.height
            ))
        // move asset to the center of canvas
            .concatenating(.identity.translatedBy(
                x: halfCanvas.width - (assetSize.width / 2),
                y: halfCanvas.height - (assetSize.height / 2)
            ))
        // move to transform positions
            .concatenating(.identity.translatedBy(
                x: transform.offset.width,
                y: -transform.offset.height
            ))
        return transformed(by: affine)
    }
    
    func composited(
        with secondImage: CIImage,
        canvasSize: CGSize,
        transform: Transform
    ) -> CIImage {
        let assetSize = extent.size
        let halfCanvas = canvasSize / 2
        let contentCenretize = assetSize / 2
        let affine = CGAffineTransform.identity
        // move before actions, to make scale and rotation against (0.5, 0.5)
            .translatedBy(
                x: -contentCenretize.width,
                y: -contentCenretize.height
            )
        // rotate
            .concatenating(.identity.rotated(by: -transform.radians))
        // scale
            .concatenating(.identity.scaledBy(x: transform.scale, y: transform.scale))
        // move back
            .concatenating(.identity.translatedBy(
                x: contentCenretize.width,
                y: contentCenretize.height
            ))
        // move asset to the center of canvas
            .concatenating(.identity.translatedBy(
                x: halfCanvas.width - (assetSize.width / 2),
                y: halfCanvas.height - (assetSize.height / 2)
            ))
        // move to transform positions
            .concatenating(.identity.translatedBy(
                x: transform.offset.width,
                y: -transform.offset.height
            ))
        return transformed(by: affine)
            .composited(over: secondImage, with: transform.blendingMode)
    }
}

// Пытаемся создать маску из URL картинки маски
extension CIImage {
    func createMask(
        maskCG: CGImage?,
        for size: CGSize,
        context: CIContext = .editorContext
    ) -> CIImage {
        guard let maskCG = maskCG else { return self }
        let context: CIContext = context
        let imageCI = self
        let maskCI = CIImage(cgImage: maskCG)
        let background = CIImage.empty()
        
        // Создаем фильтр маски
        guard let filter = CIFilter(name: "CIBlendWithMask") else { return self }
        filter.setValue(imageCI, forKey: "inputImage")
        filter.setValue(maskCI, forKey: "inputMaskImage")
        filter.setValue(background, forKey: "inputBackgroundImage")
        guard let outputImage = filter.outputImage,
              let maskedImage = context.createCGImage(outputImage, from: maskCI.extent) else {
            return self
        }
        let resImage = UIImage(cgImage: maskedImage)
        guard let ciImage = resImage.rotatedCIImage else { return self }
        return ciImage
    }
}

private extension CIImage {
    func composedAndCropped(to container: CGRect) -> CIImage {
        composited(over: CIImage(color: .clear).cropped(to: container))
            .cropped(to: container)
    }
    
    func frame(_ size: CGSize, contentMode: UIView.ContentMode) -> CIImage {
        let scaled = scaled(to: size, withContentMode: contentMode)
        let multiplier: CGVector
        switch contentMode {
        case .scaleToFill, .scaleAspectFit:
            multiplier = .init(dx: 0.5, dy: 0.5)
            return scaled.transformed(by: .identity.translatedBy(
                x: abs(size.width - scaled.extent.width) * multiplier.dx,
                y: abs(size.height - scaled.extent.height) * multiplier.dy
            ))
        case .scaleAspectFill:
            multiplier = .init(dx: -0.5, dy: -0.5)
            return scaled.transformed(by: .identity.translatedBy(
                x: abs(size.width - scaled.extent.width) * multiplier.dx,
                y: abs(size.height - scaled.extent.height) * multiplier.dy
            ))
        case .center:
            multiplier = .init(dx: 0.5, dy: 0.5)
            return scaled.transformed(by: .identity.translatedBy(
                x: (size.width - scaled.extent.width) * multiplier.dx,
                y: (size.height - scaled.extent.height) * multiplier.dy
            ))
        case .top:
            multiplier = .init(dx: 0.5, dy: 1)
            return scaled.transformed(by: .identity.translatedBy(
                x: (size.width - scaled.extent.width) * multiplier.dx,
                y: (size.height - scaled.extent.height) * multiplier.dy
            ))
        case .bottom:
            multiplier = .init(dx: 0.5, dy: 0)
            return scaled.transformed(by: .identity.translatedBy(
                x: (size.width - scaled.extent.width) * multiplier.dx,
                y: (size.height - scaled.extent.height) * multiplier.dy
            ))
        case .left:
            multiplier = .init(dx: 0, dy: 0.5)
            return scaled.transformed(by: .identity.translatedBy(
                x: (size.width - scaled.extent.width) * multiplier.dx,
                y: (size.height - scaled.extent.height) * multiplier.dy
            ))
        case .right:
            multiplier = .init(dx: 1, dy: 0.5)
            return scaled.transformed(by: .identity.translatedBy(
                x: (size.width - scaled.extent.width) * multiplier.dx,
                y: (size.height - scaled.extent.height) * multiplier.dy
            ))
        case .topLeft:
            multiplier = .init(dx: 0, dy: 1)
            return scaled.transformed(by: .identity.translatedBy(
                x: (size.width - scaled.extent.width) * multiplier.dx,
                y: (size.height - scaled.extent.height) * multiplier.dy
            ))
        case .topRight:
            multiplier = .init(dx: 1, dy: 1)
            return scaled.transformed(by: .identity.translatedBy(
                x: (size.width - scaled.extent.width) * multiplier.dx,
                y: (size.height - scaled.extent.height) * multiplier.dy
            ))
        case .bottomRight:
            multiplier = .init(dx: 1, dy: 0)
            return scaled.transformed(by: .identity.translatedBy(
                x: (size.width - scaled.extent.width) * multiplier.dx,
                y: (size.height - scaled.extent.height) * multiplier.dy
            ))
        default: // same as bottomLeft
            multiplier = .init(dx: 0, dy: 0)
            return scaled.transformed(by: .identity.translatedBy(
                x: (size.width - scaled.extent.width) * multiplier.dx,
                y: (size.height - scaled.extent.height) * multiplier.dy
            ))
        }
    }
    
    func scaled(to size: CGSize, withContentMode contentMode: UIView.ContentMode) -> CIImage {
        switch contentMode {
        case .scaleToFill:
            let xScale = size.width / extent.width
            let yScale = size.height / extent.height
            return transformed(by: CGAffineTransform(scaleX: xScale, y: yScale))
        case .scaleAspectFit:
            let widthRatio = size.width / extent.width
            let heightRatio = size.height / extent.height
            let bestRatio = min(widthRatio, heightRatio)
            return transformed(by: CGAffineTransform(scaleX: bestRatio, y: bestRatio))
        case .scaleAspectFill:
            let widthRatio = size.width / extent.width
            let heightRatio = size.height / extent.height
            let bestRatio = max(widthRatio, heightRatio)
            return transformed(by: CGAffineTransform(scaleX: bestRatio, y: bestRatio))
        default: return self
        }
    }
    
    func composited(over bgImage: CIImage, with blendingMode: BlendingMode) -> CIImage {
        let filter = blendingMode.ciFilter
        filter.setValue(self, forKey: kCIInputImageKey)
        filter.setValue(bgImage, forKey: kCIInputBackgroundImageKey)
        return filter.outputImage ?? self
    }
}
