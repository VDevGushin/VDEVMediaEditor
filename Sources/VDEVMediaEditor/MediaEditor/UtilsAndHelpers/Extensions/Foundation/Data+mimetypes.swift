//
//  Data+mimetypes.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 10.02.2023.
//

import Foundation

struct Mimetype {
    enum _Type: String {
        case application
        case audio
        case example
        case image
        case message
        case model
        case multipart
        case text
        case video
    }

    enum Subtype: String {
        case gif
        case jpeg
        case png
        case tiff

        case pdf
        case vnd
        case octetStream = "octet-stream"

        case plain
    }

    var type: _Type
    var subtype: Subtype

    init(_ type: _Type, _ subtype: Subtype) {
        self.type = type
        self.subtype = subtype
    }
}

extension Data {
    var mimetype: Mimetype {
        var b: UInt8 = 0
        copyBytes(to: &b, count: 1)

        switch b {
        case 0xFF: return Mimetype(.image, .jpeg)
        case 0x89: return Mimetype(.image, .png)
        case 0x47: return Mimetype(.image, .gif)
        case 0x4D, 0x49: return Mimetype(.image, .tiff)
        case 0x25: return Mimetype(.application, .pdf)
        case 0xD0: return Mimetype(.application, .vnd)
        case 0x46: return Mimetype(.text, .plain)
        default: return Mimetype(.application, .octetStream)
        }
    }
}
