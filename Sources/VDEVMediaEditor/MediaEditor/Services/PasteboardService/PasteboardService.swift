//
//  PasteboardService.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.04.2023.
//

import UIKit

extension PasteboardService {
    enum Result {
        case image(UIImage)
        case text(String)
        case url(URL)
        case empty
    }
}

final class PasteboardService {
    private let pasteboard = UIPasteboard.general
    
    var canPaste: Bool {
        pasteboard.hasImages || pasteboard.hasStrings || pasteboard.hasURLs
    }
    
    var canPasteImage: Bool {
        pasteboard.hasImages
    }
        
    func tryPaste(canPasteOnlyImages: Bool) -> PasteboardService.Result {
        guard canPaste else { return .empty }
        
        let images: [PasteboardService.Result] = pasteboard
            .images?.map { .image($0) } ?? []
        
        var texts: [PasteboardService.Result] = []
        var urls: [PasteboardService.Result] = []
        
        if !canPasteOnlyImages {
            texts = pasteboard
                .strings?
                .map {
                    .text($0)
                } ?? []
            urls = pasteboard
                .urls?
                .map {
                    url in .url(url)
                } ?? []
        }
        
        let result = (images + texts + urls).first
        
        guard let result else {
            return .empty
        }
        
        return result
    }
    
    func clear() {
        pasteboard.items = []
    }
}
