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
        
        tools.showAddItemSelector(false)
        tools.seletedTool(.empty)
        
        data.removeAll(withSave: false)
        removeLayersService.notNeedToRemoveAllLayers()
        
        data.add(result, withSave: false)
        tools.openLayersList(true)
        
        state = .idle
    }
    
    func merge(
        layers: [CanvasItemModel],
        size: CGSize
    ) {
        builder
            .merge(
                layers: layers,
                on: size
            )
    }
}

extension MergeLayersService {
    enum State {
        case idle
        case inProgress
    }
}
