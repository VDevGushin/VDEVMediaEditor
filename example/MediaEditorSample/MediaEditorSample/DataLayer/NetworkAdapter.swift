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

    func textures(forChallenge baseChallengeId: String) async throws -> [EditorFilter] {
        try await client.textures(forChallenge: baseChallengeId).compactMap { editorFilter -> EditorFilter? in
            guard let coverUrl = editorFilter.cover?.url else { return nil }
            let steps = editorFilter.stepsFull.compactMap { step -> EditorFilter.Step? in
                guard let url = step.url?.url,
                      let stepType = EditorFilter.Step.StepType(value: step.type) else { return nil }
                return .init(type: stepType, url: url, settings: .init(jsonValue: step.settings.jsonValue))
            }
            return .init(id: editorFilter.id, name: editorFilter.name, cover: coverUrl, steps: steps)
        }
    }

    func masks(forChallenge baseChallengeId: String) async throws -> [EditorFilter] {
        try await client.masks(forChallenge: baseChallengeId).compactMap { editorFilter -> EditorFilter? in
            guard let coverUrl = editorFilter.cover?.url else { return nil }
            let steps = editorFilter.stepsFull.compactMap { step -> EditorFilter.Step? in
                guard let url = step.url?.url,
                      let stepType = EditorFilter.Step.StepType(value: step.type) else { return nil }
                return .init(type: stepType, url: url)
            }
            return .init(id: editorFilter.id, name: editorFilter.name, cover: coverUrl, steps: steps)
        }
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
// MARK: - Inits
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

// MARK: - MOCK
extension NetworkAdapter {
    func filters(forChallenge baseChallengeId: String) async throws -> [EditorFilter] {
        // OLD get from network
        // return try await client.filters(forChallenge: baseChallengeId).compactMap { filter -> EditorFilter? in
        
        let resultMap1: [String: Any?] = ["id": "9aef8fa2-da7f-42cd-8b32-58f81eb7581a",
                                          "name": "K3",
                                          "cover": "https://ucarecdn.com/cef311f6-499c-43ff-bada-114d9d3a2048/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/cb0b97e7-36ac-4a85-a43c-268c7aa763ae/"]]]
        let f1 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap1)
        
        let resultMap2: [String: Any?] = ["id": "b29053ba-c320-4971-9859-aaa0e484f219",
                                          "name": "K2",
                                          "cover": "https://ucarecdn.com/77869a4f-f044-40fd-b630-0d4387e4c99d/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/3bf0db12-ca69-463f-9c88-44f7dd9199af/"]]]
        let f2 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap2)
        
        let resultMap3: [String: Any?] = ["id": "7b759f9c-3e92-4a8b-9aac-1a4ba9daa4c5",
                                          "name": "K1",
                                          "cover": "https://ucarecdn.com/d945ccf2-93ef-4039-b2c5-eeb073018584/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/cb0b97e7-36ac-4a85-a43c-268c7aa763ae/"]]]
        let f3 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap3)
        
        
        let resultMap4: [String: Any?] = ["id": "2ad48797-9803-4321-aa98-01034a13995a",
                                          "name": "D1",
                                          "cover": "https://ucarecdn.com/5e88fefc-6e6e-4484-a7c7-9f7de2bca451/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/56962e27-14d3-4e72-911a-29938cc3f8b0/"]]]
        let f4 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap4)
        
        let resultMap5: [String: Any?] = ["id": "bad37469-efa8-4360-9a53-c55fb7bbfea3",
                                          "name": "BW4",
                                          "cover": "https://ucarecdn.com/74f85d79-816b-47f0-a77d-e911fe857d1a/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/a9028fc6-d6bf-47d8-96d9-a7150c2821ec/"]]]
        let f5 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap5)
        
        let resultMap6: [String: Any?] = ["id": "2503c489-d2b5-47f4-aaa4-57b1c46680cd",
                                          "name": "BW3",
                                          "cover": "https://ucarecdn.com/453f6478-bd8f-47af-8692-e634af869b44/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/bd0280a9-1104-44f1-a7e3-400584eb0a24/"]]]
                                          
                                          /*
                                           "stepsFull": [["type": "lut",
                                                          "url": "https://ucarecdn.com/bd0280a9-1104-44f1-a7e3-400584eb0a24/"],
                                                         ["type": "mask",
                                                          "url": "https://ucarecdn.com/60085eaa-6024-4974-bdff-ab83a03fe110/"]]]
                                           */
        let f6 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap6)
        
        let resultMap7: [String: Any?] = ["id": "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51",
                                          "name": "BW2",
                                          "cover": "https://ucarecdn.com/1114f094-2cbe-4af9-b10c-e8f63f3d2ce2/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/3b79d83d-fdf1-41fe-8aef-3d96ac129fc3/"]]]
        let f7 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap7)
        
        
        let resultMap8: [String: Any?] = ["id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                                          "name": "BW1",
                                          "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/"]]]
        let f8 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap8)
        
        let resultMap9: [String: Any?] = ["id": "1be5f91e-e5fb-423a-a76a-bdee3b4f5f58",
                                          "name": "A4",
                                          "cover": "https://ucarecdn.com/974f80c3-db9f-4ea1-b921-a70dbd9f1c35/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/0e6a1b77-b0dd-44d1-98fc-455915fdc239/"]]]
        let f9 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap9)
        
        let resultMap10: [String: Any?] = ["id": "341684cf-51ad-4a8a-b1ab-b49b6595a9fc",
                                           "name": "A3",
                                           "cover": "https://ucarecdn.com/d58ae948-6506-45c7-9101-423624cf559a/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/6d73e11b-cccc-4920-b334-532fa2dd1558/"]]]
        let f10 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap10)
        
        let resultMap11: [String: Any?] = ["id": "d16a6ece-ad42-4338-b564-0edd71662e10",
                                           "name": "A2",
                                           "cover": "https://ucarecdn.com/ff6fb161-ec50-4c9b-8c7d-95d3973e17b2/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/a698c942-e289-47d7-8c2f-2a6007b73a49/"]]]
        let f11 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap11)
        
        let resultMap12: [String: Any?] = ["id": "619701b9-2d08-4971-b1c9-78cbb3efa7f6",
                                           "name": "A1",
                                           "cover": "https://ucarecdn.com/0c7eb8f9-f537-4121-9544-f3e85fbc8744/",
                                          "stepsFull": [["type": "lut",
                                                         "url": "https://ucarecdn.com/69155a6e-6603-4278-b8bc-17c77fe464e6/"]]]
        let f12 = NetworkClient.EditorColorFilter(unsafeResultMap: resultMap12)
        
        
        return [f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12].compactMap { filter -> EditorFilter? in
            guard let coverUrl = filter.cover?.url else { return nil }
            return EditorFilter(
                id: filter.id,
                name: filter.name,
                cover: coverUrl,
                steps: filter.stepsFull.compactMap { step in
                    guard let imageURL = step.url?.url,
                          let stepType = EditorFilter.Step.StepType(value: step.type) else { return nil }
                    return .init(type: stepType, url: imageURL)
                }
            )
        }
    }
   // GetChallengeEditorFilterQuery.Data.BaseChallenge.AppEditorFilter.init(unsafeResultMap: )
}
/*
 {
   "data": {
     "baseChallenge": {
       "__typename": "BaseChallenge",
       "appEditorFilters": [
         {
           "__typename": "EditorFilter",
           "id": "9aef8fa2-da7f-42cd-8b32-58f81eb7581a",
           "name": "K3",
           "cover": "https://ucarecdn.com/cef311f6-499c-43ff-bada-114d9d3a2048/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/84996ef2-5818-40ce-a395-fe5f0c0c2060/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "b29053ba-c320-4971-9859-aaa0e484f219",
           "name": "K2",
           "cover": "https://ucarecdn.com/77869a4f-f044-40fd-b630-0d4387e4c99d/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/3bf0db12-ca69-463f-9c88-44f7dd9199af/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "7b759f9c-3e92-4a8b-9aac-1a4ba9daa4c5",
           "name": "K1",
           "cover": "https://ucarecdn.com/d945ccf2-93ef-4039-b2c5-eeb073018584/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/cb0b97e7-36ac-4a85-a43c-268c7aa763ae/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "2ad48797-9803-4321-aa98-01034a13995a",
           "name": "D1",
           "cover": "https://ucarecdn.com/5e88fefc-6e6e-4484-a7c7-9f7de2bca451/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/56962e27-14d3-4e72-911a-29938cc3f8b0/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "bad37469-efa8-4360-9a53-c55fb7bbfea3",
           "name": "BW4",
           "cover": "https://ucarecdn.com/74f85d79-816b-47f0-a77d-e911fe857d1a/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/a9028fc6-d6bf-47d8-96d9-a7150c2821ec/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "2503c489-d2b5-47f4-aaa4-57b1c46680cd",
           "name": "BW3",
           "cover": "https://ucarecdn.com/453f6478-bd8f-47af-8692-e634af869b44/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/bd0280a9-1104-44f1-a7e3-400584eb0a24/"
             },
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/60085eaa-6024-4974-bdff-ab83a03fe110/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51",
           "name": "BW2",
           "cover": "https://ucarecdn.com/1114f094-2cbe-4af9-b10c-e8f63f3d2ce2/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/3b79d83d-fdf1-41fe-8aef-3d96ac129fc3/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
           "name": "BW1",
           "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "1be5f91e-e5fb-423a-a76a-bdee3b4f5f58",
           "name": "A4",
           "cover": "https://ucarecdn.com/974f80c3-db9f-4ea1-b921-a70dbd9f1c35/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/0e6a1b77-b0dd-44d1-98fc-455915fdc239/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "341684cf-51ad-4a8a-b1ab-b49b6595a9fc",
           "name": "A3",
           "cover": "https://ucarecdn.com/d58ae948-6506-45c7-9101-423624cf559a/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/6d73e11b-cccc-4920-b334-532fa2dd1558/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "d16a6ece-ad42-4338-b564-0edd71662e10",
           "name": "A2",
           "cover": "https://ucarecdn.com/ff6fb161-ec50-4c9b-8c7d-95d3973e17b2/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/a698c942-e289-47d7-8c2f-2a6007b73a49/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "619701b9-2d08-4971-b1c9-78cbb3efa7f6",
           "name": "A1",
           "cover": "https://ucarecdn.com/0c7eb8f9-f537-4121-9544-f3e85fbc8744/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "lut",
               "url": "https://ucarecdn.com/69155a6e-6603-4278-b8bc-17c77fe464e6/"
             }
           ]
         }
       ]
     }
   }
 }
 */
