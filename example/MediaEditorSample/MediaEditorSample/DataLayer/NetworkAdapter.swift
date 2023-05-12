//
//  NetworkAdapter.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 15.04.2023.
//

import UIKit
import VDEVMediaEditor

final class NetworkAdapter: VDEVMediaEditorSourceService {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func startMeta(forChallenge baseChallengeId: String) async -> StartMetaConfig? {
        guard let result = try? await client.challengeMeta(for: baseChallengeId) else {
            return nil
        }
        let title = result.titleLocalized
        let subTitle = result.subtitleLocalized
        let isAttachedTemplate = result.appAttachedEditorTemplate != nil
        return .init(isAttachedTemplate: isAttachedTemplate, title: title, subTitle: subTitle)
    }

    func editorTemplates(forChallenge baseChallengeId: String, challengeTitle: String, renderSize: CGSize) async throws -> [TemplatePack] {
        try await client.editorTemplates(forChallenge: baseChallengeId, renderSize: renderSize)
            .asyncMap {
                await TemplatePack(from: $0, challengeTitle: challengeTitle)
            }
    }

    func stickersPack(forChallenge baseChallengeId: String) async throws -> [(String, [StickerItem])] {
        try await client.stickers(forChallenge: baseChallengeId).map { stickerPack -> (String, [StickerItem]) in

            let name = stickerPack.titleLocalized

            let items = stickerPack.stickersFull.compactMap { sticker -> StickerItem? in
                guard let url = sticker.uri.url else { return nil }
                return StickerItem(url: url)
            }

            return (name, items)
        }
    }
}

// MARK: - Masks
extension NetworkAdapter {
    func masks(forChallenge baseChallengeId: String) async throws -> [EditorFilter] {
        return await MockBuilder.masks()
//        do {
//            let result =  try await client.masks(forChallenge: baseChallengeId).compactMap { editorFilter -> EditorFilter? in
//                guard let coverUrl = editorFilter.cover?.url else { return nil }
//                let steps = editorFilter.stepsFull.compactMap { step -> EditorFilter.Step? in
//                    guard let url = step.url?.url,
//                          let stepType = EditorFilter.Step.StepType(value: step.type) else { return nil }
//                    return .init(type: stepType, url: url)
//                }
//                return .init(id: editorFilter.id, name: editorFilter.name, cover: coverUrl, steps: steps)
//            }
//
//            if result.isEmpty { return await MockBuilder.masks() }
//
//            return result
//        } catch {
//            return await MockBuilder.masks()
//        }
    }
}

// MARK: - Textures
extension NetworkAdapter {
    func textures(forChallenge baseChallengeId: String) async throws -> [EditorFilter] {
        return await MockBuilder.textures()
//        do {
//            let result = try await client.textures(forChallenge: baseChallengeId).compactMap { editorFilter -> EditorFilter? in
//                guard let coverUrl = editorFilter.cover?.url else { return nil }
//                let steps = editorFilter.stepsFull.compactMap { step -> EditorFilter.Step? in
//                    guard let url = step.url?.url,
//                          let stepType = EditorFilter.Step.StepType(value: step.type) else { return nil }
//                    return .init(type: stepType, url: url, settings: .init(jsonValue: step.settings.jsonValue))
//                }
//                return .init(id: editorFilter.id, name: editorFilter.name, cover: coverUrl, steps: steps)
//            }
//
//            if result.isEmpty { return await MockBuilder.textures() }
//
//            return result
//        } catch {
//            return await MockBuilder.textures()
//        }
    }
}

// MARK: - Filters
extension NetworkAdapter {
    func filters(forChallenge baseChallengeId: String) async throws -> [EditorFilter] {
        // OLD get from network
        // return try await client.filters(forChallenge: baseChallengeId).compactMap { filter -> EditorFilter? in
        return await MockBuilder.filters()
    }
}

// MARK: - INITS
extension EditorFilter {
    init(from networkFilter: NetworkClient.EditorTemplate.Variant.ClientConfig.Item.Filter) {
        self.init(
            id: networkFilter.id,
            name: networkFilter.name,
            cover: networkFilter.cover?.url,
            steps: networkFilter.stepsFull.compactMap {
                guard let stepType = EditorFilter.Step.StepType(value: $0.type) else { return nil }
                return Step(type: stepType, url: $0.url?.url, settings: .init(jsonValue: $0.settings.jsonValue))
            }
        )
    }
}

extension TemplatePack {
    convenience init(from template: NetworkClient.EditorTemplate, challengeTitle: String) {
        let variants = template.variants.compactMap { variant -> TemplatePack.Variant? in
            return .init(
                items: variant.clientConfig.items.compactMap { item -> TemplatePack.Variant.Item? in
                    guard let x = item.config.x as Double?,
                          let y = item.config.y as Double?,
                          let width = item.config.width as Double?,
                          let height = item.config.height as Double?
                    else { return nil }
                    
                    let textLocalized = item.textLocalized
                        .replacing(placeholders: [kPlaceholders.challengeTitle: challengeTitle])
                    
                    return .init(
                        blendingMode: BlendingMode(rawValue: item.blendMode) ?? .normal,
                        filters: item.filters.map { .init(from: $0) },
                        isLocked: item.type == 0,
                        isMovable: item.isMovable,
                        text: item.type == 0 ? textLocalized : "",
                        placeholderText: textLocalized,
                        url: item.imageUrl?.url,
                        rect: CGRect(
                            x: x,
                            y: y,
                            width: width,
                            height: height
                        ),
                        fontPreset: item.fontPreset.map { preset -> TemplatePack.Variant.Item.FontPreset in
                                .init(
                                    fontSize: CGFloat(preset.fontSize),
                                    textStyle: CanvasTextStyle(
                                        fontFamily: preset.editorFont.postScriptName,
                                        lineHeightMultiple: preset.lineHeight / CGFloat(preset.fontSize),
                                        kern: preset.letterSpacing,
                                        uppercased: preset.hasAllCaps,
                                        shadow: preset.hasShadow ? .default : nil
                                    ),
                                    verticalAlignment: item.verticalAlign ?? 1,
                                    textAlignment: preset.alignment,
                                    color: UIColor(hexString: item.defaultColor ?? "#ffffff")
                                )
                        }
                    )
                },
                id: variant.id,
                cover: URL(string: variant.cover)
            )
        }
        self.init(
            id: template.id,
            name: template.nameLocalized,
            cover: template.cover?.url,
            isAttached: template.isAttached,
            variants: variants
        )
    }
}
