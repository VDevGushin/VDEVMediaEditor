//
//  ToolColorView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 03.02.2023.
//

import SwiftUI

struct ToolColorView: View {
    @Binding var color: Color

    private let rowsCount = 10
    private let colsCount = 12

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<rowsCount, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<colsCount, id: \.self) { col in
                        let curColor = color(forRow: row, col: col)
                        Button {
                            makeHaptics()
                            withAnimation(.easeInOut(duration: 0.2)) { color = curColor }
                        } label: {
                            Rectangle()
                                .fill(curColor)
                                .overlay(
                                    Rectangle()
                                        .strokeBorder(AppColors.white, lineWidth: 3)
                                        .isVisible(curColor.uiColor == color.uiColor)
                                )
                                .aspectRatio(1, contentMode: .fill)
                        }
                    }
                }
            }
        }
    }

    func color(forRow row: Int, col: Int) -> Color {
        let colMult = 1 / Double(colsCount - 1)
        if row < 1 {
            return Color(
                hue: 1,
                saturation: 0,
                brightness: 1 - colMult * Double(col)
            )
        } else {
            let hueStep = (360 / Double(colsCount)) / 360
            let saturation = 0.8
            let baseSaturation = 0.1

            return Color(
                hue: (hueStep * Double(col)),
                saturation: saturation,
                lightness: baseSaturation + (colMult * Double(row))
            )
        }
    }
}
