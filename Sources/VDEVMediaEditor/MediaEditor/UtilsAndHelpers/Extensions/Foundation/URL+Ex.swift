//
//  URL+uploadCare.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import UIKit

public struct UploadCareWrapper {
    let url: URL

    func resized(size: (width: CGFloat?, height: CGFloat?), withScreenScaleRespect: Bool = true) -> URL {
        guard size.width != nil || size.height != nil else { return url }
        let scaleFactor: CGFloat = withScreenScaleRespect ? UIScreen.main.scale : 1
        let width = size.width.map { $0 * scaleFactor }
        let height = size.height.map { $0 * scaleFactor }

        let progressiveSuffix = "-/progressive/yes/"
        let suffix = "-/resize/\(width.map { String(Int($0)) } ?? "")x\(height.map { String(Int($0)) } ?? "")/"

        return url.appendingPathExtension(progressiveSuffix).appendingPathComponent(suffix)
    }

    func resized(width: CGFloat, withScreenScaleRespect: Bool = true) -> URL {
        resized(size: (width, nil), withScreenScaleRespect: withScreenScaleRespect)
    }
}

public extension URL {
    var uc: UploadCareWrapper { UploadCareWrapper(url: self) }

    init?(w1d1URLString: String) {
      var cleanPath = w1d1URLString
      if w1d1URLString.starts(with: "file://") { cleanPath.removeFirst(7) }
      if cleanPath.starts(with: "http") ||
          cleanPath.starts(with: "ph") ||
          cleanPath.starts(with: "assets-library") {
        guard let url = URL(string: cleanPath) else { return nil }
        self = url
      } else {
        cleanPath = cleanPath.removingPercentEncoding ?? cleanPath
        self = URL(fileURLWithPath: cleanPath)
      }
    }

    var w1d1exportSafeString: String {
      var exportString = absoluteString
      if exportString.hasPrefix("file://") {
        exportString.removeFirst(7)
      }
      return exportString
    }
}

extension URL {
    init?(string: String?) {
        guard let string = string else { return nil }
        self.init(string: string)
    }
}

extension URL {
    static func getLocal(fileName: String, ofType: String) -> URL? {
        guard let filePath = Bundle.module.path(forResource: fileName, ofType: ofType) else {
            return nil
        }
        return URL(fileURLWithPath: filePath)
    }
}
