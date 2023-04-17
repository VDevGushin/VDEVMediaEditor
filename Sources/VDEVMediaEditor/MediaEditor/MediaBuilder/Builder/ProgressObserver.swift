//
//  ProgressObserver.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 25.03.2023.
//

import Foundation
import SwiftUI

final class ProgressObserver {
    @Published private(set) var progress: Int = 0
    @Published private(set) var title: String = "Обработка..."
    private var counter: Double = 0.0
    private var total: Double
    private var factor: Double
    private let messageGetter: ((String) -> Void)?
    
    private var message: String { "\(self.progress)%\n\(title)" }
    
    init(total: Int,
         factor: Double = 1.0,
         messageGetter: ((String) -> Void)? = nil) {
        
        self.total = Double(total)
        self.factor = factor
        self.messageGetter = messageGetter
    }
 
    func setMessage(value: String) {
        self.title = value

        messageGetter?(message)
    }
    
    func addProgress(title: String = "Обработка...") {
        counter += 1
        
        self.title = title
        
        set(progress: Double(100 * counter) / total)
        
        messageGetter?(message)
    }
    
    
    private func set(progress: CGFloat) {
        self.progress = Int(min(100.0, max(0.0 ,progress * factor)))
    }
}
