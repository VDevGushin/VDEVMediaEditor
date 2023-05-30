//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 30.05.2023.
//

import UIKit
import SwiftUI
import SwiftUIX

// MARK: - Content hosting view
protocol _UIHostingViewDelegate: AnyObject {
    func touches(inProgress: Bool)
}

final class _UIHostingView<Content: View>: UIHostingView<Content>{
    weak var delegate: _UIHostingViewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.touches(inProgress: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        delegate?.touches(inProgress: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.touches(inProgress: false)
    }
}

// MARK: - Content container hosting view
protocol _UIContainerViewDelegate: AnyObject {
    func touches(inProgress: Bool)
}

final class _UIContainerHostingView<Content: View>: UIHostingView<Content>{
    weak var delegate: _UIContainerViewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.touches(inProgress: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        delegate?.touches(inProgress: false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.touches(inProgress: false)
    }
}
