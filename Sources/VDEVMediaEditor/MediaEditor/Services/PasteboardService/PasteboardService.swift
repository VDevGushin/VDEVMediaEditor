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
    
    enum AllowTypes {
        case image
        case text
    }
}


final class PasteboardService {
    private let pasteboard = UIPasteboard.general
    
    var canPaste: Bool {
        pasteboard.hasImages || pasteboard.hasStrings
    }
        
    func tryPaste(canPasteOnlyImages: Bool) -> PasteboardService.Result {
        let types: [PasteboardService.AllowTypes] = canPasteOnlyImages ? [.image] : [.image, .text]
        return tryPaste(types)
    }

    func tryPaste(_ alowTypes: [AllowTypes] = [.text, .image]) -> PasteboardService.Result {
        guard canPaste else { return .empty }
        
        if alowTypes.contains(.image) {
            if let image = pasteboard.image { return .image(image) }
        }
        
        if alowTypes.contains(.text) {
            if let text = pasteboard.string { return .text(text) }
        }
        
        return .empty
    }
    
    func clear() {
        pasteboard.items = []
    }
}
