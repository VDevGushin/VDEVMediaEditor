//
//  ToolWrapper.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 16.02.2023.
//

import SwiftUI

struct ToolWrapper<Tool: View>: View {
    let title: String
    let fullScreen: Bool
    let withBackground: Bool
    let returnPressed: () -> ()
    @ViewBuilder let tool: Tool
    
    init(title: String,
         fullScreen: Bool,
         withBackground: Bool = true,
         returnPressed: @escaping () -> Void,
         tool: () -> Tool) {
        self.title = title
        self.fullScreen = fullScreen
        self.withBackground = withBackground
        self.returnPressed = returnPressed
        self.tool = tool()
    }

    var body: some View {
        VStack {
            if !fullScreen {
                InvisibleTapZoneView {
                    returnPressed()
                }
            }

            VStack(spacing: 20) {
                HeadWithTitle(title: title,
                              returnPressed: returnPressed)
                    .padding()

                tool
            }
            .padding(.vertical)
            .background(
                BlurView(style: .systemChromeMaterialDark)
                    .clipShape(RoundedCorner(radius: 16, corners: [.topLeft, .topRight]))
                    .edgesIgnoringSafeArea([.bottom, .trailing, .leading])
                    .opacity(withBackground ? 1.0 : 0.5)
            )
        }
    }
}

