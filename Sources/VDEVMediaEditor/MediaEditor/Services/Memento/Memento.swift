//
//  CanvasHistory.swift
//  
//
//  Created by Vladislav Gushin on 14.06.2023.
//

import Foundation

struct CanvasHistory {
    private var history: Stack<LayersMemento>
    
    init(limit: Int) {
        history = .init(limit: limit)
    }
    
    var isEmpty: Bool {
        history.isEmpty
    }
    
    var items: [LayersMemento] {
        history.items
    }
    
    func peek() -> LayersMemento? {
        history.peek()
    }
    
    mutating func pop() -> LayersMemento? {
        history.pop()
    }
    
    mutating func push(_ element: LayersMemento) {
        history.push(element)
    }
}

struct LayersMemento: Equatable {
    private(set) var layers: [CanvasItemModel]
    
    init(layers: [CanvasItemModel]) {
        self.layers = layers.map { $0.copy() }
    }
    
    static func == (lhs: LayersMemento, rhs: LayersMemento) -> Bool {
        var result = false
        outerLoop: for lhsLayer in lhs.layers {
            for rhsLayer in rhs.layers {
                if rhsLayer.id == lhsLayer.id &&
                    rhsLayer.scale == lhsLayer.scale &&
                    rhsLayer.rotation == lhsLayer.rotation &&
                    rhsLayer.offset == lhsLayer.offset &&
                    rhsLayer.type == rhsLayer.type {
                    result = true
                    break outerLoop
                }
            }
        }
        return result
    }
}

fileprivate struct Stack<T: Equatable> {
    private(set) var items: [T] = []
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    var count: Int { items.count }
    var isEmpty: Bool { items.isEmpty }
    
    func peek() -> T? {
        guard let topElement = items.first else { return nil }
        return topElement
    }
    
    mutating func pop() -> T? {
        guard !items.isEmpty else { return nil }
        return items.removeLast()
    }
    
    mutating func removeAll() {
        items.removeAll()
    }
    
    mutating func push(_ element: T) {
        guard !items.contains(element) else { return }
        items.append(element)
        guard items.count > limit else { return }
        while !items.isEmpty && items.count > limit {
            items.removeFirst()
        }
    }
}
