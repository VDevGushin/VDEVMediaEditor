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
    
    init(item: CanvasTextForTemplateItemModel,
         delegate: CanvasEditorDelegate? = nil) {
        self.item = item
        self.text = item.text
        self.delegate = delegate
    }
    
    deinit {
        Log.d("❌ Deinit[TEMPLATE]: TextForTemplateViewModel")
    }
    
    func editText() {
        delegate?.endWorkWithItem?()
        delegate?.editText = {
            [weak self] newModel in
            guard let self = self else { return }
            self.text = newModel
            self.item.text = self.text
        }
        delegate?.showTextEditor(item: item.text)
    }
    
    func updateSize(_ size: CGSize) {
        self.text.update(frameFetchedSize: size)
        self.item.update(frameFetchedSize: size)
    }
}


