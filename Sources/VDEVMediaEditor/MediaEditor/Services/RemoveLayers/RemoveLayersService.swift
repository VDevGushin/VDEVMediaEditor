//
//  DeviceOrientationService.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.04.2023.
//

import Combine
import Foundation
import UIKit

final class RemoveLayersService: ObservableObject {
    @Published var isNeedRemoveAllLayers: Bool = false
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    deinit {
        isNeedRemoveAllLayers = false
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func orientationChanged() {
        let result = UIDevice.current.orientation == .faceDown
        guard isNeedRemoveAllLayers != result else { return }
        isNeedRemoveAllLayers = result
    }
    
    func needToRemoveAllLayers() {
        guard !isNeedRemoveAllLayers else { return }
        isNeedRemoveAllLayers = true
    }
    
    func notNeedToRemoveAllLayers() {
        guard isNeedRemoveAllLayers else { return }
        isNeedRemoveAllLayers = false
    }
}
