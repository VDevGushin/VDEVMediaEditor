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
        case empty
    }
}

final class PasteboardService {
    private let pasteboard = UIPasteboard.general
    
    var canPaste: Bool {
        pasteboard.hasImages || pasteboard.hasStrings
    }
        
    func tryPaste(canPasteOnlyImages: Bool) -> PasteboardService.Result {
        guard canPaste else { return .empty }
        
        let images: [PasteboardService.Result] = pasteboard
            .images?.map { .image($0) } ?? []
        
        var texts: [PasteboardService.Result] = []
        if !canPasteOnlyImages {
            texts = pasteboard.strings?.map { .text($0) } ?? []
        }
        
        let result = (images + texts).first
        
        guard let result else {
            return .empty
        }
        
        return result
    }
    
    func clear() {
        pasteboard.items = []
    }
}
