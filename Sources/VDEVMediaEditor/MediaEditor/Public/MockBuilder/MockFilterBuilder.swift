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
            let data = stickersJSON.data(using: .utf8)!
            let decoder = JSONDecoder()
            let result = try decoder.decode(StickersData.self, from: data)
            
            let packs = result.data.baseChallenges
                .filter {
                    !$0.attachedStickerPacks.isEmpty
                }.flatMap {
                    $0.attachedStickerPacks }
                .filter {
                    !$0.stickersFull.isEmpty
                }
            
            return packs.map {
                let title = $0.titleLocalized
                let stickers: [StickerItem] = $0.stickersFull.compactMap { sticker in
                    guard let url = URL(string: sticker.uri) else { return nil }
                    return StickerItem.init(url: url)
                }
                return (title, stickers)
            }
        } catch {
            return []
        }
    }
    
    public static func masks() async -> [EditorFilter] {
        [
            EditorFilter(id: "631a8556-3524-40b3-a91b-55b7a231dcd4",
                         name: "",
                         cover: URL(string: "https://ucarecdn.com/7ee00469-0f37-482b-9538-a555c73a1498/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/7ee00469-0f37-482b-9538-a555c73a1498/")),
                         ]),
            
            
            EditorFilter(id: "5320e24b-baed-4acf-a58d-1d274b237b5d",
                         name: "",
                         cover: URL(string: "https://ucarecdn.com/3803d1b0-b388-4c90-8a40-0d5350f1cb12/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/3803d1b0-b388-4c90-8a40-0d5350f1cb12/")),
                         ]),
            
            
            EditorFilter(id: "7a665f4e-ff5d-4e53-8631-fe4f1fec4c26",
                         name: "",
                         cover: URL(string: "https://ucarecdn.com/115a3376-a518-4991-9bed-fd45d76d1512/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/115a3376-a518-4991-9bed-fd45d76d1512/")),
                         ]),
            
            EditorFilter(id: "9eb9d707-0540-491d-9858-b1a772200379",
                         name: "",
                         cover: URL(string: "https://ucarecdn.com/808a824d-33bb-4c70-a272-4d99a9e54f76/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/808a824d-33bb-4c70-a272-4d99a9e54f76/")),
                         ]),
            
            EditorFilter(id: "4e581809-3985-4181-a3f9-f4153ba547fd",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/c74ec704-30e3-434a-acc1-a31e10c6ace6/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/c74ec704-30e3-434a-acc1-a31e10c6ace6/")),
                         ]),
            
            EditorFilter(id: "33595016-af52-4a0a-bceb-89e82dd42de7",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/f14d5ab4-433c-4921-a576-31c89cadc183/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/f14d5ab4-433c-4921-a576-31c89cadc183/")),
                         ]),
            
            EditorFilter(id: "8cfae0d9-bde6-4ac8-9c10-678fb1951af2",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/21bca0c2-5738-4cc9-a15b-e9595b02cf65/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/21bca0c2-5738-4cc9-a15b-e9595b02cf65/")),
                         ]),
            
            EditorFilter(id: "03db5284-f3ba-45fc-8fbf-b126d6f216da",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/d1ecb5ad-aa32-4564-82e1-7db6f33579c1/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/d1ecb5ad-aa32-4564-82e1-7db6f33579c1/")),
                         ]),
            
            EditorFilter(id: "fb80daea-9c1e-4566-aef9-9e93cf5b36d2",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/98731409-f7c6-4544-8f6c-574a8980486f/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/98731409-f7c6-4544-8f6c-574a8980486f/")),
                         ]),
            
            EditorFilter(id: "719b12e0-b184-477e-adec-c14ea221ae38",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/8e05ed7b-c277-462e-b7d5-b5f72488fa55/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/8e05ed7b-c277-462e-b7d5-b5f72488fa55/")),
                         ]),
            
            EditorFilter(id: "dacaad9b-dd32-42f5-9d78-d1cc8d7bcc70",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/c5da6f07-0123-4c78-ac22-6fb067472ee2/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/c5da6f07-0123-4c78-ac22-6fb067472ee2/")),
                         ]),
            
            EditorFilter(id: "3fd62ec4-1cf6-4b7f-afb7-14599c070253",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/ffa5064c-b508-4d83-bcd1-dd75887c769c/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/ffa5064c-b508-4d83-bcd1-dd75887c769c/")),
                         ]),
            
            
            EditorFilter(id: "fe6f3bc6-098a-4d21-b5fc-0d2e543c753c",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/6fe916e6-1d5f-457e-b5c0-2c25d044e148/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/6fe916e6-1d5f-457e-b5c0-2c25d044e148/")),
                         ]),
            
            EditorFilter(id: "936552f9-bec5-4658-a942-e2a93f69edfb",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/272eabf3-ebc5-401b-a20c-dfcd86682f50/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/272eabf3-ebc5-401b-a20c-dfcd86682f50/")),
                         ]),
            
            EditorFilter(id: "7eb64ed5-ef66-4121-acea-37e0ac3e34ef",
                         name: "Plain Filter",
                         cover: URL(string: "https://ucarecdn.com/7a142797-3a0e-4375-bd74-675232ee1561/"),
                         steps: [
                            .init(type: .mask,
                                  url: URL(string: "https://ucarecdn.com/7a142797-3a0e-4375-bd74-675232ee1561/")),
                         ]),
        ]
    }
    
    public static func textures() async -> [EditorFilter] {
        return [
            EditorFilter(id: "0897dff9-f9d9-406b-bc7f-55292843dc56",
                         name: "Stars 5",
                         cover: URL(string: "https://ucarecdn.com/ad3d6f4a-e06c-42ca-96ee-f863a565ebea/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/77aa645c-7517-46be-aeee-d15c6e95c61f/"),
                                  settings: .init(jsonValue: ["blendMode": "CILightenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "862f9571-c4c9-4721-bcce-48deae3e7675",
                         name: "Stars 4",
                         cover: URL(string: "https://ucarecdn.com/28687adf-a283-43c8-9231-1d3ce2ae589d/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/57503a34-d1b4-43ee-8d48-d19a67ba5932/"),
                                  settings: .init(jsonValue: ["blendMode": "CILightenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "5d0c6f21-123c-46fe-9155-916176fefa25",
                         name: "Stars 3",
                         cover: URL(string: "https://ucarecdn.com/c0354537-2ef6-4909-8576-476925e3b446/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/7b7a109c-8d61-4f96-bc11-ee216f3e7af3/"),
                                  settings: .init(jsonValue: ["blendMode": "CILightenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "33119c9f-c481-4f4e-9bad-ba5099e62c34",
                         name: "Stars 2",
                         cover: URL(string: "https://ucarecdn.com/5efa6cba-243d-4470-9356-6bfaee3461c6/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/7d38514a-25ee-4801-b5fc-97016ca2d038/"),
                                  settings: .init(jsonValue: ["blendMode": "CILightenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "2f803958-6cb2-4a31-995a-0ceda86e2ce5",
                         name: "Stars 1",
                         cover: URL(string: "https://ucarecdn.com/52b9c53b-b38c-468e-ad8d-6fb848852c76/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/3de6cfd8-0411-4a71-8731-70ea8aacb228/"),
                                  settings: .init(jsonValue: ["blendMode": "CILightenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "0e8376fc-1ad2-4b75-814d-a7cfcacbf63d",
                         name: "Noise 5",
                         cover: URL(string: "https://ucarecdn.com/6c957bfc-9ac4-41e6-a847-10d3162329aa/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/34e83a6a-1fb9-429b-b282-e7cb8a012688/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "8cbf7983-4e00-44ec-ac16-5740ce090fa9",
                         name: "Noise 4",
                         cover: URL(string: "https://ucarecdn.com/123c226a-5a40-4a97-9d1b-ce26e23a32dd/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/c9bedbd7-d184-40f8-bf0f-e70bbb95b11b/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "e47a5c32-369a-4183-9ab8-902931b25a02",
                         name: "Noise 3",
                         cover: URL(string: "https://ucarecdn.com/fdaf3c29-597a-4b45-9b1e-1453fb1ac0db/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/654540a9-8bee-4493-8609-d79e22ce985b/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "5a2009ce-4c72-489e-b7b7-1c504911c91f",
                         name: "Noise 2",
                         cover: URL(string: "https://ucarecdn.com/05b7fef3-2551-472a-bdf9-261771e5d1e5/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/b17ddb1a-ee90-41a7-90a0-e0b30e08ac44/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "811a9872-2c8a-4bd5-a110-37146a84ad78",
                         name: "Noise 1",
                         cover: URL(string: "https://ucarecdn.com/eb52623e-5db9-4674-821e-9ed715ff029f/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/0fa087b3-098e-4649-a947-1738dc5cbb7c/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "199efc12-3532-429b-a650-e50760e3ca39",
                         name: "Glare 5",
                         cover: URL(string: "https://ucarecdn.com/819cf1f2-3665-4bfa-ab23-3cce0f9163b2/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/ea73775c-660f-4163-9ee0-8982ead79bf2/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "892a58a4-5526-427a-a881-9058d7d8ddc7",
                         name: "Glare 4",
                         cover: URL(string: "https://ucarecdn.com/43c893de-1c19-4239-a150-21542f1ce958/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/e5251b16-5082-452c-9543-952e7f7af1d7/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "5d0f6f92-5cd6-4458-bc3f-958492f2fdab",
                         name: "Glare 3",
                         cover: URL(string: "https://ucarecdn.com/0a7dc049-d2fc-4a35-8938-5324aa854002/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/3dc163f2-f6da-43cf-be9e-0bb473e93091/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "ced6c806-8943-4c46-b7f0-67e0c1b74f56",
                         name: "Glare 2",
                         cover: URL(string: "https://ucarecdn.com/67eaca4f-8dff-4eb3-8c18-7733bb3ae8e9/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/69d65fc4-c17f-42de-913f-002f21e45ff6/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "3e3d9c05-9f37-490b-bdc3-5fbe9cad0ace",
                         name: "Glare 1",
                         cover: URL(string: "https://ucarecdn.com/4eea5be9-4111-424d-a82f-f7f979bda21e/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/1cd17cc5-c670-4b91-80f7-cbd2fe8b12d3/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "37020bf2-b4fb-4581-ac92-3518d7c5af9e",
                         name: "Highlight 5",
                         cover: URL(string: "https://ucarecdn.com/00369b9c-fd7a-45f9-a152-c3c5f8af72b6/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/217fe193-d848-4c86-a3be-2f19e5f9d1b0/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "bdb74ccd-b6e0-4461-b8f6-a510fd63c811",
                         name: "Highlight 4",
                         cover: URL(string: "https://ucarecdn.com/2ac161fe-ca22-4957-a4ff-8d564deb7e26/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/a196d7f3-2e58-4ef2-851e-a726ee99f821/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "d01c7fe1-a0b0-4848-b660-0e288787a60f",
                         name: "Highlight 3",
                         cover: URL(string: "https://ucarecdn.com/55c37b67-386d-4ffe-b391-1ce9f40aba8b/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/12002a91-c526-4d4b-9cb9-43fb2a14687e/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "e7c6d9e1-9f72-41ba-9714-c76eb8bdc4bc",
                         name: "Highlight 2",
                         cover: URL(string: "https://ucarecdn.com/ad77c69d-3fb9-43fc-8c10-b3f772c673f6/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/0aed74cf-d1f8-4407-bb5c-792f2b336259/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "4d006426-0322-4852-879f-d2eae8191fe0",
                         name: "Highlight 1",
                         cover: URL(string: "https://ucarecdn.com/63d0ac16-3ae5-488a-947d-decb60e2641c/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/16750e37-c5e2-4318-b7ad-3f3cd03c2247/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "83bb0597-59ee-4be6-9094-85f31b1df47f",
                         name: "Copyscan 5",
                         cover: URL(string: "https://ucarecdn.com/d829b3a8-eb71-4d73-90f0-eb525c977720/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/2bc85df4-37dc-4beb-9385-dad3d3a4c159/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "b3dc35c3-d867-418a-8838-6a6407c23b62",
                         name: "Copyscan 4",
                         cover: URL(string: "https://ucarecdn.com/0695c3b4-d002-4ac4-bb0f-e2c8b6f27b1e/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/261cd992-f299-4f0e-bfb6-8d032946b114/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "94003f1a-b26e-49d5-a2eb-9f807b4c9891",
                         name: "Copyscan 3",
                         cover: URL(string: "https://ucarecdn.com/31210797-3f39-444d-85b6-71acab863a9b/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/88137864-8a48-4a33-9fbb-871bc9d4177e/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "02919d52-fffd-4b2a-82ae-b334a4890902",
                         name: "Copyscan 2",
                         cover: URL(string: "https://ucarecdn.com/cb21aee5-470e-453e-b135-e55717950c1a/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/16ea189e-d287-4cfb-9551-d38f19b0f52f/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "c857c064-774f-4638-ae72-f634ae87335e",
                         name: "Copyscan 1",
                         cover: URL(string: "https://ucarecdn.com/b6946c5b-5bc3-4ac4-8aa3-7fe1a046ac88/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/ddd8c2f3-70d8-448d-847e-f90789240558/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "56bd2da5-be62-40d4-9d8e-5f3d0a74a06a",
                         name: "Folded paper",
                         cover: URL(string: "https://ucarecdn.com/21d96856-f0c4-43c6-8570-5b88bbbfb4e0/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/f35f833f-b820-45a3-b95d-724387ad2788/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ]),
            
            EditorFilter(id: "a41b94b3-ff1d-40db-9ce6-b45b53f59e34",
                         name: "",
                         cover: URL(string: "https://ucarecdn.com/c34f4597-168b-468b-94f9-23febb61c181/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/c34f4597-168b-468b-94f9-23febb61c181/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode"] as [String : Any]))
                         ]),
            
            EditorFilter(id: "c747b0e9-2e1f-45f2-a052-43c7aaa93053",
                         name: "",
                         cover: URL(string: "https://ucarecdn.com/f2b51eb5-0d49-4c67-bbc2-54e9113498e5/"),
                         steps: [
                            .init(type: .texture,
                                  url: URL(string: "https://ucarecdn.com/f2b51eb5-0d49-4c67-bbc2-54e9113498e5/"),
                                  settings: .init(jsonValue: ["blendMode": "CIScreenBlendMode",
                                                              "contentMode": 0] as [String : Any]))
                         ])
        ]
    }
    
    public static func filters() async -> [EditorFilter] {
        [
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
