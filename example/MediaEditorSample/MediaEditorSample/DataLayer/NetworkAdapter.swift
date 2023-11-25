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
        let hasAttachedMasks = result.editorMetadata.hasAttachedMasks
        let hasAttachedFilters = result.editorMetadata.hasAttachedFilters
        let hasAttachedTextures = result.editorMetadata.hasAttachedTextures
        let hasAttachedTemplates = result.editorMetadata.hasAttachedTemplates
        let hasAttachedStickerPacks = result.editorMetadata.hasAttachedStickerPacks
        let hasAttachedNeuralFilters = result.editorMetadata.hasAttachedNeuralFilters
        return .init(
            title: title,
            subTitle: subTitle,
            hasAttachedMasks: hasAttachedMasks,
            hasAttachedFilters: hasAttachedFilters,
            hasAttachedTextures: hasAttachedTextures,
            hasAttachedTemplates: hasAttachedTemplates,
            hasAttachedStickerPacks: hasAttachedStickerPacks,
            hasAttachedNeuralFilters: hasAttachedNeuralFilters
        )
    }

    func editorTemplates(forChallenge baseChallengeId: String, challengeTitle: String, renderSize: CGSize) async throws -> [TemplatePack] {
        let myTemplates = await VDEVDataBuilder.templates(canvasSize: renderSize)
        let networkTemplates = try await client.editorTemplates(forChallenge: baseChallengeId, renderSize: renderSize).asyncMap {
            await TemplatePack(from: $0, challengeTitle: challengeTitle)
        }
        
        return myTemplates + networkTemplates
    }
}

// MARK: - Stikers
extension NetworkAdapter {
    func stickersPack(forChallenge baseChallengeId: String) async throws -> [(String, [StickerItem])] {
        await VDEVDataBuilder.stickers()
//        try await client.stickers(forChallenge: baseChallengeId).map { stickerPack -> (String, [StickerItem]) in
//
//            let name = stickerPack.titleLocalized
//
//            let items = stickerPack.stickersFull.compactMap { sticker -> StickerItem? in
//                guard let url = sticker.uri.url else { return nil }
//                return StickerItem(url: url)
//            }
//
//            return (name, items)
//        }
    }
}

// MARK: - Masks
extension NetworkAdapter {
    func masks(forChallenge baseChallengeId: String) async throws -> [EditorFilter] {
        return await VDEVDataBuilder.masks()
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
        return await VDEVDataBuilder.textures()
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
        return await (VDEVDataBuilder.colorFilters() + VDEVDataBuilder.extendedColorFilters())
    }
}

// MARK: - Neural Filters
extension NetworkAdapter {
    func neuralFilters(forChallenge baseChallengeId: String) async throws -> [NeuralEditorFilter] {
        return try await client
            .neuralFilters(forChallenge: baseChallengeId)
            .compactMap { filter in
            .init(id: filter.id,
                  name: filter.name,
                  cover: filter.cover?.url,
                  steps: filter.stepsFull.compactMap { step in
                    .init(
                        id: step.id,
                        filterID: step.filterId,
                        url: step.url?.url,
                        neuralConfig: .make(from: step)
                    )
            })
        }
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
                
                let neuralConfig: NeuralConfig? = .make(from: $0)
                
                return Step(
                    type: stepType,
                    id: $0.id,
                    url: $0.url?.url,
                    settings: .init(jsonValue: $0.settings.jsonValue),
                    neuralConfig: neuralConfig
                )
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

fileprivate extension NeuralConfig {
    static func make(from stepFull: NetworkClient.EditorTemplate.Variant.ClientConfig.Item.Filter.StepsFull) -> NeuralConfig? {
        guard let config = stepFull.neuralConfig else { return nil }
        
        let dimension: [NeuralConfig.AllowedDimension] = config.allowedDimensions?
            .map {
                .init(width: $0.width, height: $0.height)
            } ?? []
        
        return .init(
            stepID: stepFull.id,
            minPixels: config.minPixels,
            maxPixels: config.maxPixels,
            allowedDimensions: dimension,
            dimensionsMultipleOf: config.dimensionsMultipleOf
        )
    }
    
    static func make(from stepFull: GetChallengeEditorFilterQuery.Data.BaseChallenge.AppEditorNeuralFilter.StepsFull) -> NeuralConfig? {
        guard let config = stepFull.neuralConfig else {
            return nil
        }
        
        let dimension: [NeuralConfig.AllowedDimension] = config.allowedDimensions?
            .map {
                .init(width: $0.width, height: $0.height)
            } ?? []
        
        return .init(
            stepID: stepFull.id,
            minPixels: config.minPixels,
            maxPixels: config.maxPixels,
            allowedDimensions: dimension,
            dimensionsMultipleOf: config.dimensionsMultipleOf
        )
    }
}
