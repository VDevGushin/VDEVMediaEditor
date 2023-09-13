//
//  MergeLayersService.swift
//  
//
//  Created by Vladislav Gushin on 08.09.2023.
//

import Combine
import Foundation
import UIKit
import SwiftUI

final class MergeLayersService: ObservableObject {
    @Injected private var removeLayersService: RemoveLayersService
    
    @Published private(set) var state: State = .idle
    
    private let builder: LayersMerger = .init()
    private var storage = Cancellables()
    
    private weak var tools: CanvasToolsViewModel?
    private weak var data: CanvasLayersDataViewModel?
    
    private var layersForDelete: [CanvasItemModel]? = nil
    
    func setup(
        tools: CanvasToolsViewModel,
        data: CanvasLayersDataViewModel
    ) {
        self.tools = tools
        self.data = data
        
        builder.$state
            .sink(
                on: .main,
                object: self
            ) { wSelf, value in
                switch value {
                case .idle, .error, .successVideo:
                    wSelf.state = .idle
                case .inProgress:
                    wSelf.state = .inProgress
                case let .successImage(image):
                    wSelf.proccess(result: image)
                }
            }
            .store(in: &storage)
    }
    
    private func proccess(result: CanvasImageModel) {
        guard let tools,
              let data,
              result.type == .image else {
            return state = .idle
        }
        
        if let layersForDelete = layersForDelete {
            data.add(result)
            layersForDelete.forEach {
                data.delete($0, withSave: false)
            }
            tools.showAddItemSelector(false)
            tools.openLayersList(false)
            tools.seletedTool(.concreteItem(result))
        } else {
            tools.showAddItemSelector(false)
            tools.seletedTool(.empty)
            data.removeAll(withSave: false)
            removeLayersService.notNeedToRemoveAllLayers()
            data.add(result, withSave: false)
            tools.openLayersList(true)
        }
        
        layersForDelete = nil
        state = .idle
    }
    
    func merge(size: CGSize) {
        guard let data else { return }
        layersForDelete = nil
        builder.merge(layers: data.layers.elements, on: size)
    }
    
    func merge(
        layers: [CanvasItemModel],
        size: CGSize
    ) {
        let allCanMerge = layers.allSatisfy { $0.canMerge }
        guard allCanMerge else { return }
        layersForDelete = layers
        builder.merge(layers: layers, on: size)
    }
}

extension MergeLayersService {
    enum State {
        case idle
        case inProgress
    }
}
