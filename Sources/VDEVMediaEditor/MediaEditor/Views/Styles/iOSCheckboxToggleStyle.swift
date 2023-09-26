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
            makeHaptics()
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

struct iOSCheckboxToggleStyleInvert: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            makeHaptics()
            configuration.isOn.toggle()
        }, label: {
            ZStack(alignment: .trailing) {
                AppColors.blackInvisible
                    .frame(height: 32)
                HStack {
                    configuration.label
                    Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                }
            }
        })
    }
}
