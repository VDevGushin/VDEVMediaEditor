//
//  ReorderableForEach.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 15.02.2023.
//

import SwiftUI
import UniformTypeIdentifiers
import IdentifiedCollections

public struct ReorderableForEach<Data: Identifiable, Content>: View
where Data : Hashable, Content : View {
    
    @Binding var data: IdentifiedArrayOf<Data>
    @Binding var allowReordering: Bool
    
    private let content: (Data, Bool) -> Content

    @State private var draggedItem: Data?
    @State private var hasChangedLocation: Bool = false

    public init(_ data: Binding<IdentifiedArrayOf<Data>>,
                allowReordering: Binding<Bool>,
                @ViewBuilder content: @escaping (Data, Bool) -> Content) {
        
        _data = data
        _allowReordering = allowReordering
        
        self.content = content
    }

    public var body: some View {
        ForEach(data.reversed(), id: \.self) { item in
            if allowReordering {
                content(item, hasChangedLocation && draggedItem == item)
                    .onDrag {
                        draggedItem = item
                        return NSItemProvider(object: Model())
                    }
                    .onDrop(of: [UTType.item],
                            delegate:
                                ReorderDropDelegate(
                                    item: item,
                                    data: $data,
                                    draggedItem: $draggedItem,
                                    hasChangedLocation: $hasChangedLocation)
                    )
            } else {
                content(item, false)
            }
        }
    }

    struct ReorderDropDelegate<Data: Identifiable>: DropDelegate where Data : Equatable {
        let item: Data
        @Binding var data: IdentifiedArrayOf<Data>
        @Binding var draggedItem: Data?
        @Binding var hasChangedLocation: Bool

        func dropEntered(info: DropInfo) {
            guard item != draggedItem,
                  let current = draggedItem,
                  let from = data.firstIndex(of: current),
                  let to = data.firstIndex(of: item)
            else {
                return
            }
            hasChangedLocation = true
            if data[to] != current {
                withAnimation(.interactiveSpring()) {
                    data.move(fromOffsets: IndexSet(integer: from),
                              toOffset: (to > from) ? to + 1 : to)
                }
            }
        }

        func dropUpdated(info: DropInfo) -> DropProposal? {
            DropProposal(operation: .move)
        }

        func performDrop(info: DropInfo) -> Bool {
            hasChangedLocation = false
            draggedItem = nil
            return true
        }
    }
}

fileprivate final class Model : NSObject, NSItemProviderWriting {
    static var writableTypeIdentifiersForItemProvider: [String] {
        return []
    }

    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Swift.Void) -> Progress? {
        return nil
    }
}
