//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 09.05.2023.
//

import SwiftUI

struct iOSCheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            ZStack(alignment: .leading) {
                AppColors.blackInvisible
                    .frame(height: 32)
                HStack {
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    configuration.label
                }
            }
        })
    }
}
