//
//  AnimatedGradientView.swift
//  
//
//  Created by Vladislav Gushin on 05.05.2023.
//

import SwiftUI

struct AnimatedGradientView: View {
    private let color: Color
    @State private var start = UnitPoint.bottom
    @State private var end = UnitPoint.top

    private var colors: [Color] {
        [color, .clear]
    }
    
    init(color: Color) {
        self.color = color
    }

    var body: some View {
        LinearGradient(gradient: Gradient(colors: colors), startPoint: start, endPoint: end)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                withAnimation(.easeInOut(duration:3).repeatForever(autoreverses:true)) {
                    start = nextPointFrom(self.start)
                    end = nextPointFrom(self.end)
                }
            }
    }
    
    /// cycle to the next point
    func nextPointFrom(_ currentPoint: UnitPoint) -> UnitPoint {
        switch currentPoint {
        case .top:
            return .topLeading
        case .topLeading:
            return .leading
        case .leading:
            return .bottomLeading
        case .bottomLeading:
            return .bottom
        case .bottom:
            return .bottomTrailing
        case .bottomTrailing:
            return .trailing
        case .trailing:
            return .topTrailing
        case .topTrailing:
            return .top
        default:
            print("Unknown point")
            return .top
        }
    }
}
