//
//  SectionedDataSource.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import Foundation

struct Section<ItemModel> {
    var name: String?
    var items: [ItemModel?]
}

protocol SectionedDataSource {
    associatedtype ItemModel
    typealias Sect = Section<ItemModel>

    var sections: [Sect] { get }
    var isLoading: Bool { get }

    func load() async
    func text(for indexPath: IndexPath) -> String?
    
    @MainActor func selection(for indexPath: IndexPath) -> Bool
}
