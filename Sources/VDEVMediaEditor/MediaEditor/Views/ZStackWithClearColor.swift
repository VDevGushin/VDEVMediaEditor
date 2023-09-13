//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 19.08.2023.
//

import SwiftUI

struct ZClear<Content: View>: View {
    private let content: Content
    
    init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            AppColors.clear
            content
        }
    }
}
