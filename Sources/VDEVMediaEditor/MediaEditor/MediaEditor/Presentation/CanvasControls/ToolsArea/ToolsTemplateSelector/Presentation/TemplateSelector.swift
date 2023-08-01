//
//  TemplateSelector.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 16.02.2023.
//

import SwiftUI

struct TemplateSelector<DS>: View where DS: SectionedDataSource,
                                        DS.ItemModel == TemplatePack,
                                        DS: ObservableObject {
    @ObservedObject var dataSource: DS
    @Binding var selectedTemplatePack: TemplatePack?
    let selectedVariant: (packId: String, variantId: String)?
    let templateSelected: (TemplatePack, Int) -> ()

    var body: some View {
        Group {
            if dataSource.isLoading {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        LoadingView(inProgress: true, color: AppColors.white.uiColor)
                            .frame(width: 120, height: 210)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal)
                    }
                }
            } else {
                if let selectedTemplatePack = selectedTemplatePack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            templatePackVariants(selectedTemplatePack)
                                .transition(.opacityTransition())
                        }
                        .padding(.horizontal)
                    }
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            templatePacks
                                .transition(.opacityTransition())
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await dataSource.load()
            }
        }
    }

    private var templatePacks: some View {
        ForEach(0..<dataSource.sections.count, id: \.self) { sectionIdx in

            ForEach(0..<dataSource.sections[sectionIdx].items.count, id: \.self) { templatePackIdx in
                if let templatePack = dataSource.sections[sectionIdx].items[templatePackIdx] {
                    image(url: templatePack.coverUrl)
                        .frame(width: 120, height: 210)
                        .overlay(
                            LinearGradient(
                                colors: [AppColors.clear, AppColors.black],
                                startPoint: UnitPoint(x: 0.5, y: 0.5),
                                endPoint: UnitPoint(x: 0.5, y: 2)
                            )
                            .overlay(
                                VStack(alignment: .leading) {
                                    Text(templatePack.name)
                                        .font(AppFonts.gramatika(size: 14))

                                    Text(" \(templatePack.variants.count) \(DI.resolve(VDEVMediaEditorStrings.self).templates)")
                                        .font(AppFonts.gramatika(size: 9))
                                        .opacity(0.6)
                                }
                                    .foregroundColor(AppColors.white)
                                    .padding(),
                                alignment: .bottomLeading
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .onTapGesture {
                            haptics(.light)
                            selectedTemplatePack = templatePack
                        }
                }
            }
        }
    }

    private func templatePackVariants(_ templatePack: TemplatePack) -> some View {
        ForEach(0..<templatePack.variants.count, id: \.self) { variantIdx in
            let variant = templatePack.variants[variantIdx]
            image(url: variant.cover)
                .frame(width: 120, height: 210)
                .overlay(
                    ZStack {
                        if templatePack.id == selectedVariant?.packId,
                           variant.id == selectedVariant?.variantId {
                            LinearGradient(
                                colors: [.clear, AppColors.yellow.opacity(0.3)],
                                startPoint: UnitPoint(x: 0.5, y: 0.5),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                            .overlay(
                                Text(DI.resolve(VDEVMediaEditorStrings.self).applied)
                                    .font(AppFonts.gramatika(size: 20))
                                    .foregroundColor(AppColors.white)
                                    .padding(),
                                alignment: .bottom
                            )
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .onTapGesture {
                    haptics(.light)
                    templateSelected(templatePack, variantIdx)
                }
        }
    }

    @ViewBuilder
    private func image(url: URL?) -> some View {
        if let url = url {
            AsyncImageView(url: url) { img in
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                AppColors.gray
            }
        } else {
            AppColors.gray
        }
    }
}

struct TemplateSelector_Previews: PreviewProvider {
    class DummyTempaltesLoader: SectionedDataSource, ObservableObject {
        @Published var sections: [Section<TemplatePack>] = []
        var isLoading: Bool = false

        func text(for indexPath: IndexPath) -> String? { nil }
        func selection(for indexPath: IndexPath) -> Bool { false }
        @MainActor func load() async {
            sections = [
                Section<TemplatePack>(items: [
                    TemplatePack(id: "demo", name: "some", cover: URL(string: "https://www.fillmurray.com/120/210"), isAttached: false, variants: [
                        .init(items: [], id: UUID().uuidString, cover: nil)
                    ]),
                    TemplatePack(id: "demo", name: "some", cover: URL(string: "https://www.fillmurray.com/120/210"), isAttached: false, variants: [
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil)
                    ]),
                    TemplatePack(id: "demo", name: "some", cover: URL(string: "https://www.fillmurray.com/120/210"), isAttached: false, variants: [
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil)
                    ]),
                    TemplatePack(id: "demo", name: "some", cover: URL(string: "https://www.fillmurray.com/120/210"), isAttached: false, variants: [
                        .init(items: [], id: UUID().uuidString, cover: nil)
                    ]),
                    TemplatePack(id: "demo", name: "some", cover: URL(string: "https://www.fillmurray.com/120/210"), isAttached: false, variants: [
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil)
                    ]),
                    TemplatePack(id: "demo", name: "some", cover: URL(string: "https://www.fillmurray.com/120/210"), isAttached: false, variants: [
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil),
                        .init(items: [], id: UUID().uuidString, cover: nil)
                    ])
                ])
            ]
        }
    }

    struct Preview: View {
        @State var templatePackForPreivew: TemplatePack?
        @State var variantIdxForPreivew: Int?
        @State var selectedVariant: (packId: String, variantId: String)?
        @State var someText: String = ""

        var body: some View {
            HStack {
                TemplateSelector(
                    dataSource: DummyTempaltesLoader(),
                    selectedTemplatePack: $templatePackForPreivew,
                    selectedVariant: selectedVariant
                ) { templatePack, templateIndex in
                    selectedVariant = (templatePack.id, templatePack.variants[templateIndex].id)
                    someText = "\(templatePack.name) \(templateIndex)"
                }

                Text(someText)
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}

