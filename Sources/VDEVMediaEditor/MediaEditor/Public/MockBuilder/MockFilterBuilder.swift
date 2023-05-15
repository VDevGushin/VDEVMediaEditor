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
            return []
        }
    }
    
    public static func masks() async -> [EditorFilter] {
        do {
            let result: MasksData = try DomainConverter.makeFrom(masksJSON)
            return DomainConverter.convertToDomain(result)
        } catch {
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
        //UIImage(named: "favourite", in: Bundle.module, compatibleWith: nil)
        //let filePath = Bundle.main.path(forResource: "fileName", ofType: "m4a")!
        //let filePath = Bundle.module.path(forResource: "k3Cover", ofType: "png")!
        //let fileUrl = URL(fileURLWithPath: filePath)
        return [
            EditorFilter(id: "9aef8fa2-da7f-42cd-8b32-58f81eb7581a",
                         name: "K3",
                         cover: URL(string: "https://ucarecdn.com/cef311f6-499c-43ff-bada-114d9d3a2048/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/cb0b97e7-36ac-4a85-a43c-268c7aa763ae/"))
                         ]),
            
            EditorFilter(id: "b29053ba-c320-4971-9859-aaa0e484f219",
                         name: "K2",
                         cover: URL(string: "https://ucarecdn.com/77869a4f-f044-40fd-b630-0d4387e4c99d/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/3bf0db12-ca69-463f-9c88-44f7dd9199af/"))
                         ]),
            
            EditorFilter(id: "7b759f9c-3e92-4a8b-9aac-1a4ba9daa4c5",
                         name: "K1",
                         cover: URL(string: "https://ucarecdn.com/d945ccf2-93ef-4039-b2c5-eeb073018584/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/cb0b97e7-36ac-4a85-a43c-268c7aa763ae/"))
                         ]),
            
            EditorFilter(id: "2ad48797-9803-4321-aa98-01034a13995a",
                         name: "D1",
                         cover: URL(string: "https://ucarecdn.com/5e88fefc-6e6e-4484-a7c7-9f7de2bca451/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/56962e27-14d3-4e72-911a-29938cc3f8b0/"))
                         ]),
            
            EditorFilter(id: "bad37469-efa8-4360-9a53-c55fb7bbfea3",
                         name: "BW4",
                         cover: URL(string: "https://ucarecdn.com/74f85d79-816b-47f0-a77d-e911fe857d1a/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/a9028fc6-d6bf-47d8-96d9-a7150c2821ec/"))
                         ]),
            
            EditorFilter(id: "2503c489-d2b5-47f4-aaa4-57b1c46680cd",
                         name: "BW3",
                         cover: URL(string: "https://ucarecdn.com/453f6478-bd8f-47af-8692-e634af869b44/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/bd0280a9-1104-44f1-a7e3-400584eb0a24/"))
                         ]),
            
            EditorFilter(id: "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51",
                         name: "BW2",
                         cover: URL(string: "https://ucarecdn.com/1114f094-2cbe-4af9-b10c-e8f63f3d2ce2/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/3b79d83d-fdf1-41fe-8aef-3d96ac129fc3/"))
                         ]),
            
            EditorFilter(id: "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         name: "BW1",
                         cover: URL(string: "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/"))
                         ]),
            
            EditorFilter(id: "1be5f91e-e5fb-423a-a76a-bdee3b4f5f58",
                         name: "A4",
                         cover: URL(string: "https://ucarecdn.com/974f80c3-db9f-4ea1-b921-a70dbd9f1c35/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/0e6a1b77-b0dd-44d1-98fc-455915fdc239/"))
                         ]),
            
            EditorFilter(id: "341684cf-51ad-4a8a-b1ab-b49b6595a9fc",
                         name: "A3",
                         cover: URL(string: "https://ucarecdn.com/d58ae948-6506-45c7-9101-423624cf559a/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/6d73e11b-cccc-4920-b334-532fa2dd1558/"))
                         ]),
            
            EditorFilter(id: "d16a6ece-ad42-4338-b564-0edd71662e10",
                         name: "A2",
                         cover: URL(string: "https://ucarecdn.com/ff6fb161-ec50-4c9b-8c7d-95d3973e17b2/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/a698c942-e289-47d7-8c2f-2a6007b73a49/"))
                         ]),
            
            EditorFilter(id: "619701b9-2d08-4971-b1c9-78cbb3efa7f6",
                         name: "A1",
                         cover: URL(string: "https://ucarecdn.com/0c7eb8f9-f537-4121-9544-f3e85fbc8744/"),
                         steps: [
                            .init(type: .lut,
                                  url: URL(string: "https://ucarecdn.com/69155a6e-6603-4278-b8bc-17c77fe464e6/"))
                         ]),
        ]
    }
}
