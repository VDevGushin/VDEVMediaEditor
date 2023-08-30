//
//  ToolWrapper.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 16.02.2023.
//

import SwiftUI

enum ToolsEditState: Equatable {
    case edit(Int)
    case idle
    
    func inEdit(for index: Int) -> Bool {
        switch self {
        case .idle: return false
        case .edit(let i): return i == index
        }
    }
    
    func getOpacity(for index: Int) -> CGFloat {
        switch self {
        case .idle: return 1.0
        case .edit(let i): return i == index ? 1.0 : 0.1
        }
    }
    
    func getOpacity() -> CGFloat {
        switch self {
        case .idle: return 1.0
        case .edit: return 0.05
        }
    }
}

struct ToolWrapperWithBinding<Tool: View>: View {
    let title: String
    let fullScreen: Bool
    let withBackground: Bool
    let returnPressed: () -> ()
    
    @ViewBuilder var tool: (Binding<ToolsEditState>) -> Tool
    
    @State private var editState: ToolsEditState = .idle
    
    init(title: String,
         fullScreen: Bool,
         withBackground: Bool = true,
         returnPressed: @escaping () -> Void,
         @ViewBuilder  tool: @escaping (Binding<ToolsEditState>) -> Tool) {
        self.title = title
        self.fullScreen = fullScreen
        self.withBackground = withBackground
        self.returnPressed = returnPressed
        self.tool = tool
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
                .padding(.horizontal)
                .opacity(editState.getOpacity())
                
                tool($editState)
            }
            .padding(.vertical)
            .transparentBlurBackground(opacity: editState.getOpacity)
            .animation(.interactiveSpring(), value: editState)
        }
    }
}

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
            .transparentBlurBackground()
        }
    }
}
