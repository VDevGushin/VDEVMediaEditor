//
//  ColorFilterTool.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.02.2023.
//

import SwiftUI

private final class ColorFilterToolVM: ObservableObject {
    @Injected private var sourceService: VDEVMediaEditorSourceService
    
    @MainActor
    @Published private(set) var items: [EditorFilter] = []
    
    @Published private(set) var selectedItem: EditorFilter?

    private let challengeId: String

    init(challengeId: String) {
        self.challengeId = challengeId
    }

    func load() async {
        let editorFilters = try? await sourceService.filters(forChallenge: challengeId)
        await MainActor.run {
            items = editorFilters ?? []
        }
    }
    
    func set(selectedItem: EditorFilter?) {
        self.selectedItem = selectedItem
    }
    
    func isSelected(_ selectedItem: EditorFilter?) -> Bool {
        self.selectedItem == selectedItem
    }
}

struct ColorFilterTool: View {
    @Injected private var strings: VDEVMediaEditorStrings
    @StateObject private var vm: ColorFilterToolVM
    private weak var memento: MementoObject? // for save state
    private var layerModel: CanvasItemModel

    init(
        layerModel: CanvasItemModel,
        challengeId: String,
        memento: MementoObject? = nil
    ) {
        self.layerModel = layerModel
        self.memento = memento
        self._vm = .init(wrappedValue: .init(challengeId: challengeId))
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Cell(
                    imageURL: nil,
                    text: strings.none,
                    selected: vm.isSelected(nil)
                ) {
                    vm.set(selectedItem: nil)
                    layerModel.apply(colorFilter: nil)
                }

                ForEach(0..<vm.items.count, id: \.self) { idx in
                    let item = vm.items[idx]
                    Cell(imageURL: item.cover,
                         text: item.name,
                         selected: vm.isSelected(item)) {
                        memento?.forceSave()
                        layerModel.apply(colorFilter: item)
                        vm.set(selectedItem: item)
                    }
                }
            }
            .padding(.horizontal)
        }
        .viewDidLoad {
            Task {
                await vm.load()
                vm.set(selectedItem: layerModel.colorFilter)
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
                ZStack(alignment: .bottomLeading) {
                    Group {
                        OBJECT(imageURL) { url in
                            AsyncImageView(url: url) {
                                Image(uiImage: $0)
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                LoadingView(inProgress: true)
                            }
                        } secondView: {
                            AppColors.black
                        }
                    }
                    .frame(
                        width: width,
                        height: width * ratio
                    )

                    Text(text)
                        .font(AppFonts.mabry(size: 13))
                        .foregroundColor(AppColors.white)
                        .padding(8)
                }
                .cornerRadius(8)
            }
            .disabled(selected)
            .overlay(
                IF(selected) {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(AppColors.whiteWithOpacity1, lineWidth: 2)
                }
            )
        }
    }
}
