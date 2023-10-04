//
//  ColorTool.swift
//  
//
//  Created by Vladislav Gushin on 04.10.2023.
//

import SwiftUI

struct ColorTool: View {
    @Binding private var color: Color
    @State private var closeSize: CGSize = .zero
    private let onClose: () -> Void
    
    private let rowsCount = 10
    private let colsCount = 12
    
    init(
        color: Binding<Color>,
        onClose: @escaping () -> Void
    ) {
        self._color = color
        self.onClose = onClose
    }
    
    var body: some View {
        let closeStr = DI.resolve(VDEVMediaEditorStrings.self).close
        VStack(spacing: 0) {
            ForEach(0..<rowsCount, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<colsCount, id: \.self) { col in
                        let currentColor = color(forRow: row, col: col)
                        Button {
                            haptics(.light)
                            color = currentColor
                        } label: {
                            Rectangle()
                                .fill(currentColor)
                                .overlay(
                                    Rectangle()
                                        .strokeBorder(AppColors.white, lineWidth: 3)
                                        .isVisible(currentColor.uiColor == color.uiColor)
                                )
                                .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(alignment: .topTrailing) {
            Button {
                haptics(.light)
                onClose()
            } label: {
                Text(closeStr)
                    .font(AppFonts.gramatika(size: 16))
            }
            .buttonStyle(BlurButtonStyle())
            .fetchSize($closeSize)
            .offset(y: -(closeSize.height + 6))
        }
    }
    
    func color(
        forRow row: Int,
        col: Int
    ) -> Color {
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
