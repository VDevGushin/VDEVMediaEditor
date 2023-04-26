//
//  TextForTemplateViewModel.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 17.03.2023.
//

import Foundation
import Combine

final class TextForTemplateViewModel: ObservableObject {
    private(set) var item: CanvasTextForTemplateItemModel
    
    @Published var text: CanvasTextModel
    
    weak var delegate: CanvasEditorDelegate?
    
    init(item: CanvasTextForTemplateItemModel, delegate: CanvasEditorDelegate? = nil) {
        self.item = item
        self.text = item.text
        self.delegate = delegate
    }
    
    func editText() {
        delegate?.endWorkWithItem?()
        
        delegate?.editText = {
            [weak self] newModel in
            self?.item.text = newModel
            self?.text = newModel
        }
        
        delegate?.showTextEditor(item: item.text)
    }
}


