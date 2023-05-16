//
//  FullSizeTextView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 17.02.2023.
//

import SwiftUI

struct FullSizeTextView2: View {
    @Binding var text: String
    let fontSize: CGFloat
    let textColor: UIColor
    let textAlignment: NSTextAlignment
    let textStyle: CanvasTextStyle
    let needTextBG: Bool
    let backgroundColor: UIColor
    let rect: CGSize
    @Binding var isEditing: Bool

    var body: some View {
        TextView(
            text: $text,
            isEditing: $isEditing,
            fontSize: fontSize,
            textColor: textColor,
            textAlignment: textAlignment,
            textStyle: textStyle,
            needTextBG: needTextBG,
            backgroundColor: backgroundColor)
        .frame(rect)
    }
}


struct FullSizeTextView: View {
    @State private var height: CGFloat = 0

    @Binding var text: String
    let fontSize: CGFloat
    let textColor: UIColor
    let textAlignment: NSTextAlignment
    let textStyle: CanvasTextStyle
    let needTextBG: Bool
    let backgroundColor: UIColor
    @Binding var isEditing: Bool

    var body: some View {
        TextView(
            text: $text,
            isEditing: $isEditing,
            fontSize: fontSize,
            textColor: textColor,
            textAlignment: textAlignment,
            textStyle: textStyle,
            needTextBG: needTextBG,
            backgroundColor: backgroundColor, onFrameSize:  { contentSize in
                height = contentSize.height
            })
        .frame(height: height)
    }
}
