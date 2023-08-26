//
//  NeuralFilterTool.swift
//  
//
//  Created by Vladislav Gushin on 22.08.2023.
//

import SwiftUI

private final class NeuralFilterToolLoader {
    @Injected private var sourceService: VDEVMediaEditorSourceService
    @MainActor @Binding private var items: [NeuralEditorFilter]

    private let challengeId: String

    init(challengeId: String,
         items: Binding<[NeuralEditorFilter]>) {
        self._items = items
        self.challengeId = challengeId
    }

    func load() async throws {
        let filters = try await sourceService.neuralFilters(forChallenge: challengeId)
        await MainActor.run { items = filters }
    }
}

struct NeuralFilterTool: View {
    @Injected private var strings: VDEVMediaEditorStrings
    @State private var items: [NeuralEditorFilter] = []
    @State private var update = false
    @State private var loader: NeuralFilterToolLoader!
    private weak var memento: MementoObject? // for save state
    private let action: () -> ()
    private var layerModel: CanvasItemModel
    private let challengeId: String

    init(layerModel: CanvasItemModel,
         challengeId: String,
         memento: MementoObject? = nil,
         action: @escaping () -> Void) {
        self.layerModel = layerModel
        self.challengeId = challengeId
        self.memento = memento
        self.action = action
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Cell(
                    imageURL: nil,
                    text: strings.none,
                    selected: layerModel.neuralFilter == nil
                ) {
                    layerModel.apply(neuralFilter: nil)
                    update.toggle()
                    action()
                }
                
                OrView(items.isEmpty) {
                    LoadingCell { refresh() }
                    .transition(.opacityTransition(withAnimation: false, speed: 0.2))
                } secondView: {
                    ForEach(0..<items.count, id: \.self) { idx in
                        let item = items[idx]
                        Cell(
                            imageURL: item.cover,
                            text: item.name.trimmingCharacters(in: .whitespacesAndNewlines),
                            selected: layerModel.neuralFilter == item
                        ) {
                            memento?.forceSave()
                            layerModel.apply(neuralFilter: item)
                            update.toggle()
                            action()
                        }
                    }
                    .transition(.opacityTransition(withAnimation: false, speed: 0.2))
                }
            }
            .id(update)
            .padding(.horizontal)
        }
        .onAppear {
           refresh()
        }
    }
    
    private func refresh() {
        Task {
            loader = NeuralFilterToolLoader(challengeId: challengeId, items: $items)
            try await loader.load()
        }
    }
    
    struct LoadingCell: View {
        let action: () -> ()
        private let width: CGFloat = 120
        private let ratio: CGFloat = 3/2
        
        var body: some View {
            Button {
                haptics(.light)
                action()
            } label: {
                VStack(alignment: .center) {
                    ActivityIndicator(
                        isAnimating: true,
                        style: .large,
                        color: .init(AppColors.white)
                    )
                }
                .frame(width: width, height: width * ratio)
                .background {
                    AppColors.blackInvisible
                }
                .cornerRadius(8)
            }
            .buttonStyle(ScaleButtonStyle())
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(AppColors.white, lineWidth: 3)
                }
            )
            .background {
                AnimatedGradientViewVertical(
                    color: AppColors.whiteWithOpacity2,
                    duration: 3
                )
            }
        }
    }

    struct Cell: View {
        let imageURL: URL?
        let text: String
        let selected: Bool
        let action: () -> ()

        private let width: CGFloat = 120
        private let ratio: CGFloat = 3/2

        var body: some View {
            Button {
                haptics(.light)
                action()
            } label: {
                VStack(alignment: .leading) {
                    Spacer()
                    Text(text)
                        .font(AppFonts.mabry(size: 13))
                        .foregroundColor(AppColors.white)
                        .padding(8)
                }
                .frame(width: width, height: width * ratio)
                .background {
                    OrViewWithObject(imageURL) { url in
                            AsyncImageView(url: url) {
                                Image(uiImage: $0)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                LoadingView(inProgress: true)
                            }
                        } secondView: {
                            AppColors.black
                        }
                }
                .cornerRadius(8)
            }
            .buttonStyle(ScaleButtonStyle())
            .disabled(selected)
            .overlay(
                ZStack {
                    if selected {
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(AppColors.white, lineWidth: 3)
                    }
                }
            )
        }
    }
}
