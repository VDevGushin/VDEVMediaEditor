//
//  DeviceOrientationService.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 12.04.2023.
//

import Combine
import Foundation
import UIKit

final class DeviceOrientationService: ObservableObject {
    @Published var isFaceDown: Bool = false
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(orientationChanged),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    }
    
    @objc func orientationChanged() {
        isFaceDown = UIDevice.current.orientation == .faceDown
    }
}
