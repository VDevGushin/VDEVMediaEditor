//
//  MediaResolution.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 28.02.2023.
//

import UIKit

enum MediaResolution {
    case ultraHD8k
    case ultraHD4k
    case fullHD
    case hd
    case sd

    var resolution: CGSize {
        switch self {
        case .sd: return .init(width: 480, height: 640)
        case .hd: return .init(width: 720, height: 1280)
        case .fullHD: return .init(width: 1080, height: 1920)
        case .ultraHD4k: return .init(width: 2160, height: 3840)
        case .ultraHD8k: return .init(width: 4320, height: 7680)
        }
    }
    
    var title: String {
        switch self {
        case .sd: return "SD"
        case .hd: return "HD"
        case .fullHD: return "FULLHD"
        case .ultraHD4k: return "ULTRAHD4K"
        case .ultraHD8k: return "ULTRAHD8K"
        }
    }
    
    var toString: String {
        switch self {
        case .sd: return "SD -> width: 480, height: 640"
        case .hd: return "HD -> width: 720, height: 1280"
        case .fullHD: return "FULLHD -> width: 1080, height: 1920"
        case .ultraHD4k: return "ULTRAHD4K -> width: 2160, height: 3840"
        case .ultraHD8k: return "ULTRAHD8K -> width: 4320, height: 7680"
        }
    }

    func getScale(for width: CGFloat) -> CGFloat {
        let rWidth = self.resolution.width
        //let resultScale = max(rWidth / width, UIScreen.main.scale)
        let resultScale = rWidth / width
        return resultScale
    }

    public static let `default` = MediaResolution.fullHD
}
