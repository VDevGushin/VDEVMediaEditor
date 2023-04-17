//
//  ShareSheet.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 27.02.2023.
//

import UIKit
import SwiftUI

struct ShareSheetView: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?,
                          _ completed: Bool, _ returnedItems: [Any]?,
                          _ error: Error?) -> Void
    
    private(set) var activityItems: [Any]
    private(set) var applicationActivities: [UIActivity]? = nil
    private(set) var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    private(set) var callback: Callback? = nil
    
    init(activityItems: [Any],
         applicationActivities: [UIActivity]? = nil,
         excludedActivityTypes: [UIActivity.ActivityType]? = nil,
         callback: Callback? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.excludedActivityTypes = excludedActivityTypes
        self.callback = callback
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
