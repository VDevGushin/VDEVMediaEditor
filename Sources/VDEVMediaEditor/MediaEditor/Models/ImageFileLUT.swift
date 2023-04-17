//
//  ImageFileLUT.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import UIKit
import CoreImage

class ImageFileLUT {
    let size = 64

    let lutImage: CGImage
    var lutWidth: Int { lutImage.width }
    var lutHeight: Int { lutImage.height }
    var rowCount: Int { lutHeight / size }
    var columnCount: Int { lutWidth / size }

    var bitmap: [UInt8]

    init?(imageData: Data) {
        guard let uiImage = UIImage(data: imageData),
              let cgImage = uiImage.cgImage else { return nil }
        lutImage = cgImage
        bitmap = []

        if ((lutWidth % size != 0) || (lutHeight % size != 0) || (rowCount * columnCount != size)) {
            return nil
        }

        bitmap = getBytesFromImage(image: uiImage)

        guard !bitmap.isEmpty else { return nil }
    }

    func generateLUTData() -> NSData {
        var cubeData = [Float](repeating: 0, count: size * size * size * 4)

        var index = 0
        for b in 0 ..< size {
            for g in 0 ..< size {
                for r in 0 ..< size {
                    let row = Int((Double(b) / Double(columnCount)).rounded(.towardZero))
                    let column = b % columnCount
                    let verticalPixelsInPlane = lutHeight / rowCount
                    let horizontalPixelsInPlane = lutWidth / columnCount
                    let onePlaneRawPixelsCount = verticalPixelsInPlane * horizontalPixelsInPlane * 4
                    let planeStart = (row * onePlaneRawPixelsCount * columnCount) + (column * horizontalPixelsInPlane * 4)
                    let imageOffset = planeStart + ((g * lutWidth) * 4) + (r * 4)

                    let alpha = Float(bitmap[imageOffset + 0]) / 255
                    let blue = Float(bitmap[imageOffset + 1]) / 255
                    let green = Float(bitmap[imageOffset + 2]) / 255
                    let red = Float(bitmap[imageOffset + 3]) / 255
                    cubeData[index * 4 + 0] = red
                    cubeData[index * 4 + 1] = green
                    cubeData[index * 4 + 2] = blue
                    cubeData[index * 4 + 3] = alpha
                    index += 1
                }
            }
        }
        let colorCubeData = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }

        return colorCubeData as NSData
    }

    private func getBytesFromImage(image: UIImage) -> [UInt8]
    {
        guard let imageRef = image.cgImage else { return [] }
        let width = Int(imageRef.width)
        let height = Int(imageRef.height)
        let bitsPerComponent = 8
        let bytesPerRow = width * 4
        let totalBytes = height * bytesPerRow

        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var intensities = [UInt8](repeating: 0, count: totalBytes)

        let contextRef = CGContext(data: &intensities, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        contextRef?.draw(imageRef, in: CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height)))
        return intensities
    }
}
