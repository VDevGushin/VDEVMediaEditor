//
//  UIImage_Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import UIKit

extension UIImage {
    static func imageFromBundle(_ named: String) -> UIImage {
        UIImage(named: named, in: Bundle.main, compatibleWith: nil) ?? UIImage()
    }
    
    static var template: UIImage {
        UIImage(named: "templateImage")!
    }

    var aspectRatio: CGFloat {
        size.width / size.height
    }
    
    var pixelSize: CGSize {
        let heightInPoints = size.height
        let heightInPixels = heightInPoints * scale

        let widthInPoints = size.width
        let widthInPixels = widthInPoints * scale

        return CGSize(width: widthInPixels, height: heightInPixels)
    }
}

extension UIImage {
    var rotatedCIImage: CIImage? {
        CIImage(image: self, options: [
            .applyOrientationProperty: true,
            .properties: [
                kCGImagePropertyOrientation: imageOrientation.cgOrientation.rawValue
            ]
        ])
    }
}

extension UIImage.Orientation {
    var cgOrientation: CGImagePropertyOrientation {
        CGImagePropertyOrientation(self)
    }
}

extension UIImage {
    func aspectFittedToHeight(_ longSize: CGFloat) -> UIImage {
        if  self.size.height > self.size.width {
            let scale = longSize / self.size.height
            let newWidth = self.size.width * scale
            let newSize = CGSize(width: newWidth, height: longSize)
            let renderer = UIGraphicsImageRenderer(size: newSize)

            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            }
        } else {
            let scale = longSize / self.size.width
            let newHeight = self.size.height * scale
            let newSize = CGSize(width: longSize, height: newHeight)
            let renderer = UIGraphicsImageRenderer(size: newSize)

            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
    }

    func compressImage(compressionQuality: CGFloat = 0.1, longSize: CGFloat = 1024) -> UIImage {
            let resizedImage = self.aspectFittedToHeight(longSize)
            resizedImage.jpegData(compressionQuality: compressionQuality)
            return resizedImage
    }
    
    func inverseImage(cgResult: Bool) -> UIImage? {
        let theImage = self //this takes the image currently loaded on our UIImageView

        //this creates a CIFilter with the attribute color invert
        guard let filter = CIFilter(name: "CIColorInvert") else {
            return nil
        }

        filter.setValue(CIImage(image: theImage), forKey: kCIInputImageKey) //this applies our filter to our UIImage
        
        guard let outputImage = filter.outputImage else { return nil }

        //this takes our inverted image and stores it as a new UIImage
        let newImage = UIImage(ciImage: outputImage)

        return newImage
       }
    
}
