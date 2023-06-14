//
//  CanvasHistory.swift
//  
//
//  Created by Vladislav Gushin on 14.06.2023.
//

import Foundation

final class CanvasHistory {
    private(set) var history: Stack<LayersMemento>
    
    init(limit: Int) {
        history = .init(limit: limit)
    }
    
    var isEmpty: Bool {
        history.isEmpty
    }
    
    func peek() -> LayersMemento? {
        history.peek()
    }
    
    func pop() -> LayersMemento? {
        history.pop()
    }
    
    func push(_ element: LayersMemento) {
        history.push(element)
    }
}

final class LayersMemento: Equatable {
    let layers: [CanvasItemModel]
  
    init(layers: [CanvasItemModel]) {
        self.layers = layers
    }
    
    static func == (lhs: LayersMemento, rhs: LayersMemento) -> Bool {
        let layers1 = lhs.layers.map { $0.id }
        let layers2 = rhs.layers.map { $0.id }
        return layers1 == layers2
    }
}

struct Stack<T: Equatable> {
    private var items: [T] = []
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    var isEmpty: Bool { items.isEmpty }
    
    func peek() -> T? {
        guard let topElement = items.first else { return nil }
        return topElement
    }
    
    mutating func pop() -> T? {
        guard !items.isEmpty else { return nil }
        return items.removeFirst()
    }
    
    mutating func push(_ element: T) {
        let hasElement = items.first { $0 == element }
        if hasElement != nil { return }
        
        items.insert(element, at: 0)
        
        guard items.count > limit else { return }
        
        while !items.isEmpty && items.count > limit {
            items.removeLast()
        }
    }
}
