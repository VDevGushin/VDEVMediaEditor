//
//  AnimatedGradientView.swift
//  
//
//  Created by Vladislav Gushin on 05.05.2023.
//

import SwiftUI

struct AnimatedGradientView: View {
    @State private var start = UnitPoint.bottom
    @State private var end = UnitPoint.top
    private let color: Color
    private var duration: Double
    private var colors: [Color] { [color, .clear] }
    
    init(
        color: Color,
        duration: Double = 2
    ) {
        self.color = color
        self.duration = duration
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: start,
            endPoint: end
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .onAppear {
            withAnimation(.easeInOut(duration: duration)
                .repeatForever(autoreverses: true)) {
                    start = nextPointFrom(self.start)
                    end = nextPointFrom(self.end)
                }
        }
        .blur(radius: 5)
    }
    
    /// cycle to the next point
    func nextPointFrom(_ currentPoint: UnitPoint) -> UnitPoint {
        switch currentPoint {
        case .top:
            return .topTrailing
        case .topTrailing:
            return .trailing
        case .trailing:
            return .bottomTrailing
        case .bottomTrailing:
            return .bottom
        case .bottom:
            return .bottomLeading
        case .bottomLeading:
            return .leading
        case .leading:
            return .topLeading
        case .topLeading:
            return .top
        default:
            return currentPoint
        }
    }
}

struct AnimatedGradientViewVertical: View {
    @State private var start = UnitPoint.bottom
    @State private var end = UnitPoint.top
    private let color: Color
    private var duration: Double
    private var blur: CGFloat
    private var colors: [Color] { [color, .clear] }
    
    init(
        color: Color,
        duration: Double = 2,
        blur: CGFloat = 50
    ) {
        self.color = color
        self.duration = duration
        self.blur = blur
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: start,
            endPoint: end
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .onAppear {
            withAnimation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true)
            ) {
                end = nextPointFrom(self.end)
            }
        }
        .padding(.bottom)
        .blur(radius: blur)
        .opacity(0.5)
    }
    
    /// cycle to the next point
    func nextPointFrom(_ currentPoint: UnitPoint) -> UnitPoint {
        switch currentPoint {
        case .top: return .center
        case .center: return .top
        default: return currentPoint
        }
    }
}

struct AnimatedGradientViewVerticalInvert: View {
    @State private var start = UnitPoint.top
    @State private var end = UnitPoint.center
    private let color: Color
    private let blur: CGFloat
    private var duration: Double
    private var colors: [Color] { [color, .clear] }
    
    init(
        color: Color,
        duration: Double = 2,
        blur: CGFloat = 50
    ) {
        self.color = color
        self.duration = duration
        self.blur = blur
    }
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: start,
            endPoint: end
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .onAppear {
            withAnimation(
                .easeInOut(duration: duration)
                .repeatForever(autoreverses: true)
            ) {
                end = nextPointFrom(self.end)
            }
        }
        .padding(.bottom)
        .blur(radius: blur)
        .opacity(0.5)
    }
    
    /// cycle to the next point
    func nextPointFrom(_ currentPoint: UnitPoint) -> UnitPoint {
        switch currentPoint {
        case .center: return .bottom
        case .bottom: return .center
        default: return currentPoint
        }
    }
}

