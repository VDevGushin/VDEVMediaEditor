//
//  ColorFilterTool.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.02.2023.
//

import SwiftUI


final class ColorFilterToolLoader {
    @Injected private var sourceService: VDEVMediaEditorSourceService
    
    @MainActor
    @Binding private var items: [EditorFilter]

    private let challengeId: String

    init(challengeId: String, items: Binding<[EditorFilter]>) {
        self._items = items
        self.challengeId = challengeId
    }

    func load() async throws {
        let editorFilters = try await sourceService.filters(forChallenge: challengeId)
        await MainActor.run {
            items = editorFilters
        }
    }
}

struct ColorFilterTool: View {
    @State private var items: [EditorFilter] = []
    @State private var update = false

    @State private var loader: ColorFilterToolLoader!

    private var layerModel: CanvasItemModel
    private let challengeId: String

    init(layerModel: CanvasItemModel, challengeId: String) {
        self.layerModel = layerModel
        self.challengeId = challengeId
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Cell(imageURL: nil, text: "None", selected: layerModel.colorFilter == nil) {
                    layerModel.apply(colorFilter: nil)
                    update.toggle()
                }

                ForEach(0..<items.count, id: \.self) { idx in
                    let item = items[idx]
                    Cell(imageURL: item.cover,
                         text: item.name,
                         selected: layerModel.colorFilter == item) {
                        layerModel.apply(colorFilter: item)
                        update.toggle()
                    }
                }
            }
            .id(update)
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                loader = ColorFilterToolLoader(challengeId: challengeId, items: $items)
                try await loader.load()
            }
        }
    }

    struct Cell: View {
        let imageURL: URL?
        let text: String
        let selected: Bool
        let action: () -> ()

        private let width: CGFloat = 90
        private let ratio: CGFloat = 16/9

        var body: some View {
            Button {
                haptics(.light)
                action()
            } label: {
                ZStack(alignment: .bottomLeading) {
                    Group {
                        if let url = imageURL?.uc.resized(width: width) {
                            AsyncImageView(url: url) {
                                Image(uiImage: $0)
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                LoadingView(inProgress: true, style: .medium)
                            }
                        } else {
                            AppColors.black
                        }
                    }
                    .frame(width: width, height: width * ratio)

                    Text(text)
                        .font(.mabry(size: 13))
                        .foregroundColor(AppColors.white)
                        .padding(8)
                }
                .cornerRadius(8)
            }
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
