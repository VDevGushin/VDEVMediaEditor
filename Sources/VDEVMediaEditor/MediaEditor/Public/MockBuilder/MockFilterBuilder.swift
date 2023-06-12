//
//  MockBuilder.swift
//  
//
//  Created by Vladislav Gushin on 12.05.2023.
//

import Foundation

public struct VDEVDataBuilder {
    public static func stickers() async -> [(String, [StickerItem])] {
        do {
            let result: StickersData = try DomainConverter.makeFrom(stickersJSON)
            return DomainConverter.convertToDomain(result)
        } catch {
            Log.e(error.localizedDescription)
            return []
        }
    }
    
    public static func masks() async -> [EditorFilter] {
        do {
            let result: MasksData = try DomainConverter.makeFrom(masksJSON)
            return DomainConverter.convertToDomain(result)
        } catch {
            Log.e(error.localizedDescription)
            return []
        }
    }
    
    public static func textures() async -> [EditorFilter] {
        do {
            let result: TexturesData = try DomainConverter.makeFrom(texturesJSON)
            return DomainConverter.convertToDomain(result)
        } catch {
            Log.e(error.localizedDescription)
            return []
        }
    }
    
    public static func filters() async -> [EditorFilter] {
        return [
            EditorFilter(id: "9aef8fa2-da7f-42cd-8b32-58f81eb7581a",
                         name: "K3",
                         cover: URL.getLocal(fileName: "k3Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "k3Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "b29053ba-c320-4971-9859-aaa0e484f219",
                         name: "K2",
                         cover: URL.getLocal(fileName: "k2Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "k2Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "7b759f9c-3e92-4a8b-9aac-1a4ba9daa4c5",
                         name: "K1",
                         cover: URL.getLocal(fileName: "k1Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "k1Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "2ad48797-9803-4321-aa98-01034a13995a",
                         name: "D1",
                         cover: URL.getLocal(fileName: "d1Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "d1Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "bad37469-efa8-4360-9a53-c55fb7bbfea3",
                         name: "BW4",
                         cover: URL.getLocal(fileName: "bw4Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "bw4Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "2503c489-d2b5-47f4-aaa4-57b1c46680cd",
                         name: "BW3",
                         cover: URL.getLocal(fileName: "bw3Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "bw3Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51",
                         name: "BW2",
                         cover: URL.getLocal(fileName: "bw2Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "bw2Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         name: "BW1",
                         cover: URL.getLocal(fileName: "bw1Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "bw1Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "1be5f91e-e5fb-423a-a76a-bdee3b4f5f58",
                         name: "A4",
                         cover: URL.getLocal(fileName: "a4Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "a4Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "341684cf-51ad-4a8a-b1ab-b49b6595a9fc",
                         name: "A3",
                         cover: URL.getLocal(fileName: "a3Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "a3Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "d16a6ece-ad42-4338-b564-0edd71662e10",
                         name: "A2",
                         cover: URL.getLocal(fileName: "a2Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "a2Filter", ofType: "png"))
                         ]),
            
            EditorFilter(id: "619701b9-2d08-4971-b1c9-78cbb3efa7f6",
                         name: "A1",
                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
                         steps: [
                            .init(type: .lut,
                                  url: URL.getLocal(fileName: "a1Filter", ofType: "png"))
                         ]),
            
//            EditorFilter(id: "619701b9-2d08-4971-0000-78cbb3efa7f6",
//                         name: "Beagle",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Beagle", ofType: "png"))
//                         ]),
//            
//            EditorFilter(id: "619701b9-2d08-4971-0001-78cbb3efa7f6",
//                         name: "Birman",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Birman", ofType: "png"))
//                         ]),
//            
//            EditorFilter(id: "619701b9-2d08-4971-0002-78cbb3efa7f6",
//                         name: "Corgis",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Corgis", ofType: "png"))
//                         ]),
//            
//            EditorFilter(id: "619701b9-2d08-4971-0003-78cbb3efa7f6",
//                         name: "Labrador",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Labrador", ofType: "png"))
//                         ]),
//            
//            EditorFilter(id: "619701b9-2d08-4971-0004-78cbb3efa7f6",
//                         name: "Maine",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Maine", ofType: "png"))
//                         ]),
//            
//            EditorFilter(id: "619701b9-2d08-4971-0005-78cbb3efa7f6",
//                         name: "Persian",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Persian", ofType: "png"))
//                         ]),
//            
//            EditorFilter(id: "619701b9-2d08-4971-0006-78cbb3efa7f6",
//                         name: "Poodle",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Poodle", ofType: "png"))
//                         ]),
//            
//            EditorFilter(id: "619701b9-2d08-4971-0007-78cbb3efa7f6",
//                         name: "Pug",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Pug", ofType: "png"))
//                         ]),
//            
//            EditorFilter(id: "619701b9-2d08-4971-0008-78cbb3efa7f6",
//                         name: "Shorthair",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Shorthair", ofType: "png"))
//                         ]),
//            
//            EditorFilter(id: "619701b9-2d08-4971-0009-78cbb3efa7f6",
//                         name: "Siamese",
//                         cover: URL.getLocal(fileName: "a1Cover", ofType: "png"),
//                         steps: [
//                            .init(type: .lut,
//                                  url: URL.getLocal(fileName: "Siamese", ofType: "png"))
//                         ]),
        ]
    }
    
    public static func templates(canvasSize: CGSize) async -> [TemplatePack] {
        let templateBuilder = DI.resolve(TemplateBuilder.self)
        let simpleTemplates = await templateBuilder.buildTemplate(canvasSize: canvasSize)
        return [simpleTemplates]
    }
}
