//
//  MementoService.swift
//  
//
//  Created by Vladislav Gushin on 27.06.2023.
//

import SwiftUI

final class MementoService: ObservableObject {
    @Published private(set) var canUndo: Bool = false
    @Injected private var settings: VDEVMediaEditorSettings
    private lazy var historyService = CanvasHistory(limit: settings.historyLimit)
    
    static let shared = MementoService()

    private init() {
        self.canUndo = false
    }
    
    func save(newElement: LayersMemento) {
        historyService.push(newElement)
        canUndo = !historyService.isEmpty
    }
    
    func undo() -> LayersMemento? {
        guard let element = historyService.pop() else { return nil }
        canUndo = !historyService.isEmpty
        return element
    }
}
