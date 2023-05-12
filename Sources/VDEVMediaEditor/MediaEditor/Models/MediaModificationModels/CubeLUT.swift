//
//  CubeLUT.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import Foundation

class CubeLUT {
    var size: Int
    typealias Row = (r: Double, g: Double, b: Double, a: Double)
    var data = [Row]()

    init?(cubeFileData: NSData) {
        guard let string = String(data: cubeFileData as Data, encoding: .utf8) else { return nil }
        let rows = string.components(separatedBy: "\n")
        guard rows.count > 0 else { return nil }
        var size: Int?
        var data: [Row] = [Row]()
        rows.forEach { row in
            let tokens = row.components(separatedBy: " ")
            guard tokens.count > 0 else { return }

            if tokens[0] == "LUT_3D_SIZE" {
                size = Int(tokens[1])
                return
            }

            if tokens.count >= 3, let r = Double.init(tokens[0]) {
                let g = Double(tokens[1]) ?? 1
                let b = Double(tokens[2]) ?? 1
                let a: Double
                if tokens.count > 3 {
                    a = Double(tokens[3]) ?? 1
                } else {
                    a = 1
                }
                data.append(Row(r, g, b, a))
            }
        }
        guard let safeSize = size, !data.isEmpty else { return nil }
        self.size = safeSize
        self.data = data
    }

    func generateLUTData() -> NSData {
        var cubeData = [Float](repeating: 0, count: size * size * size * 4)

        var index = 0
        for _ in 0 ..< size { // blue
            for _ in 0 ..< size { // green
                for _ in 0 ..< size { // red
                    cubeData[index * 4 + 0] = Float(data[index].r)
                    cubeData[index * 4 + 1] = Float(data[index].g)
                    cubeData[index * 4 + 2] = Float(data[index].b)
                    cubeData[index * 4 + 3] = Float(data[index].a)
                    index += 1
                }
            }
        }
        let colorCubeData = cubeData.withUnsafeBufferPointer { Data(buffer: $0) }

        return colorCubeData as NSData
    }
}

