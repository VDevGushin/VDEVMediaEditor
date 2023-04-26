//
//  DoneButtonStyle.swift
//  
//
//  Created by Vladislav Gushin on 26.04.2023.
//

import SwiftUI

struct DoneButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    enum SizeClass {
        case small
        case medium(padding: CGFloat)
        static let medium = SizeClass.medium(padding: 10)
        case big

        var frame: CGSize {
            switch self {
            case .medium: return CGSize(width: 42, height: 42)
            case .big: return CGSize(width: 50, height: 50)
            case .small: return CGSize(width: 85, height: 30)
            }
        }

        var horPadding: CGFloat {
            switch self {
            case .medium(let padding): return padding
            default: return 10
            }
        }

        var maxHeight: CGFloat? {
            switch self {
            case .small: return 30
            default: return nil
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return 15
            default: return 12
            }
        }
    }

    var sizeClass: SizeClass = .medium
    
    var tintColor: Color = .clear

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(isEnabled ? AppColors.white :
                    AppColors.gray)
            .padding(.horizontal, sizeClass.horPadding)
            .frame(
                minWidth: sizeClass.frame.width,
                minHeight: sizeClass.frame.height,
                maxHeight: sizeClass.maxHeight
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
            .background(
                ZStack {
                    tintColor
                        .opacity(0.8)

                    BlurView(style: .systemChromeMaterialDark)
                }
                    .cornerRadius(sizeClass.cornerRadius)
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
