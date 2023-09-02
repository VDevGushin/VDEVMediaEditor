//
//  ToolAdjustmentsDetail.swift
//  
//
//  Created by Vladislav Gushin on 02.09.2023.
//

import SwiftUI

struct ToolAdjustmentsDetail: View {
    private weak var memento: MementoObject? // For save state
    private let item: CanvasItemModel
    @Binding private var state: ToolsEditState
    @Binding private var titleState: ToolsTitleState
    
    init(
        _ item: CanvasItemModel,
        state: Binding<ToolsEditState>,
        titleState: Binding<ToolsTitleState>,
        memento: MementoObject? = nil
    ) {
        self.item = item
        self._state = state
        self._titleState = titleState
        self.memento = memento
    }
    
    @StateObject private var vm: ToolAdjustmentsDetailVM = .init()
    var body: some View {
        ZStack {
            let opacity: CGFloat = vm.state.showMenu ? 1.0 : 0.0
            
            HorizontalMenuView { type in
                vm.state = .detail(type)
            }
            .opacity(opacity)
            
            switch vm.state {
            case let .detail(adjType):
                HorizontalDetail(adjType)
                    .transition(.opacityTransition(speed: 0.1))
            case .first:
                EmptyView()
            }
        }
        .onChange(of: vm.state) { value in
            switch value {
            case .detail: titleState = .noTitle
            case .first: titleState = .title
            }
        }
    }
    
    @ViewBuilder
    private func HorizontalDetail(
        _ aType: ToolAdjustmentsDetailVM.AdjustmentItemType
    ) -> some View {
        switch aType {
        case let .highlight(title, _):
            HighlightAdjustments(
                title,
                item: item,
                memento: memento,
                state: $state
            ) {
                vm.state = .first
            }
        case let .sharpness(title: title, image: _):
            SharpenAdjustments(
                title,
                item: item,
                memento: memento,
                state: $state
            ) {
                vm.state = .first
            }
        case let .shadow(title, _):
            ShadowAdjustments(
                title,
                item: item,
                memento: memento,
                state: $state
            ) {
                vm.state = .first
            }
        case let .saturation(title, _):
            SaturationAdjustments(
                title,
                item: item,
                memento: memento,
                state: $state
            ) {
                vm.state = .first
            }
        case let .contrast(title, _):
            ContrastAdjustments(
                title,
                item: item,
                memento: memento,
                state: $state
            ) {
                vm.state = .first
            }
        case let .blurRadius(title, _):
            BlurAdjustments(
                title,
                item: item,
                memento: memento,
                state: $state
            ) {
                vm.state = .first
            }
        case let .temperature(title, _):
            TemperatureAdjustments(
                title,
                item: item,
                memento: memento,
                state: $state
            ) {
                vm.state = .first
            }
        case let .brightness(title, _):
            BrightnessAdjustments(
                title,
                item: item,
                memento: memento,
                state: $state
            ) {
                vm.state = .first
            }
        case let .alpha(title, _):
            AlphaAdjustments(
                title,
                item: item,
                memento: memento,
                state: $state
            ) {
                vm.state = .first
            }
        }
    }
    
    @ViewBuilder
    private func HorizontalMenuView(
        _ action: @escaping (ToolAdjustmentsDetailVM.AdjustmentItemType) -> Void
    ) -> some View {
        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {
            HStack {
                ForEach(0..<vm.allAdjustmentTools.count, id: \.self) { idx in
                    let item = vm.allAdjustmentTools[idx]
                    let width: CGFloat = 100
                    let ratio: CGFloat = 1/1
                    Button {
                        haptics(.light)
                        action(item)
                    } label: {
                        VStack(
                            alignment: .center,
                            spacing: 12
                        ) {
                            Image(uiImage: item.image)
                                .resizable()
                                .scaledToFit()
                                .width(width / 3)
                            
                            Text(item.title.trimmingCharacters(in: .whitespacesAndNewlines))
                                .font(AppFonts.mabry(size: 13))
                                .foregroundColor(AppColors.white)
                                .padding(8)
                        }
                        .frame(
                            width: width,
                            height: width * ratio
                        )
                        .background {
                            AnimatedGradientViewVertical(color: AppColors.white)
                        }
                        .cornerRadius(12)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
}
