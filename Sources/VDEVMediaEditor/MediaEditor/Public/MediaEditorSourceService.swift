//
//  VDEVMediaEditorSourceService.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 14.04.2023.
//

import UIKit

public struct StartMetaConfig {
    public let isAttachedTemplate: Bool
    public let title: String
    public let subTitle: String
    
    public init(isAttachedTemplate: Bool, title: String, subTitle: String) {
        self.isAttachedTemplate = isAttachedTemplate
        self.title = title
        self.subTitle = subTitle.uppercased()
    }
}

public protocol VDEVMediaEditorSourceService {
    func filters(forChallenge baseChallengeId: String) async throws -> [EditorFilter]
    
    func textures(forChallenge baseChallengeId: String) async throws -> [EditorFilter]
    
    func masks(forChallenge baseChallengeId: String) async throws -> [EditorFilter]
    
    func editorTemplates(forChallenge baseChallengeId: String,
                         challengeTitle: String,
                         renderSize: CGSize) async throws -> [TemplatePack]
    
    func stickersPack(forChallenge baseChallengeId: String) async throws -> [(String, [StickerItem])]
    
    func startMeta(forChallenge baseChallengeId: String) async -> StartMetaConfig?
}

// MARK: - Color filters
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

// MARK: - Stickers
/*
 {
   "data": {
     "baseChallenge": {
       "__typename": "BaseChallenge",
       "appStickerPacks": [
         {
           "__typename": "StickerPack",
           "titleLocalized": "Hilma af Klint",
           "stickersFull": [
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/5ce22bf8-5cc7-46a2-b27d-3f9b4170b7b8/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/b74584d9-0c48-4c00-8e56-c2425f062308/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/4a4e3b0b-3511-4ce3-8f21-be174b81a19b/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/cae5f6c5-9177-4f68-8abe-1f9d0122b09a/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/84dbf38a-c248-4df7-b325-4a57618898d7/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/e94b2dae-1d4d-45a9-b52c-4da65c44242d/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/999c8e87-8e7a-49af-8b27-d43afbac14c7/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/b0677e54-f95a-4146-be4e-98fffe5bfc66/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/e77694d3-3a4a-48b0-86ed-6c7906deddfa/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/37faf6c1-f11a-45ef-805c-24ba1da60955/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/1c007a8e-97ec-4719-be62-0659ec01c3ee/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/0f41c117-b21f-4c7b-b9d6-701a6ed0d2dd/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/9305d68b-dd9b-4023-8607-2ecdd38ac5b7/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/8c250440-166f-4f87-8c63-40227f93c99d/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/86f97a3e-6de3-4471-ab70-a575548016cb/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/f0d042dd-af90-4b7f-925a-1ee48c4302e4/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/c395acc8-1729-4e21-83ce-25cd0ee6299b/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/88932db7-2f24-4a12-a1ca-89f6669f2a3d/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/b7fb4921-40a2-4682-a496-b8072c561694/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/13c6f936-1fe8-4ceb-a5b8-94d5b4c12764/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/8ac341b8-e851-429a-8563-45fa9fcd069f/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/bb446b6f-6a89-4812-859d-5329dce305a9/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/e23cadb2-eb51-4dfb-9af9-6fffc28bdc8b/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/38d634c9-4120-498f-8ace-c0a44753c273/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/56789bd0-d892-4ff8-a80c-0a027d203df7/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/d248d410-b978-4fcc-a3f2-e88f0d916021/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/6030f058-3229-4047-a54a-87b59475233b/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/927b411f-9cc5-4bc4-b3d7-ac517cfc6c17/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/83efc68e-7b53-4ebf-9a16-fb70e82389f6/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/6cbe2600-f07f-400b-a54e-640bcf770699/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/8fca2127-5e25-408a-8789-f96baa6a4eaa/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/afba9edd-238c-4541-936a-79c00e82b090/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/355492bf-fde0-4ec9-bb23-cfc6c2446ed4/"
             }
           ]
         },
         {
           "__typename": "StickerPack",
           "titleLocalized": "Stickers",
           "stickersFull": [
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/e988afdf-d1bd-49b9-8f50-d6855473b1b1/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/a6d336a6-8a4e-4c31-8097-8338753a3216/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/d860b7aa-539f-4a3c-875d-4b9d7310d7f8/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/3fac2afb-9800-41e3-89e8-bae932f8134e/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/7659eed6-dd4e-4cd4-b8ba-3b3c640911b1/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/054f7845-e0fa-478e-8bce-5b2f4701dabd/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/2210f71e-805b-4952-b3a9-d6561a7c7200/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/c8039951-0bee-4ca3-8224-2d4e9242bcf1/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/cf9f5850-c12d-4da9-b35f-18f0b6c8b5eb/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/6c21f6d5-6410-4be7-a52e-4176ecdf3ba0/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/13b80ab7-84fb-47d0-9745-378c45b845a1/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/43fad9ff-2e4e-4c15-adb1-217ad4f436a3/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/a2336ca8-a937-4bcc-bbba-f7d906f3e93b/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/2153024f-3268-455e-a657-5077b36b265b/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/1b812ef6-ebb5-4b50-b061-f8c31334cd10/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/1f47c529-27c6-4090-bb5e-63cb8564d1ec/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/f6679ff6-eee3-42fa-ba72-a469211ca723/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/49a97089-b667-40e2-b2b6-4aac47fa5425/"
             }
           ]
         },
         {
           "__typename": "StickerPack",
           "titleLocalized": "Scribbles",
           "stickersFull": [
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/9fab9767-5bb6-4aae-a066-8476bc12742f/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/61bdf728-6bce-4fed-838b-f4ace569f6c5/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/42cda206-4d11-49fb-af1b-df120703cc1b/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/9837af29-16a6-4c2f-b658-7546cec12d00/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/bd241fbd-22bb-438b-882d-af8ef55bcb73/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/b274b5e9-7edd-4785-b54f-92902695ece3/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/ca1f559b-db51-40e4-8f3f-124d5a5f0446/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/3a50e65c-08d1-48e9-bce5-91a034951473/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/53c2a90f-5a81-441b-ae5f-b8250346ff45/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/15f39492-02da-4ed0-b655-027380cf5b59/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/9db04a68-2693-44f7-84e2-3b3e1cbc7147/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/3e6eed61-5567-411d-a828-b00c9a77d085/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/4bc35a50-9755-49e7-bf61-8bc94430dfca/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/e0b65c97-2432-4339-bc92-6b6c932d7501/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/c5df35b5-e979-4066-ae37-e1114531968c/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/74c8436d-19a1-4303-b3ae-eecff150d349/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/0b7af1d2-95e3-4024-a47e-46db19a91757/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/cd6cb12f-c8e6-42bd-9f05-d3860a0d530d/"
             }
           ]
         },
         {
           "__typename": "StickerPack",
           "titleLocalized": "Botanical",
           "stickersFull": [
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/5274c309-aecc-4c04-912f-b2d69d38699f/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/80d61b3e-7541-4b97-b286-6b573316ce7c/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/1b391fba-0339-4654-b0b3-0dac78fab893/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/206332da-d5e0-47ae-9ca9-447537b2090c/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/cb477468-a244-4437-8776-067ab6268872/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/d4b843e5-c582-4668-9831-7e8c741f6fb8/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/5c6db18c-8337-4698-8335-cf0462e15e2e/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/08c95673-7aa5-45d3-ba38-39c032512bac/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/d161ec35-3ceb-4b7b-a88d-3a80324a877a/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/6a93ec01-0702-4543-8e5b-11ac1ecbf856/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/23a35797-741a-4681-a071-ba8524ce4697/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/13a48690-cc7d-44f0-862e-22bc915a9e00/"
             }
           ]
         },
         {
           "__typename": "StickerPack",
           "titleLocalized": "Default pack",
           "stickersFull": [
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/d5ecf6aa-35ba-4edf-80d7-dc54837ac34d/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/e682ef3c-5156-42e5-babb-514944403c1b/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/e1d1c430-f059-4440-86fa-84bc6ed30977/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/a25518dc-b002-4295-906a-138561dc5127/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/84135287-ed39-40d2-9eff-40daa537c762/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/6223f209-48ac-41ba-9826-ec61ad23c440/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/9a1ac54a-d208-4f07-8723-0a26c4a30874/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/fecd1c4d-5846-4c8a-9b3f-eb8f11f55846/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/9a7f6471-2d48-4d39-98c0-c02394b0e45e/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/8ab75ab2-0d3a-45d8-8a35-46ff75171aa5/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/235aaaa1-d8a9-49a7-b3c0-e68f79c33ee8/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/a011bde5-337e-4e5c-8751-a50c8a7c2d6f/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/97abded3-bbbe-473e-a6f2-10b795102da8/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/2957b23d-c0d2-49ec-8140-8aa5adbbff5d/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/86c32b6e-b438-41dc-998c-3e0626219906/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/d9c3ebfa-6e0e-4659-ac1c-fa75cde43b0b/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/d7c4db8a-7f4a-44fb-9008-a9aec5a911d6/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/89766f01-69c7-4753-8c28-1c0528937d7c/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/5503a778-4f27-4060-9496-a1e617ca8236/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/7285d00e-2294-480f-b97b-546a317934b8/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/62f8e41c-7c4e-41bf-bb4f-7be1a94ff20e/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/ff15682d-5bd2-4c45-a910-f3d556e952d1/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/97b1ba8a-c7cb-4c33-ad7e-f08cac52d909/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/b89d4ff1-c1d7-4d53-8609-7964994f6ab6/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/a9bad891-fd6f-4e36-8c6e-7ea7fa8b51e2/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/523b7667-9a73-4952-ba33-bb0efeb3519e/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/0d3b3fcd-4111-4995-ac40-f58cd80deb5c/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/5b69de37-3afa-403f-8e09-4f1942e27b05/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/134b1bfd-e437-46d7-8a42-7f601bc3b5b2/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/60a0859e-9b20-4afe-b3fe-707e3c2d6741/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/dec27b41-be5b-4d4e-a0ea-a5795ca05ef4/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/639767e2-b38b-4814-b4a1-67fb9dcf9c4d/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/fda5608a-b567-45a0-b96a-daf4f154e0cf/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/56348248-ea72-44dc-b7a5-cb850de7569c/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/d3292683-fefe-4eae-b480-9dc5565a3ee0/"
             },
             {
               "__typename": "Sticker",
               "uri": "https://ucarecdn.com/fcfb06da-e1ca-4f65-b409-cb9545b30228/"
             }
           ]
         }
       ]
     }
   }
 }
 */

// MARK: - MASK
/*
 {
   "data": {
     "baseChallenge": {
       "__typename": "BaseChallenge",
       "appEditorMasks": [
         {
           "__typename": "EditorFilter",
           "id": "631a8556-3524-40b3-a91b-55b7a231dcd4",
           "name": "",
           "cover": "https://ucarecdn.com/7ee00469-0f37-482b-9538-a555c73a1498/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/7ee00469-0f37-482b-9538-a555c73a1498/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "5320e24b-baed-4acf-a58d-1d274b237b5d",
           "name": "",
           "cover": "https://ucarecdn.com/3803d1b0-b388-4c90-8a40-0d5350f1cb12/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/3803d1b0-b388-4c90-8a40-0d5350f1cb12/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "7a665f4e-ff5d-4e53-8631-fe4f1fec4c26",
           "name": "",
           "cover": "https://ucarecdn.com/115a3376-a518-4991-9bed-fd45d76d1512/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/115a3376-a518-4991-9bed-fd45d76d1512/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "9eb9d707-0540-491d-9858-b1a772200379",
           "name": "",
           "cover": "https://ucarecdn.com/808a824d-33bb-4c70-a272-4d99a9e54f76/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/808a824d-33bb-4c70-a272-4d99a9e54f76/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "4e581809-3985-4181-a3f9-f4153ba547fd",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/c74ec704-30e3-434a-acc1-a31e10c6ace6/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/c74ec704-30e3-434a-acc1-a31e10c6ace6/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "33595016-af52-4a0a-bceb-89e82dd42de7",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/f14d5ab4-433c-4921-a576-31c89cadc183/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/f14d5ab4-433c-4921-a576-31c89cadc183/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "8cfae0d9-bde6-4ac8-9c10-678fb1951af2",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/21bca0c2-5738-4cc9-a15b-e9595b02cf65/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/21bca0c2-5738-4cc9-a15b-e9595b02cf65/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "03db5284-f3ba-45fc-8fbf-b126d6f216da",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/d1ecb5ad-aa32-4564-82e1-7db6f33579c1/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/d1ecb5ad-aa32-4564-82e1-7db6f33579c1/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "fb80daea-9c1e-4566-aef9-9e93cf5b36d2",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/98731409-f7c6-4544-8f6c-574a8980486f/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/98731409-f7c6-4544-8f6c-574a8980486f/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "719b12e0-b184-477e-adec-c14ea221ae38",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/8e05ed7b-c277-462e-b7d5-b5f72488fa55/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/8e05ed7b-c277-462e-b7d5-b5f72488fa55/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "dacaad9b-dd32-42f5-9d78-d1cc8d7bcc70",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/c5da6f07-0123-4c78-ac22-6fb067472ee2/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/c5da6f07-0123-4c78-ac22-6fb067472ee2/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "3fd62ec4-1cf6-4b7f-afb7-14599c070253",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/ffa5064c-b508-4d83-bcd1-dd75887c769c/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/ffa5064c-b508-4d83-bcd1-dd75887c769c/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "fe6f3bc6-098a-4d21-b5fc-0d2e543c753c",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/6fe916e6-1d5f-457e-b5c0-2c25d044e148/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/6fe916e6-1d5f-457e-b5c0-2c25d044e148/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "936552f9-bec5-4658-a942-e2a93f69edfb",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/272eabf3-ebc5-401b-a20c-dfcd86682f50/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/272eabf3-ebc5-401b-a20c-dfcd86682f50/"
             }
           ]
         },
         {
           "__typename": "EditorFilter",
           "id": "7eb64ed5-ef66-4121-acea-37e0ac3e34ef",
           "name": "Plain Filter",
           "cover": "https://ucarecdn.com/7a142797-3a0e-4375-bd74-675232ee1561/",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "mask",
               "url": "https://ucarecdn.com/7a142797-3a0e-4375-bd74-675232ee1561/"
             }
           ]
         }
       ]
     }
   }
 }
 */

// MARK: - Textures
/*
 {
   "data": {
     "baseChallenge": {
       "__typename": "BaseChallenge",
       "appEditorTextures": [
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/77aa645c-7517-46be-aeee-d15c6e95c61f/",
               "settings": {
                 "blendMode": "CILightenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Stars 5",
           "cover": "https://ucarecdn.com/ad3d6f4a-e06c-42ca-96ee-f863a565ebea/",
           "id": "0897dff9-f9d9-406b-bc7f-55292843dc56"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/57503a34-d1b4-43ee-8d48-d19a67ba5932/",
               "settings": {
                 "blendMode": "CILightenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Stars 4",
           "cover": "https://ucarecdn.com/28687adf-a283-43c8-9231-1d3ce2ae589d/",
           "id": "862f9571-c4c9-4721-bcce-48deae3e7675"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/7b7a109c-8d61-4f96-bc11-ee216f3e7af3/",
               "settings": {
                 "blendMode": "CILightenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Stars 3",
           "cover": "https://ucarecdn.com/c0354537-2ef6-4909-8576-476925e3b446/",
           "id": "5d0c6f21-123c-46fe-9155-916176fefa25"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/7d38514a-25ee-4801-b5fc-97016ca2d038/",
               "settings": {
                 "blendMode": "CILightenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Stars 2",
           "cover": "https://ucarecdn.com/5efa6cba-243d-4470-9356-6bfaee3461c6/",
           "id": "33119c9f-c481-4f4e-9bad-ba5099e62c34"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/3de6cfd8-0411-4a71-8731-70ea8aacb228/",
               "settings": {
                 "blendMode": "CILightenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Stars 1",
           "cover": "https://ucarecdn.com/52b9c53b-b38c-468e-ad8d-6fb848852c76/",
           "id": "2f803958-6cb2-4a31-995a-0ceda86e2ce5"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/34e83a6a-1fb9-429b-b282-e7cb8a012688/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Noise 5",
           "cover": "https://ucarecdn.com/6c957bfc-9ac4-41e6-a847-10d3162329aa/",
           "id": "0e8376fc-1ad2-4b75-814d-a7cfcacbf63d"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/c9bedbd7-d184-40f8-bf0f-e70bbb95b11b/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Noise 4",
           "cover": "https://ucarecdn.com/123c226a-5a40-4a97-9d1b-ce26e23a32dd/",
           "id": "8cbf7983-4e00-44ec-ac16-5740ce090fa9"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/654540a9-8bee-4493-8609-d79e22ce985b/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Noise 3",
           "cover": "https://ucarecdn.com/fdaf3c29-597a-4b45-9b1e-1453fb1ac0db/",
           "id": "e47a5c32-369a-4183-9ab8-902931b25a02"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/b17ddb1a-ee90-41a7-90a0-e0b30e08ac44/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Noise 2",
           "cover": "https://ucarecdn.com/05b7fef3-2551-472a-bdf9-261771e5d1e5/",
           "id": "5a2009ce-4c72-489e-b7b7-1c504911c91f"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/0fa087b3-098e-4649-a947-1738dc5cbb7c/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Noise 1",
           "cover": "https://ucarecdn.com/eb52623e-5db9-4674-821e-9ed715ff029f/",
           "id": "811a9872-2c8a-4bd5-a110-37146a84ad78"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/ea73775c-660f-4163-9ee0-8982ead79bf2/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Glare 5",
           "cover": "https://ucarecdn.com/819cf1f2-3665-4bfa-ab23-3cce0f9163b2/",
           "id": "199efc12-3532-429b-a650-e50760e3ca39"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/e5251b16-5082-452c-9543-952e7f7af1d7/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Glare 4",
           "cover": "https://ucarecdn.com/43c893de-1c19-4239-a150-21542f1ce958/",
           "id": "892a58a4-5526-427a-a881-9058d7d8ddc7"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/3dc163f2-f6da-43cf-be9e-0bb473e93091/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Glare 3",
           "cover": "https://ucarecdn.com/0a7dc049-d2fc-4a35-8938-5324aa854002/",
           "id": "5d0f6f92-5cd6-4458-bc3f-958492f2fdab"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/69d65fc4-c17f-42de-913f-002f21e45ff6/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Glare 2",
           "cover": "https://ucarecdn.com/67eaca4f-8dff-4eb3-8c18-7733bb3ae8e9/",
           "id": "ced6c806-8943-4c46-b7f0-67e0c1b74f56"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/1cd17cc5-c670-4b91-80f7-cbd2fe8b12d3/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Glare 1",
           "cover": "https://ucarecdn.com/4eea5be9-4111-424d-a82f-f7f979bda21e/",
           "id": "3e3d9c05-9f37-490b-bdc3-5fbe9cad0ace"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/217fe193-d848-4c86-a3be-2f19e5f9d1b0/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Highlight 5",
           "cover": "https://ucarecdn.com/00369b9c-fd7a-45f9-a152-c3c5f8af72b6/",
           "id": "37020bf2-b4fb-4581-ac92-3518d7c5af9e"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/a196d7f3-2e58-4ef2-851e-a726ee99f821/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Highlight 4",
           "cover": "https://ucarecdn.com/2ac161fe-ca22-4957-a4ff-8d564deb7e26/",
           "id": "bdb74ccd-b6e0-4461-b8f6-a510fd63c811"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/12002a91-c526-4d4b-9cb9-43fb2a14687e/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Highlight 3",
           "cover": "https://ucarecdn.com/55c37b67-386d-4ffe-b391-1ce9f40aba8b/",
           "id": "d01c7fe1-a0b0-4848-b660-0e288787a60f"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/0aed74cf-d1f8-4407-bb5c-792f2b336259/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Highlight 2",
           "cover": "https://ucarecdn.com/ad77c69d-3fb9-43fc-8c10-b3f772c673f6/",
           "id": "e7c6d9e1-9f72-41ba-9714-c76eb8bdc4bc"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/16750e37-c5e2-4318-b7ad-3f3cd03c2247/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Highlight 1",
           "cover": "https://ucarecdn.com/63d0ac16-3ae5-488a-947d-decb60e2641c/",
           "id": "4d006426-0322-4852-879f-d2eae8191fe0"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/2bc85df4-37dc-4beb-9385-dad3d3a4c159/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Copyscan 5",
           "cover": "https://ucarecdn.com/d829b3a8-eb71-4d73-90f0-eb525c977720/",
           "id": "83bb0597-59ee-4be6-9094-85f31b1df47f"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/261cd992-f299-4f0e-bfb6-8d032946b114/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Copyscan 4",
           "cover": "https://ucarecdn.com/0695c3b4-d002-4ac4-bb0f-e2c8b6f27b1e/",
           "id": "b3dc35c3-d867-418a-8838-6a6407c23b62"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/88137864-8a48-4a33-9fbb-871bc9d4177e/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Copyscan 3",
           "cover": "https://ucarecdn.com/31210797-3f39-444d-85b6-71acab863a9b/",
           "id": "94003f1a-b26e-49d5-a2eb-9f807b4c9891"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/16ea189e-d287-4cfb-9551-d38f19b0f52f/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Copyscan 2",
           "cover": "https://ucarecdn.com/cb21aee5-470e-453e-b135-e55717950c1a/",
           "id": "02919d52-fffd-4b2a-82ae-b334a4890902"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/ddd8c2f3-70d8-448d-847e-f90789240558/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Copyscan 1",
           "cover": "https://ucarecdn.com/b6946c5b-5bc3-4ac4-8aa3-7fe1a046ac88/",
           "id": "c857c064-774f-4638-ae72-f634ae87335e"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/f35f833f-b820-45a3-b95d-724387ad2788/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "Folded paper",
           "cover": "https://ucarecdn.com/21d96856-f0c4-43c6-8570-5b88bbbfb4e0/",
           "id": "56bd2da5-be62-40d4-9d8e-5f3d0a74a06a"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/c34f4597-168b-468b-94f9-23febb61c181/",
               "settings": {
                 "blendMode": "CIScreenBlendMode"
               }
             }
           ],
           "name": "",
           "cover": "https://ucarecdn.com/c34f4597-168b-468b-94f9-23febb61c181/",
           "id": "a41b94b3-ff1d-40db-9ce6-b45b53f59e34"
         },
         {
           "__typename": "EditorFilter",
           "stepsFull": [
             {
               "__typename": "EditorFilterStep",
               "type": "texture",
               "url": "https://ucarecdn.com/f2b51eb5-0d49-4c67-bbc2-54e9113498e5/",
               "settings": {
                 "blendMode": "CIScreenBlendMode",
                 "contentMode": 0
               }
             }
           ],
           "name": "",
           "cover": "https://ucarecdn.com/f2b51eb5-0d49-4c67-bbc2-54e9113498e5/",
           "id": "c747b0e9-2e1f-45f2-a052-43c7aaa93053"
         }
       ]
     }
   }
 }
 */

// MARK: - Templates
/*
 {
   "data": {
     "baseChallenge": {
       "__typename": "BaseChallenge",
       "appEditorTemplates": [
         {
           "__typename": "EditorTemplate",
           "id": "93f84397-fbf5-4543-ad0b-20e8d656683b",
           "cover": "https://ucarecdn.com/386aca99-c663-478d-b51d-3e92608f8042/",
           "nameLocalized": "Diary ",
           "isAttached": true,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "501f2f03-6127-4a3c-becb-2d5a51f34688",
               "cover": "https://ucarecdn.com/5858405d-d35e-4dc0-baca-db0010744ed5/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/a2147a93-93ff-4dca-8f8f-679b76a37e78/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/a2147a93-93ff-4dca-8f8f-679b76a37e78/"
                     },
                     "textLocalized": "",
                     "id": "9c821f38-ec19-4986-b2e9-6386993c0963",
                     "config": {
                       "x": 28,
                       "y": 24.4,
                       "width": 244,
                       "height": 351.2,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 0,
                     "settings": {},
                     "textLocalized": "{challenge.title}",
                     "id": "a388e2a9-e548-4ec2-9081-c2cedcced0a5",
                     "config": {
                       "x": 47.2,
                       "y": 38.8,
                       "width": 205.6,
                       "height": 60,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": 1,
                     "defaultColor": "#999999",
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 0,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "WilliamTextPro-Reg"
                       },
                       "fontSize": 13,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 13
                     }
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "Write your diary here",
                     "id": "cdaf8241-d1be-450e-8c2a-26ffc6656c0e",
                     "config": {
                       "x": 52,
                       "y": 120.4,
                       "width": 197.6,
                       "height": 224.8,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": 0,
                     "defaultColor": "#444444",
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 0,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "WilliamTextPro-Reg"
                       },
                       "fontSize": 13,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 13
                     }
                   }
                 ]
               }
             }
           ]
         },
         {
           "__typename": "EditorTemplate",
           "id": "f6b5b9d9-a86c-4fcf-940f-c417ea79b294",
           "cover": "https://ucarecdn.com/d752b1c0-0d22-4c63-a315-3c75f8d6bde2/",
           "nameLocalized": "Everyday haiku",
           "isAttached": false,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "5d3c5ae2-3199-4963-ab54-25e9e369531b",
               "cover": "https://ucarecdn.com/d752b1c0-0d22-4c63-a315-3c75f8d6bde2/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/eb1c371e-78d7-4917-a47c-51629eecae0c/",
                     "type": 0,
                     "settings": {},
                     "textLocalized": "",
                     "id": "eff6523d-f7f3-4258-b534-7c2ad7b9d112",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "Write your haiku here, Three lines to paint a picture, Simplicity reigns.",
                     "id": "177764b7-4084-4aaa-aa39-145293b64201",
                     "config": {
                       "x": 36,
                       "y": 154.8,
                       "width": 220,
                       "height": 90.4,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": 1,
                     "defaultColor": "#00000019",
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 0,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "WilliamTextPro-Reg"
                       },
                       "fontSize": 13,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 13
                     }
                   }
                 ]
               }
             }
           ]
         },
         {
           "__typename": "EditorTemplate",
           "id": "3f92f9fa-282d-430c-af69-12395c1c8f60",
           "cover": "https://ucarecdn.com/1176244e-eafd-431a-b284-b6a33045718a/",
           "nameLocalized": "Handmade landscapes",
           "isAttached": false,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "b7cfced3-2591-4c66-86a8-6c9d0712221a",
               "cover": "https://ucarecdn.com/1176244e-eafd-431a-b284-b6a33045718a/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/16df555d-7366-497e-8c7b-9a474dbd5ab0/",
                     "type": 0,
                     "settings": {},
                     "textLocalized": "",
                     "id": "452ba7cb-da69-415c-8e5e-4964514fded3",
                     "config": {
                       "x": 0,
                       "y": 33.2,
                       "width": 300,
                       "height": 433.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/a3f0aec3-c495-4046-b238-3e43e4df74c2/",
                     "type": 0,
                     "settings": {},
                     "textLocalized": "",
                     "id": "b5af0baf-d46c-4636-8125-b8ef953eedc3",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 221.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/81053b22-e59b-4faa-a99f-f661f3f73890/",
                     "type": 1,
                     "settings": {},
                     "textLocalized": "",
                     "id": "3ef7609e-4401-4e1a-b2b2-0cf92c4d68ce",
                     "config": {
                       "x": 61.6,
                       "y": -38,
                       "width": 176.0779,
                       "height": 139.2,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "2ad48797-9803-4321-aa98-01034a13995a",
                         "name": "D1",
                         "cover": "https://ucarecdn.com/5e88fefc-6e6e-4484-a7c7-9f7de2bca451/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "df4b8f47-2234-492b-88de-d794e20f4152",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/56962e27-14d3-4e72-911a-29938cc3f8b0/",
                             "filterId": "2ad48797-9803-4321-aa98-01034a13995a"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/a8649de5-68fd-4937-a161-4669359bc746/",
                     "type": 1,
                     "settings": {},
                     "textLocalized": "",
                     "id": "58839d63-d4b5-47f1-84a2-f1b3474a1262",
                     "config": {
                       "x": 61.6,
                       "y": 130.8,
                       "width": 176.0779,
                       "height": 139.2,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "341684cf-51ad-4a8a-b1ab-b49b6595a9fc",
                         "name": "A3",
                         "cover": "https://ucarecdn.com/d58ae948-6506-45c7-9101-423624cf559a/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "13547441-4c00-460d-b3ca-f279198bad4b",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/6d73e11b-cccc-4920-b334-532fa2dd1558/",
                             "filterId": "341684cf-51ad-4a8a-b1ab-b49b6595a9fc"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/68d01cf2-584d-429f-9d54-48821191ad64/",
                     "type": 1,
                     "settings": {},
                     "textLocalized": "",
                     "id": "f57604b2-d791-4f6c-acea-0906a997dc3d",
                     "config": {
                       "x": 12.8,
                       "y": 299.6,
                       "width": 274.4,
                       "height": 83.2,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             }
           ]
         },
         {
           "__typename": "EditorTemplate",
           "id": "9340d455-e91f-43e3-b389-51e9a2b772bd",
           "cover": "https://ucarecdn.com/6267c5d5-63ab-4638-9024-2439e219bbfa/",
           "nameLocalized": "Challenge",
           "isAttached": false,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "ad839be2-383e-4f78-bc8d-6cb747814784",
               "cover": "https://ucarecdn.com/6267c5d5-63ab-4638-9024-2439e219bbfa/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/8bbf4e03-1e01-4495-9462-d7b2753cc47c/",
                     "type": 0,
                     "settings": {},
                     "textLocalized": "",
                     "id": "3698f1a5-33d2-4e3a-812e-f3b45d356ff1",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 509.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "e1c6d49d-ac8a-424e-bf02-a463e1910a17",
               "cover": null,
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/e880615c-a19b-45be-9002-74eecbd7e34b/",
                     "type": 1,
                     "settings": {
                       "placeholderUrl": "https://ucarecdn.com/e880615c-a19b-45be-9002-74eecbd7e34b/"
                     },
                     "textLocalized": "",
                     "id": "692e734f-8b39-471a-a1cc-60c355d50d51",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/fbcb0390-bb1f-4290-bbd3-1c3dba38c82c/",
                     "type": 1,
                     "settings": {
                       "placeholderUrl": "https://ucarecdn.com/fbcb0390-bb1f-4290-bbd3-1c3dba38c82c/"
                     },
                     "textLocalized": "",
                     "id": "48f80d74-cff2-467b-94d4-7074f1097df4",
                     "config": {
                       "x": 201.6,
                       "y": -47.6,
                       "width": 80,
                       "height": 80,
                       "zIndex": 2
                     },
                     "isMovable": true,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/36c853c9-1085-4c28-a06b-560839e7b5c1/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/36c853c9-1085-4c28-a06b-560839e7b5c1/"
                     },
                     "textLocalized": "",
                     "id": "73bbf85d-f34e-432f-ae75-d7874690586a",
                     "config": {
                       "x": 44,
                       "y": 170,
                       "width": 99.2,
                       "height": 135.2,
                       "zIndex": 3
                     },
                     "isMovable": true,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             }
           ]
         },
         {
           "__typename": "EditorTemplate",
           "id": "621af017-cfa1-4301-8278-ee62c9ff49d0",
           "cover": "https://ucarecdn.com/c52696be-8015-4151-9427-1aba729738e4/",
           "nameLocalized": "Grids on black",
           "isAttached": false,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "cdd6a8c4-90f7-45be-a985-c0a2cce93111",
               "cover": "https://ucarecdn.com/ed7abbe2-14ab-4552-813a-13abcc3f57a8/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/0cafa6f2-d9f3-4f0f-9349-c01aa767983d/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/0cafa6f2-d9f3-4f0f-9349-c01aa767983d/"
                     },
                     "textLocalized": "",
                     "id": "db05d2ea-fd83-4950-a21d-18ee33fe7b39",
                     "config": {
                       "x": -10.4,
                       "y": -68.4,
                       "width": 320,
                       "height": 536,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/d09d65b9-a68f-4173-b06b-53cf30416842/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/d09d65b9-a68f-4173-b06b-53cf30416842/"
                     },
                     "textLocalized": "",
                     "id": "0f472ad7-48ab-476d-baa2-38b8e7ea5a1f",
                     "config": {
                       "x": 0,
                       "y": -66,
                       "width": 300,
                       "height": 531.2,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/9a9d16da-4744-45dd-9805-f55d374a6503/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/9a9d16da-4744-45dd-9805-f55d374a6503/"
                     },
                     "textLocalized": "+",
                     "id": "ad55e09a-c5f0-49cb-bb87-0768a73f75c7",
                     "config": {
                       "x": 59.2,
                       "y": 46.8,
                       "width": 182.4,
                       "height": 248,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "Object description",
                     "id": "1a2263f5-d433-4050-8df4-d798db2aafb2",
                     "config": {
                       "x": 57.6,
                       "y": 320.4,
                       "width": 182.4,
                       "height": 40,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": 1,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "9a9106c8-0989-4e82-97b7-f21c9ae8827e",
               "cover": "https://ucarecdn.com/eee63488-54dd-4471-8e59-0765c053a3a0/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/ec56670d-501e-41b9-a2a9-c3e4f04d22f9/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/ec56670d-501e-41b9-a2a9-c3e4f04d22f9/"
                     },
                     "textLocalized": "+",
                     "id": "dbf7d89c-f006-4aa8-997f-1be8572c43d8",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/db09fb88-abcf-4b68-ba0c-d504c828d464/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/db09fb88-abcf-4b68-ba0c-d504c828d464/"
                     },
                     "textLocalized": "+",
                     "id": "d42ae9fb-b138-46f4-91e9-4abe9ff12c64",
                     "config": {
                       "x": 32.8,
                       "y": -6,
                       "width": 113.6,
                       "height": 114.4,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/5ef1b36e-8a0e-463e-92eb-608434fbafab/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/5ef1b36e-8a0e-463e-92eb-608434fbafab/"
                     },
                     "textLocalized": "+",
                     "id": "922767d4-9318-40b6-bbdd-30cb0c9f05f8",
                     "config": {
                       "x": 152.8,
                       "y": -6,
                       "width": 114.4,
                       "height": 114.4,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/6fc38cbd-a0d2-433a-8c0c-9c915a391d69/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/6fc38cbd-a0d2-433a-8c0c-9c915a391d69/"
                     },
                     "textLocalized": "",
                     "id": "39afbb16-3491-4d72-8392-00a097899615",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "01",
                     "id": "0f2d1c20-f83f-4aa3-b55c-f18e7b6a22ff",
                     "config": {
                       "x": 32.8,
                       "y": 93.2,
                       "width": 114.4,
                       "height": 40,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "02",
                     "id": "8d52a649-02c6-425e-8399-696422df136b",
                     "config": {
                       "x": 152.8,
                       "y": 93.2,
                       "width": 114.4,
                       "height": 40,
                       "zIndex": 6
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "1953235b-7845-4294-bee2-69b3a0966e35",
               "cover": "https://ucarecdn.com/9785b7ca-a056-4a84-a4f8-1fb720a7a702/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/b15b9562-bcee-4afb-87f3-a9ffa5dffa75/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/b15b9562-bcee-4afb-87f3-a9ffa5dffa75/"
                     },
                     "textLocalized": "",
                     "id": "8fbf1ae9-3710-4cc0-80c3-5ed53c71568a",
                     "config": {
                       "x": -10.4,
                       "y": -80.4,
                       "width": 320,
                       "height": 560,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/7377ed25-a5a5-4cbc-b9f5-d7ee4ff9ae62/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/7377ed25-a5a5-4cbc-b9f5-d7ee4ff9ae62/"
                     },
                     "textLocalized": "",
                     "id": "c075d2e3-8ea1-4e2c-8aad-aa0e2bfb5687",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/72d3390a-79b4-44c7-8654-1bf541d12921/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/72d3390a-79b4-44c7-8654-1bf541d12921/"
                     },
                     "textLocalized": "+",
                     "id": "2b02cb35-f1d7-49da-8571-873298cd65a0",
                     "config": {
                       "x": 102.4,
                       "y": 51.6,
                       "width": 96,
                       "height": 104,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/0f23a849-b48e-4760-a294-a82a1c3ce7a8/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/0f23a849-b48e-4760-a294-a82a1c3ce7a8/"
                     },
                     "textLocalized": "+",
                     "id": "85d222bd-b884-401f-85a6-6de7c088521d",
                     "config": {
                       "x": 102.4,
                       "y": 203.6,
                       "width": 96,
                       "height": 104,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "Object description",
                     "id": "39551271-a625-4751-9f9a-b51574c75fbf",
                     "config": {
                       "x": 70.4,
                       "y": 145.2,
                       "width": 160,
                       "height": 40,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "Object description",
                     "id": "021cd7fe-24c8-42ea-8196-d3926181e2c2",
                     "config": {
                       "x": 70.4,
                       "y": 297.2,
                       "width": 160,
                       "height": 40,
                       "zIndex": 6
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "af59dd10-3e83-446b-8367-e58a422a2dc4",
               "cover": "https://ucarecdn.com/ebd5865e-7058-4ac1-a9bd-adf48a9166e5/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/1e1c3355-c7e2-4368-ba56-206c79910cc8/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/1e1c3355-c7e2-4368-ba56-206c79910cc8/"
                     },
                     "textLocalized": "",
                     "id": "498c1591-7ca6-4c16-815c-6d8d2d3c26e1",
                     "config": {
                       "x": -10.4,
                       "y": -80.4,
                       "width": 320,
                       "height": 560,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/572ce74f-9873-46dc-9f46-06ff3ba1ce9d/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/572ce74f-9873-46dc-9f46-06ff3ba1ce9d/"
                     },
                     "textLocalized": "+",
                     "id": "fb7eb3bf-c2f5-4e37-98e3-e16824ac5f81",
                     "config": {
                       "x": 0,
                       "y": 51.6,
                       "width": 300,
                       "height": 412.8,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/e8ba4155-9995-4c60-beea-412f868cf02b/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/e8ba4155-9995-4c60-beea-412f868cf02b/"
                     },
                     "textLocalized": "",
                     "id": "0d77aa2b-2465-4ed6-bd39-a6596f710a71",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "Object description",
                     "id": "21ef2dc3-5f2a-4b11-a29f-1068bb9bba06",
                     "config": {
                       "x": 48.8,
                       "y": -18.8,
                       "width": 204,
                       "height": 40,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "6afc1466-cf7d-4711-98e5-f6a26e0c6358",
               "cover": "https://ucarecdn.com/5660a8e7-1fa0-42d6-ad71-323744a8ef7a/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/5190fe12-f36b-446e-b4a8-e4e0961fe8ec/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/5190fe12-f36b-446e-b4a8-e4e0961fe8ec/"
                     },
                     "textLocalized": "",
                     "id": "67c928d8-0791-45c6-8be2-ff2359c9332e",
                     "config": {
                       "x": -10.4,
                       "y": -80.4,
                       "width": 320,
                       "height": 560,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/d354f195-bc8d-47e6-8d82-3eca7a08c586/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/d354f195-bc8d-47e6-8d82-3eca7a08c586/"
                     },
                     "textLocalized": "+",
                     "id": "104ec2ba-bea7-406f-aec6-352f932d47cb",
                     "config": {
                       "x": 32.8,
                       "y": 20.4,
                       "width": 114.4,
                       "height": 152.8,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/de007d87-f3f2-4a66-b3e9-1a1d8ec86ad5/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/de007d87-f3f2-4a66-b3e9-1a1d8ec86ad5/"
                     },
                     "textLocalized": "+",
                     "id": "477aebd5-52e2-4b22-94be-b3585e946aab",
                     "config": {
                       "x": 152.8,
                       "y": 20.4,
                       "width": 114.4,
                       "height": 152.8,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/e07ce285-7bf9-4cbd-92aa-2d9916b455f5/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/e07ce285-7bf9-4cbd-92aa-2d9916b455f5/"
                     },
                     "textLocalized": "+",
                     "id": "430e8a98-87dc-4954-83f8-dde93d339ee7",
                     "config": {
                       "x": 32.8,
                       "y": 208.4,
                       "width": 114.4,
                       "height": 152.8,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/a4e5a56b-dec8-4673-9cde-fb142e4cfb56/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/a4e5a56b-dec8-4673-9cde-fb142e4cfb56/"
                     },
                     "textLocalized": "+",
                     "id": "a16ae43b-658d-4d86-8b7d-8fdf09af9a89",
                     "config": {
                       "x": 152.8,
                       "y": 208.4,
                       "width": 114.4,
                       "height": 152.8,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/65024b9e-3d2d-4644-a779-39858095e757/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/65024b9e-3d2d-4644-a779-39858095e757/"
                     },
                     "textLocalized": "",
                     "id": "9b23d352-ec62-4faa-ac15-a8f867c352e6",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 6
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "03",
                     "id": "dd091c44-5ec6-44bc-85f0-cfa5a7d62a96",
                     "config": {
                       "x": 32.8,
                       "y": 349.2,
                       "width": 114.4,
                       "height": 40,
                       "zIndex": 7
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "02",
                     "id": "9b5efc1d-0d59-421b-9cd1-84fdbb6bb52a",
                     "config": {
                       "x": 152.8,
                       "y": 161.2,
                       "width": 114.4,
                       "height": 40,
                       "zIndex": 8
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "01",
                     "id": "ca5d2738-74dc-4fe9-a07c-eabf35adfe60",
                     "config": {
                       "x": 32.8,
                       "y": 161.2,
                       "width": 114.4,
                       "height": 40,
                       "zIndex": 9
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {},
                     "textLocalized": "04",
                     "id": "52ff8cf7-0a7a-42b8-8801-5cae863db49c",
                     "config": {
                       "x": 152.8,
                       "y": 349.2,
                       "width": 114.4,
                       "height": 40,
                       "zIndex": 10
                     },
                     "isMovable": false,
                     "isText": true,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": {
                       "__typename": "EditorFontPreset",
                       "alignment": 1,
                       "editorFont": {
                         "__typename": "EditorFont",
                         "postScriptName": "GT Pressura Mono LC Regular"
                       },
                       "fontSize": 16,
                       "hasAllCaps": false,
                       "hasShadow": false,
                       "letterSpacing": 0,
                       "lineHeight": 16
                     }
                   }
                 ]
               }
             }
           ]
         },
         {
           "__typename": "EditorTemplate",
           "id": "d0054c28-7afa-40bc-88c2-de21cfa2266a",
           "cover": "https://ucarecdn.com/54ad52c2-3a4f-4102-9234-d78840e36eaf/",
           "nameLocalized": "Plastic collage",
           "isAttached": false,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "20033653-524e-488a-aac7-22407553c51a",
               "cover": "https://ucarecdn.com/aaa93580-e803-49e4-a7f0-f6d82a7da776/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/eee317b9-54b6-4928-a625-19395fb499e9/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/eee317b9-54b6-4928-a625-19395fb499e9/"
                     },
                     "textLocalized": "",
                     "id": "7358a4a5-8d0d-4b26-9f6f-67a5b7730f31",
                     "config": {
                       "x": -16,
                       "y": -94.8,
                       "width": 331.2,
                       "height": 588.8,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "a4409c21-c4ba-4303-a351-fe83150c1618",
                         "name": "7d2853e9-53d8-4502-a59c-f88e774e74ed filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "7d6d8bbb-c718-4b4e-b2fb-9494ff6f7ab9",
                             "index": 2,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/f2f93ae6-a0da-4cf2-bf8b-dcadb69b9caf/",
                             "filterId": "a4409c21-c4ba-4303-a351-fe83150c1618"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/af8c8ffd-6486-45ee-99e0-bebea1e7921e/"
                     },
                     "textLocalized": "+",
                     "id": "7d2853e9-53d8-4502-a59c-f88e774e74ed",
                     "config": {
                       "x": 45.6,
                       "y": 32.4,
                       "width": 217.6,
                       "height": 371.2,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/41121889-98e0-42d9-87fe-fc774f7a8d58/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/41121889-98e0-42d9-87fe-fc774f7a8d58/"
                     },
                     "textLocalized": "",
                     "id": "359ae8ee-9396-4d9e-891f-5ac0f01b4ef8",
                     "config": {
                       "x": 92.8,
                       "y": 18.8,
                       "width": 143.2,
                       "height": 59.2,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "fad39534-1f29-4ca5-b45f-65e357ea303a",
               "cover": "https://ucarecdn.com/80cfbb2c-69fd-4ca2-8368-b47c56ad62c7/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/5acc3bb2-2e20-44e5-9333-b519fab8ef34/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/5acc3bb2-2e20-44e5-9333-b519fab8ef34/"
                     },
                     "textLocalized": "+",
                     "id": "dd0adf71-af5f-463c-8fff-351bca163450",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 251.2,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/0b769dc3-f099-40c7-8133-8ffd740cb9df/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/0b769dc3-f099-40c7-8133-8ffd740cb9df/"
                     },
                     "textLocalized": "+",
                     "id": "b6532dac-f9d2-4012-867b-27e7cabed95d",
                     "config": {
                       "x": 0,
                       "y": 215.6,
                       "width": 300,
                       "height": 251.2,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/e62bf21a-74a7-400b-b5d6-9cf1fa4289db/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/e62bf21a-74a7-400b-b5d6-9cf1fa4289db/"
                     },
                     "textLocalized": "",
                     "id": "d05d9d3f-1070-4911-9692-5ef6e1bc77b3",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "cf1455d7-8e72-4a1d-8258-a29f6ebe2d3f",
               "cover": "https://ucarecdn.com/eba1ebe9-5e51-463f-bab1-525b32cbbb75/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/711eed18-c875-4803-82d4-9c62bbf58270/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/711eed18-c875-4803-82d4-9c62bbf58270/"
                     },
                     "textLocalized": "",
                     "id": "172b2edd-fb25-4f3e-a762-7e30011436cb",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "c4314a55-4326-4511-876c-84baac2b1b01",
                         "name": "79fdf1e8-db47-487d-bd75-3357f57b0630 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "92689550-cba9-4aa4-a41d-08bfe399a2e5",
                             "index": 2,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/c80463dd-ad31-4fc4-ac6c-b406a0c1dfae/",
                             "filterId": "c4314a55-4326-4511-876c-84baac2b1b01"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/07f9a3d3-bc55-4e5b-accf-ed228c21dfaf/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/07f9a3d3-bc55-4e5b-accf-ed228c21dfaf/"
                     },
                     "textLocalized": "+",
                     "id": "79fdf1e8-db47-487d-bd75-3357f57b0630",
                     "config": {
                       "x": 23.2,
                       "y": 88.4,
                       "width": 180.8,
                       "height": 337.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "ec15e02e-5c11-4b67-8e2c-76b2ed298b18",
                         "name": "28da00de-84f5-41f4-b381-b53bbfb84b98 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "04fcce1c-0857-453b-80c5-1d96190f543b",
                             "index": 2,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/be310d68-e5a3-4358-9935-2ad6026b7041/",
                             "filterId": "ec15e02e-5c11-4b67-8e2c-76b2ed298b18"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/8657aad9-a727-48e4-a310-8c7ae475967a/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/8657aad9-a727-48e4-a310-8c7ae475967a/"
                     },
                     "textLocalized": "+",
                     "id": "28da00de-84f5-41f4-b381-b53bbfb84b98",
                     "config": {
                       "x": 100,
                       "y": -13.2,
                       "width": 180.8,
                       "height": 337.6,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/b3145a9c-9ee6-4f03-8fcb-a527a2605e95/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/b3145a9c-9ee6-4f03-8fcb-a527a2605e95/"
                     },
                     "textLocalized": "",
                     "id": "60d482f1-fade-4547-8c3c-1bf93b38a7fd",
                     "config": {
                       "x": 4.8,
                       "y": 358,
                       "width": 124.8,
                       "height": 90.4,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/5f149298-6ef4-416d-a56c-33243600c5ca/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/5f149298-6ef4-416d-a56c-33243600c5ca/"
                     },
                     "textLocalized": "",
                     "id": "c2259cae-c1bf-45ac-b4e6-e12109bb7eee",
                     "config": {
                       "x": 138.4,
                       "y": -29.2,
                       "width": 126.4,
                       "height": 31.2,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "f1d46e10-6845-49d7-b1c9-f602a11a3739",
               "cover": "https://ucarecdn.com/758e56cd-7000-4c91-bfa8-0a2bb22b312b/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/5c7b835f-7159-4a6e-959c-c2149862090d/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/5c7b835f-7159-4a6e-959c-c2149862090d/"
                     },
                     "textLocalized": "+",
                     "id": "574dbb08-a4ac-4726-9429-404cfd2cfb30",
                     "config": {
                       "x": 45.6,
                       "y": -66.8,
                       "width": 254.4,
                       "height": 533.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/2c4aac67-eaa8-43d0-b407-db4525b9f956/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/2c4aac67-eaa8-43d0-b407-db4525b9f956/"
                     },
                     "textLocalized": "",
                     "id": "4cbcd3eb-a38a-4dd9-ab33-580e2073b1a8",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "b5e707d9-7146-48a1-ae72-6fb23509a334",
               "cover": "https://ucarecdn.com/4d6fd45f-b0e9-468a-a5aa-309a3706c516/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/31d68263-c775-418b-812b-a4e7e75800f7/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/31d68263-c775-418b-812b-a4e7e75800f7/"
                     },
                     "textLocalized": "",
                     "id": "2b2ca19b-8c68-494d-bc32-c3df3503ecde",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "f1453f57-9f0f-4636-89aa-cf98167c676e",
                         "name": "7547d853-8e81-4b83-a0de-7230281dddc8 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "7a6441aa-7134-4d59-adac-a3d5b1639460",
                             "index": 2,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/b26e8f61-39c0-445e-b2dc-75b9ff5250f4/",
                             "filterId": "f1453f57-9f0f-4636-89aa-cf98167c676e"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/23619ba8-c10d-4093-bce9-4ca9749e096e/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/23619ba8-c10d-4093-bce9-4ca9749e096e/"
                     },
                     "textLocalized": "+",
                     "id": "7547d853-8e81-4b83-a0de-7230281dddc8",
                     "config": {
                       "x": 24.8,
                       "y": -33.2,
                       "width": 204,
                       "height": 388,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/973a4289-38be-471c-980f-742da4e51413/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/973a4289-38be-471c-980f-742da4e51413/"
                     },
                     "textLocalized": "",
                     "id": "e236ebd6-ee40-4154-b5c8-6be1213ba82b",
                     "config": {
                       "x": 0,
                       "y": -66.8,
                       "width": 300,
                       "height": 533.6,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "f7cb3981-482a-45eb-b3ea-4903949dda7d",
                         "name": "09e5a7e7-4b3f-405c-a747-13674198d99a filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "95cde66b-0c74-440c-8709-91577b6162c7",
                             "index": 2,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/79fdbb87-a083-4d74-8323-12c63ad6de1f/",
                             "filterId": "f7cb3981-482a-45eb-b3ea-4903949dda7d"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/0f39100b-fd9b-4535-8628-d856db4cadca/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/0f39100b-fd9b-4535-8628-d856db4cadca/"
                     },
                     "textLocalized": "+",
                     "id": "09e5a7e7-4b3f-405c-a747-13674198d99a",
                     "config": {
                       "x": 85.6,
                       "y": 135.6,
                       "width": 214.4,
                       "height": 301.6,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             }
           ]
         },
         {
           "__typename": "EditorTemplate",
           "id": "eecbb1c7-69e1-4f4c-ba15-4f19f94302c9",
           "cover": "https://ucarecdn.com/489d3c9f-6af6-4958-95be-6e192d5970ac/",
           "nameLocalized": "Typology with Bernd and Hilla Becher",
           "isAttached": false,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "5c52d6d6-8534-4eb1-acb5-2a6373251444",
               "cover": "https://ucarecdn.com/ba2f0476-0682-43bb-8bb4-be509d395407/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/b4cebf27-4c08-4aea-8ac5-758575b4320f/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/b4cebf27-4c08-4aea-8ac5-758575b4320f/"
                     },
                     "textLocalized": "",
                     "id": "db3f8902-d5fb-4978-83ed-34c36c8d93c1",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 600,
                       "height": 1299.2,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/c98911b2-67df-4aae-8e57-def7faf891aa/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/c98911b2-67df-4aae-8e57-def7faf891aa/"
                     },
                     "textLocalized": "Add media",
                     "id": "bfe8f66f-b43d-441c-adc2-fc1a335013f2",
                     "config": {
                       "x": 17.6,
                       "y": -37.2,
                       "width": 128,
                       "height": 148,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51",
                         "name": "BW2",
                         "cover": "https://ucarecdn.com/1114f094-2cbe-4af9-b10c-e8f63f3d2ce2/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "ccb1ab3f-3f2d-4f72-9719-1b02b94bf6ec",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/3b79d83d-fdf1-41fe-8aef-3d96ac129fc3/",
                             "filterId": "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/7f03ce54-eb60-40b6-83ed-5502b509ad82/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/7f03ce54-eb60-40b6-83ed-5502b509ad82/"
                     },
                     "textLocalized": "Add media",
                     "id": "43f5005a-095b-4820-8da9-411506b3540a",
                     "config": {
                       "x": 154.4,
                       "y": -37.6,
                       "width": 128,
                       "height": 148,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/a152c528-ee9c-4de5-bf0f-2916a1439af9/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/a152c528-ee9c-4de5-bf0f-2916a1439af9/"
                     },
                     "textLocalized": "Add media",
                     "id": "4ab294c1-8e0e-45b2-8e11-19ceb979994b",
                     "config": {
                       "x": 18.4,
                       "y": 117.6,
                       "width": 128,
                       "height": 148,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/4990ac9b-c4a1-4e25-8ad6-4f8b9ab5e718/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/4990ac9b-c4a1-4e25-8ad6-4f8b9ab5e718/"
                     },
                     "textLocalized": "Add media",
                     "id": "4c7ae02e-73b1-4048-8bb9-a6bd2c0a7ab6",
                     "config": {
                       "x": 154.4,
                       "y": 117.6,
                       "width": 128,
                       "height": 148,
                       "zIndex": 6
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/92cb3695-63b4-4acc-a544-4183a031565e/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/92cb3695-63b4-4acc-a544-4183a031565e/"
                     },
                     "textLocalized": "Add media",
                     "id": "de0a3d0f-7a42-49b7-8493-f1cebd204fe2",
                     "config": {
                       "x": 18.4,
                       "y": 272.8,
                       "width": 128,
                       "height": 148,
                       "zIndex": 7
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/73a6ae31-c192-44d2-aef2-f51b6bb9986b/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/73a6ae31-c192-44d2-aef2-f51b6bb9986b/"
                     },
                     "textLocalized": "Add media",
                     "id": "505cbae0-8760-4d15-992a-9dafb3d7a56a",
                     "config": {
                       "x": 154.4,
                       "y": 272.8,
                       "width": 128,
                       "height": 148,
                       "zIndex": 8
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "d1e21cc5-d8e2-4407-9561-7fe34144c7de",
               "cover": "https://ucarecdn.com/099bab1a-0e89-4f5c-97c4-a16e927ed3b2/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/b4cebf27-4c08-4aea-8ac5-758575b4320f/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/b4cebf27-4c08-4aea-8ac5-758575b4320f/"
                     },
                     "textLocalized": "",
                     "id": "1e559e5f-f904-4e77-9e0b-414fdb2679b2",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 600,
                       "height": 1299.2,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/c98911b2-67df-4aae-8e57-def7faf891aa/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/c98911b2-67df-4aae-8e57-def7faf891aa/"
                     },
                     "textLocalized": "Add media",
                     "id": "bb6b5141-cacd-4e42-a273-638fe0cb1f54",
                     "config": {
                       "x": 18.4,
                       "y": 16.8,
                       "width": 128,
                       "height": 179.2,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/7f03ce54-eb60-40b6-83ed-5502b509ad82/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/7f03ce54-eb60-40b6-83ed-5502b509ad82/"
                     },
                     "textLocalized": "Add media",
                     "id": "ae3beffd-c2e9-4f7d-8619-959ff991ff7f",
                     "config": {
                       "x": 154.4,
                       "y": 16.8,
                       "width": 128,
                       "height": 179.2,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/a152c528-ee9c-4de5-bf0f-2916a1439af9/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/a152c528-ee9c-4de5-bf0f-2916a1439af9/"
                     },
                     "textLocalized": "Add media",
                     "id": "e631a23d-4334-487d-b751-d97267b34a1e",
                     "config": {
                       "x": 18.4,
                       "y": 204,
                       "width": 128,
                       "height": 179.2,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/4990ac9b-c4a1-4e25-8ad6-4f8b9ab5e718/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/4990ac9b-c4a1-4e25-8ad6-4f8b9ab5e718/"
                     },
                     "textLocalized": "Add media",
                     "id": "18383fbb-04b0-4922-9dea-1da3ca5d3044",
                     "config": {
                       "x": 154.4,
                       "y": 204,
                       "width": 128,
                       "height": 179.2,
                       "zIndex": 6
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "707f0f2b-b4b1-443c-8c32-998f35cb8291",
               "cover": "https://ucarecdn.com/973c6f66-9b6b-479d-bd17-a4a8d30d0289/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/6151faa9-319e-45fe-9501-531f35372fa8/",
                     "type": 0,
                     "settings": {
                       "undefined": "https://ucarecdn.com/6151faa9-319e-45fe-9501-531f35372fa8/"
                     },
                     "textLocalized": "",
                     "id": "366f33b7-618e-4c89-b68b-a4b35602c5be",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 600,
                       "height": 1299.2,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/c62f3527-6238-4ce7-a83c-45164f6ded0c/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/c62f3527-6238-4ce7-a83c-45164f6ded0c/"
                     },
                     "textLocalized": "add media",
                     "id": "dec26674-ef3b-40e3-a980-02a1e5f3a891",
                     "config": {
                       "x": 20,
                       "y": -49.6,
                       "width": 260.8,
                       "height": 161.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/94477e6f-2196-475d-a291-e98a500edfc5/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/94477e6f-2196-475d-a291-e98a500edfc5/"
                     },
                     "textLocalized": "text en",
                     "id": "d0b365f2-63aa-4d92-a179-3c6c03438713",
                     "config": {
                       "x": 20,
                       "y": 119.2,
                       "width": 260.8,
                       "height": 161.6,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/3e7914d0-a6b1-4980-af1c-6b1209e837ad/",
                     "type": 1,
                     "settings": {
                       "undefined": "https://ucarecdn.com/3e7914d0-a6b1-4980-af1c-6b1209e837ad/"
                     },
                     "textLocalized": "text en",
                     "id": "7dd71c62-79d8-4fee-98a1-eb51bd741a66",
                     "config": {
                       "x": 20,
                       "y": 288,
                       "width": 260.8,
                       "height": 161.6,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             }
           ]
         },
         {
           "__typename": "EditorTemplate",
           "id": "d92b76db-7205-420b-b545-f437bfa04063",
           "cover": "https://ucarecdn.com/5706e243-30b5-432f-b26d-aa1a53bfa751/",
           "nameLocalized": "Torn Paper",
           "isAttached": false,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "58284334-d4db-489f-ab16-c72f1c4ef77d",
               "cover": "https://ucarecdn.com/d08a7353-4442-4329-9ae3-20d698db870d/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/48a14529-2a81-4f58-925b-df3dbd10be11/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/48a14529-2a81-4f58-925b-df3dbd10be11/"
                     },
                     "textLocalized": "",
                     "id": "268d17e2-d6b4-4859-b665-82da669800e5",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51",
                         "name": "BW2",
                         "cover": "https://ucarecdn.com/1114f094-2cbe-4af9-b10c-e8f63f3d2ce2/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "ccb1ab3f-3f2d-4f72-9719-1b02b94bf6ec",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/3b79d83d-fdf1-41fe-8aef-3d96ac129fc3/",
                             "filterId": "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51"
                           }
                         ]
                       },
                       {
                         "__typename": "EditorFilter",
                         "id": "cd8cd04e-1ba2-4d2e-a3e9-4b6c48cdbffe",
                         "name": "66414488-6efe-4d44-af31-7b25a88830d4 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "a7611c22-5fe6-406a-82e0-be2fce38d42c",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/50712127-6eea-4de3-a9e7-19f2feca80dd/",
                             "filterId": "cd8cd04e-1ba2-4d2e-a3e9-4b6c48cdbffe"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/50712127-6eea-4de3-a9e7-19f2feca80dd/"
                     },
                     "textLocalized": "+",
                     "id": "66414488-6efe-4d44-af31-7b25a88830d4",
                     "config": {
                       "x": 55.2,
                       "y": -40,
                       "width": 187.904,
                       "height": 479.776,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "91114546-d18e-4540-934b-34b513dfcdd0",
                         "name": "f108c06c-e0c4-48e0-b055-e738d2036b78 filter",
                         "cover": null,
                         "stepsFull": []
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/cb783e32-9e6f-44c6-82cf-6ad59b005597/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/cb783e32-9e6f-44c6-82cf-6ad59b005597/"
                     },
                     "textLocalized": "",
                     "id": "f108c06c-e0c4-48e0-b055-e738d2036b78",
                     "config": {
                       "x": 55.2,
                       "y": -40,
                       "width": 187.904,
                       "height": 479.776,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "4ecf8f66-4943-45b4-a51d-2d952f01edfd",
               "cover": "https://ucarecdn.com/5753f952-b71c-47d5-9271-ce7049ff66ca/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/f22e1052-e536-409a-983b-189e10b89aef/"
                     },
                     "textLocalized": "+",
                     "id": "6f9fe019-a223-4d34-b307-aa20a0ca6435",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 252,
                       "height": 240.8,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/86932ce0-5756-4d4b-b58a-6ce1f4f5dcb9/"
                     },
                     "textLocalized": "+",
                     "id": "6111ec75-e75c-4e35-bee0-ae190ebda5db",
                     "config": {
                       "x": 0,
                       "y": 125.6,
                       "width": 300,
                       "height": 181.6,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "01ec2e9e-c6c3-4ee9-914f-9be1f5dad7a1",
                         "name": "cff860bc-c7bd-4d06-9dee-21f8d3f90257 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "6adc67b8-2577-4f68-8d97-3ff7583f5d5d",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/5f5c0368-2f49-4b0d-b3ce-d87a89265c0c/",
                             "filterId": "01ec2e9e-c6c3-4ee9-914f-9be1f5dad7a1"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/5f5c0368-2f49-4b0d-b3ce-d87a89265c0c/"
                     },
                     "textLocalized": "+",
                     "id": "cff860bc-c7bd-4d06-9dee-21f8d3f90257",
                     "config": {
                       "x": 40,
                       "y": 322.4,
                       "width": 260,
                       "height": 202.4,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/b3867fbe-133a-4dd0-ba42-6fee245888bf/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/b3867fbe-133a-4dd0-ba42-6fee245888bf/"
                     },
                     "textLocalized": "",
                     "id": "93c464b8-5d3c-4566-a761-eefdfdee638d",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "07f5cd93-991e-4595-9105-7fb9b28f72b1",
               "cover": "https://ucarecdn.com/3347a7e8-8d12-4919-9059-6e1547e5c20a/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51",
                         "name": "BW2",
                         "cover": "https://ucarecdn.com/1114f094-2cbe-4af9-b10c-e8f63f3d2ce2/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "ccb1ab3f-3f2d-4f72-9719-1b02b94bf6ec",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/3b79d83d-fdf1-41fe-8aef-3d96ac129fc3/",
                             "filterId": "ab643ed0-06e4-4216-9ec5-3f78ebfdaf51"
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
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/2f658708-3dda-41e1-b357-8594b59d1f9e/"
                     },
                     "textLocalized": "+",
                     "id": "ead41cd8-5e75-4e1f-89ea-2f313a9db1fd",
                     "config": {
                       "x": 0,
                       "y": 169.6,
                       "width": 300,
                       "height": 354.4,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "7cf7d55b-11ce-4171-b095-6bab25be8c97",
                         "name": "04ac0c0c-fced-4b93-9100-fdcb62ab8214 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "4450bba4-2112-46d6-9bc5-75debdcd4e5f",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/a2f6489e-0491-4bd0-90fc-781de2fc87a3/",
                             "filterId": "7cf7d55b-11ce-4171-b095-6bab25be8c97"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/a2f6489e-0491-4bd0-90fc-781de2fc87a3/"
                     },
                     "textLocalized": "+",
                     "id": "04ac0c0c-fced-4b93-9100-fdcb62ab8214",
                     "config": {
                       "x": 0,
                       "y": -124,
                       "width": 300.8,
                       "height": 320,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/4a1ac418-fb26-43fa-8fa7-4d7f4ee60f9a/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/4a1ac418-fb26-43fa-8fa7-4d7f4ee60f9a/"
                     },
                     "textLocalized": "",
                     "id": "2d3c85ca-5a71-477f-8e29-3656e3b1cd4e",
                     "config": {
                       "x": -24.8,
                       "y": 160.8,
                       "width": 324.8,
                       "height": 48,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "7abb5c1c-b239-4942-b7c5-5ee461f18368",
               "cover": "https://ucarecdn.com/efa928f3-1976-4ea2-8c28-d5b7bfd4f674/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/5403f11e-0080-4cc1-9a09-17c3b4e1e70d/"
                     },
                     "textLocalized": "+",
                     "id": "ebbfdee6-6f8c-4848-8c74-4979f06af208",
                     "config": {
                       "x": 0,
                       "y": -34.4,
                       "width": 300,
                       "height": 468.8,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/8446d25e-165b-42c8-b9f7-13653b4bda7a/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/8446d25e-165b-42c8-b9f7-13653b4bda7a/"
                     },
                     "textLocalized": "",
                     "id": "99fdb423-093a-4e9d-bfbb-3715f6d92474",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "d5a90011-2366-47ec-a440-0ba2912c0cef",
                         "name": "BW1",
                         "cover": "https://ucarecdn.com/351aab23-495c-44c6-9c35-3e0951e742a7/",
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59161882-cd23-4f01-af76-ff30a37de082",
                             "index": 1,
                             "type": "lut",
                             "settings": {},
                             "url": "https://ucarecdn.com/65800a48-ae7d-4933-aa5e-4acc200afe59/",
                             "filterId": "d5a90011-2366-47ec-a440-0ba2912c0cef"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/9d939310-b32f-4132-a846-295df5e5b269/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/9d939310-b32f-4132-a846-295df5e5b269/"
                     },
                     "textLocalized": "",
                     "id": "c1f1c0f6-fbf0-4bce-86a3-863b55ecab92",
                     "config": {
                       "x": -0.8,
                       "y": -24,
                       "width": 300.8,
                       "height": 448,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             }
           ]
         },
         {
           "__typename": "EditorTemplate",
           "id": "da45ebc7-2bd6-47af-b1a0-7d02cbb538b5",
           "cover": "https://ucarecdn.com/d397b5dd-fdd3-4ff3-be52-9e780592d48f/",
           "nameLocalized": "Simple Geometry",
           "isAttached": false,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "9578fc1f-835a-4bb6-b5a9-e6aa2f792e1f",
               "cover": "https://ucarecdn.com/34f0d1e7-3315-4b6f-a187-fae327ae62df/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "22614105-7713-44bc-9a94-120bab7c6c6e",
                         "name": "4e2bdc0e-d30c-468a-81c3-7a7a4884ce27 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "8e7eb56e-2f60-4ad7-bb06-e3121ac3da4c",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/9ad9c10d-fe06-49db-b80b-65b95c1a551b/",
                             "filterId": "22614105-7713-44bc-9a94-120bab7c6c6e"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/9ad9c10d-fe06-49db-b80b-65b95c1a551b/"
                     },
                     "textLocalized": "+",
                     "id": "4e2bdc0e-d30c-468a-81c3-7a7a4884ce27",
                     "config": {
                       "x": 20,
                       "y": 34.4,
                       "width": 95.2,
                       "height": 330.4,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "634c0a96-7b86-489c-88ed-9cccdccd1100",
                         "name": "eb24c6a0-5ca2-4461-af48-bb0cdefa1a42 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "5424f00d-7fda-4d14-9d8a-10b1da39c4a3",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/6e200f05-3d98-4838-96e9-d15139f4dc11/",
                             "filterId": "634c0a96-7b86-489c-88ed-9cccdccd1100"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/6e200f05-3d98-4838-96e9-d15139f4dc11/"
                     },
                     "textLocalized": "+",
                     "id": "eb24c6a0-5ca2-4461-af48-bb0cdefa1a42",
                     "config": {
                       "x": 116,
                       "y": 34.4,
                       "width": 165.6,
                       "height": 330.4,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/37a592a1-acc5-4024-bd82-99f29379fa98/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/37a592a1-acc5-4024-bd82-99f29379fa98/"
                     },
                     "textLocalized": "",
                     "id": "4fda6d75-a331-474e-bac5-2601932f41f0",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "b28baf19-191b-43d9-b7c1-9991e901b9bd",
               "cover": "https://ucarecdn.com/79380fe3-8628-436c-8f03-f4e6788e24ec/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "bc6187b1-db4d-488e-b850-ced2bf996d81",
                         "name": "f2c77298-5246-4697-a4e7-2bc7a2e91e1e filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "7716d7a5-2453-4559-93c2-9eafb4cab3eb",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/a2516426-6bfe-4458-8365-2708e7c00064/",
                             "filterId": "bc6187b1-db4d-488e-b850-ced2bf996d81"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/a2516426-6bfe-4458-8365-2708e7c00064/"
                     },
                     "textLocalized": "+",
                     "id": "f2c77298-5246-4697-a4e7-2bc7a2e91e1e",
                     "config": {
                       "x": 34.576,
                       "y": 2.184,
                       "width": 229.408,
                       "height": 390.08,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/d1a761a0-287e-47ef-9cf0-56aad7c9237d/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/d1a761a0-287e-47ef-9cf0-56aad7c9237d/"
                     },
                     "textLocalized": "",
                     "id": "2f62e569-ee49-46bb-8f3c-2da2bce984f8",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "398a5528-d9e1-4b73-b8dc-5ad4756493c5",
               "cover": "https://ucarecdn.com/e7c9b075-9452-4902-8eeb-457cdeaeae96/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "6eb5df5d-19f7-4e33-9042-02558d3c0fa9",
                         "name": "aeb74076-173f-40a7-9d5b-6e187308e716 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "00bc9912-c9aa-4f50-afe1-a1d21526a148",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/58248f91-3634-4c50-a2a7-ca382a493b82/",
                             "filterId": "6eb5df5d-19f7-4e33-9042-02558d3c0fa9"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/58248f91-3634-4c50-a2a7-ca382a493b82/"
                     },
                     "textLocalized": "+",
                     "id": "aeb74076-173f-40a7-9d5b-6e187308e716",
                     "config": {
                       "x": 27.2,
                       "y": 77.6,
                       "width": 244.8,
                       "height": 244.8,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/0d3a943b-aa5a-4d8b-8db1-edffb45703bf/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/0d3a943b-aa5a-4d8b-8db1-edffb45703bf/"
                     },
                     "textLocalized": "",
                     "id": "ee368a41-15f5-4752-9b9b-aaa18a501d4f",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "e33e0591-4384-44c7-abaa-167afaa9c336",
               "cover": "https://ucarecdn.com/c9856135-3217-4e5c-bf7a-a8ba187228a9/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "0d959bfe-9bbc-4190-b639-84425aac5369",
                         "name": "1b0d323e-c381-4a1d-a6cb-b50250b68015 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "317cadbc-157c-4f67-9d7d-e4f1f8a9b470",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/6aab23ce-a798-4771-b095-b1261efca8c2/",
                             "filterId": "0d959bfe-9bbc-4190-b639-84425aac5369"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/6aab23ce-a798-4771-b095-b1261efca8c2/"
                     },
                     "textLocalized": "+",
                     "id": "1b0d323e-c381-4a1d-a6cb-b50250b68015",
                     "config": {
                       "x": 28,
                       "y": -24,
                       "width": 244.248,
                       "height": 446.008,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/5e1d8dc2-88da-48da-81c9-95b6ecaed74c/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/5e1d8dc2-88da-48da-81c9-95b6ecaed74c/"
                     },
                     "textLocalized": "",
                     "id": "e9aa0e1d-b136-4b2b-989c-49570bc51543",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "279c842e-5f93-4a64-bda6-fa322492cf8a",
               "cover": "https://ucarecdn.com/05a7a8b0-e3f8-46c7-ad54-7fa31dc778d4/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "64285e7b-2051-4ded-9459-ce60c3256f84",
                         "name": "5a469906-c3fd-460d-8648-220f23bdc6eb filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "d9a72b12-0499-47a3-88f5-8e5b93476f86",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/55cb5edc-53b6-4d62-ab01-e12744b654be/",
                             "filterId": "64285e7b-2051-4ded-9459-ce60c3256f84"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": null,
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/55cb5edc-53b6-4d62-ab01-e12744b654be/"
                     },
                     "textLocalized": "+",
                     "id": "5a469906-c3fd-460d-8648-220f23bdc6eb",
                     "config": {
                       "x": 28,
                       "y": 17.6,
                       "width": 244,
                       "height": 364,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/9aa0839c-ca1d-4d8a-8821-c6b0d597ed5d/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/9aa0839c-ca1d-4d8a-8821-c6b0d597ed5d/"
                     },
                     "textLocalized": "",
                     "id": "452decb4-d762-4d21-89c1-c0e16b308f53",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             }
           ]
         },
         {
           "__typename": "EditorTemplate",
           "id": "b2bd28f7-df1e-4196-8ed7-f1defd4f28bd",
           "cover": "https://ucarecdn.com/065f59ba-238f-4758-be4c-2db9efccf7e0/",
           "nameLocalized": "Photo Archive",
           "isAttached": false,
           "variants": [
             {
               "__typename": "EditorTemplateVariant",
               "id": "b0252bed-5bb3-4db7-8787-4b0acdb98732",
               "cover": "https://ucarecdn.com/5cb4bdd3-e372-41a4-b560-03d9ddc916c8/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/c3aa2d30-d549-41a7-809e-9186179518cc/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/c3aa2d30-d549-41a7-809e-9186179518cc/"
                     },
                     "textLocalized": "",
                     "id": "23d1f7e7-189e-4355-bf37-f636eb7cf8ad",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "c44c6edf-a23d-48fe-87b7-5460c536c344",
                         "name": "14cdb1d5-be54-446a-aac3-926af810248e filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "dead057e-f12a-419c-aba4-608a19c7e3e9",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/92a4ce1e-2dbc-4f56-8aad-fea505340245/",
                             "filterId": "c44c6edf-a23d-48fe-87b7-5460c536c344"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/60fffa1a-d616-4f4b-a763-3234c3010072/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/92a4ce1e-2dbc-4f56-8aad-fea505340245/",
                       "placeholderUrl": "https://ucarecdn.com/60fffa1a-d616-4f4b-a763-3234c3010072/"
                     },
                     "textLocalized": "Pic 1",
                     "id": "14cdb1d5-be54-446a-aac3-926af810248e",
                     "config": {
                       "x": 15.544,
                       "y": 34.76,
                       "width": 84,
                       "height": 105.6,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "8944aacf-2f87-4b7c-a808-cde4107b1615",
                         "name": "17f7323b-e324-46cd-914a-df378a9cffa1 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "31cc6080-abbb-4ea2-b195-0315cbd6b046",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/b1ec5f1a-e048-4a39-aa54-742f0ee55b50/",
                             "filterId": "8944aacf-2f87-4b7c-a808-cde4107b1615"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/8efd97dc-1f76-4862-a696-39df084b8f50/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/b1ec5f1a-e048-4a39-aa54-742f0ee55b50/",
                       "placeholderUrl": "https://ucarecdn.com/8efd97dc-1f76-4862-a696-39df084b8f50/"
                     },
                     "textLocalized": "Pic 2",
                     "id": "17f7323b-e324-46cd-914a-df378a9cffa1",
                     "config": {
                       "x": 106.296,
                       "y": 28.8,
                       "width": 85.6,
                       "height": 105.6,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "752bb6c6-c083-4a44-ad81-1a4b7d17815a",
                         "name": "288eeeb3-f35c-4fa7-a446-eea548b9dd24 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "1bb480b8-eb70-444e-95ce-df4ad88381b3",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/8f141cdf-9e5c-4e10-9594-72ad55db2b96/",
                             "filterId": "752bb6c6-c083-4a44-ad81-1a4b7d17815a"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/38282454-d9d1-45dc-86f3-ddcff3a6ba8b/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/8f141cdf-9e5c-4e10-9594-72ad55db2b96/",
                       "placeholderUrl": "https://ucarecdn.com/38282454-d9d1-45dc-86f3-ddcff3a6ba8b/"
                     },
                     "textLocalized": "Pic 3",
                     "id": "288eeeb3-f35c-4fa7-a446-eea548b9dd24",
                     "config": {
                       "x": 198.744,
                       "y": 34.76,
                       "width": 84,
                       "height": 105.6,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "ee885ddc-5fb7-4ce5-9733-bbfc29abdac7",
                         "name": "60662e54-9ad2-4558-bedb-3e8af607f14e filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "6c230d0a-a747-4f47-a37f-c9c05f40e78b",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/fd3bacef-78d2-4464-b761-8ec95376cd92/",
                             "filterId": "ee885ddc-5fb7-4ce5-9733-bbfc29abdac7"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/07fdfe97-d0d0-40b7-b0c1-070868db0e41/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/fd3bacef-78d2-4464-b761-8ec95376cd92/",
                       "placeholderUrl": "https://ucarecdn.com/07fdfe97-d0d0-40b7-b0c1-070868db0e41/"
                     },
                     "textLocalized": "Pic 4",
                     "id": "60662e54-9ad2-4558-bedb-3e8af607f14e",
                     "config": {
                       "x": 15.096,
                       "y": 150.328,
                       "width": 85.6,
                       "height": 106.4,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "b0c61c2d-fb0b-4b95-ab50-622e225e7f5c",
                         "name": "64afcde9-1cdc-4b4f-a16b-2f692aa91a3e filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "d1d608df-f385-4814-8e1a-2590eecc393f",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/1e4de6db-b893-42af-8ac6-c20747541463/",
                             "filterId": "b0c61c2d-fb0b-4b95-ab50-622e225e7f5c"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/8d032804-e588-4b53-8715-ce157fe809e7/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/1e4de6db-b893-42af-8ac6-c20747541463/",
                       "placeholderUrl": "https://ucarecdn.com/8d032804-e588-4b53-8715-ce157fe809e7/"
                     },
                     "textLocalized": "Pic 5",
                     "id": "64afcde9-1cdc-4b4f-a16b-2f692aa91a3e",
                     "config": {
                       "x": 106.296,
                       "y": 144.72,
                       "width": 85.6,
                       "height": 106.4,
                       "zIndex": 6
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "5248a6e6-063c-47d8-ad80-0347fbe5fa55",
                         "name": "e8bbf647-07f9-4d2f-801e-9730f77d6005 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "299fcf2e-f23c-41f6-b41e-14a668ca3eb6",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/d555ff29-0560-4ddb-8e52-f7e2ac6a79a1/",
                             "filterId": "5248a6e6-063c-47d8-ad80-0347fbe5fa55"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/9c53f2c9-b3fc-4c56-b9e7-6b0a0a04776a/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/d555ff29-0560-4ddb-8e52-f7e2ac6a79a1/",
                       "placeholderUrl": "https://ucarecdn.com/9c53f2c9-b3fc-4c56-b9e7-6b0a0a04776a/"
                     },
                     "textLocalized": "Pic 6",
                     "id": "e8bbf647-07f9-4d2f-801e-9730f77d6005",
                     "config": {
                       "x": 198.744,
                       "y": 150.68,
                       "width": 84,
                       "height": 105.6,
                       "zIndex": 7
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "0a6f689c-ae2f-416d-8acb-9dc3c065b352",
                         "name": "5c62f259-4947-478b-9ddd-a60c79e5e9f7 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "426839d5-60fb-4050-925c-88309e5fc88f",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/d402bbd6-63df-459f-95dd-05cb3daa0c8c/",
                             "filterId": "0a6f689c-ae2f-416d-8acb-9dc3c065b352"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/bb021b34-7f4c-4043-91d1-acc033f16aa1/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/d402bbd6-63df-459f-95dd-05cb3daa0c8c/",
                       "placeholderUrl": "https://ucarecdn.com/bb021b34-7f4c-4043-91d1-acc033f16aa1/"
                     },
                     "textLocalized": "Pic 7",
                     "id": "5c62f259-4947-478b-9ddd-a60c79e5e9f7",
                     "config": {
                       "x": 15.096,
                       "y": 266.328,
                       "width": 84.8,
                       "height": 106.4,
                       "zIndex": 8
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "16d23e41-8ff4-4302-bb2e-d08a4886c5d8",
                         "name": "c9eea0ee-c91e-4f7f-86f0-0d8961772f29 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "1cd83745-39e6-4b4e-bf76-edd8c05302cb",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/d017d62f-04a2-48b9-a256-a77df267f5f2/",
                             "filterId": "16d23e41-8ff4-4302-bb2e-d08a4886c5d8"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/8c809ddb-0010-437a-9b09-9a66cdf26f10/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/d017d62f-04a2-48b9-a256-a77df267f5f2/",
                       "placeholderUrl": "https://ucarecdn.com/8c809ddb-0010-437a-9b09-9a66cdf26f10/"
                     },
                     "textLocalized": "Pic 8",
                     "id": "c9eea0ee-c91e-4f7f-86f0-0d8961772f29",
                     "config": {
                       "x": 106.744,
                       "y": 261.072,
                       "width": 84.8,
                       "height": 105.6,
                       "zIndex": 9
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "80ea5f97-1990-4f22-9f07-75f946129f71",
                         "name": "73e0ed1e-0826-4a41-9587-ac4adfb14893 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "f00750c0-a5ba-49cf-8dfe-c54330858098",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/78f1fe1a-0ac0-46e0-b240-6bf014a4018f/",
                             "filterId": "80ea5f97-1990-4f22-9f07-75f946129f71"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/460c98ee-a777-4b1a-a486-033b00da0dc7/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/78f1fe1a-0ac0-46e0-b240-6bf014a4018f/",
                       "placeholderUrl": "https://ucarecdn.com/460c98ee-a777-4b1a-a486-033b00da0dc7/"
                     },
                     "textLocalized": "Pic 9",
                     "id": "73e0ed1e-0826-4a41-9587-ac4adfb14893",
                     "config": {
                       "x": 197.408,
                       "y": 265.632,
                       "width": 87.2,
                       "height": 107.2,
                       "zIndex": 10
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/ba452d20-fa07-44b5-81cb-a2435a18616d/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/ba452d20-fa07-44b5-81cb-a2435a18616d/"
                     },
                     "textLocalized": "",
                     "id": "1bafa9a0-37fd-42bb-9a42-8ff48ebb0ff1",
                     "config": {
                       "x": 15.096,
                       "y": 28.8,
                       "width": 268.288,
                       "height": 343.64,
                       "zIndex": 12
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "9c71d478-61ac-4aed-9318-656962d978f7",
               "cover": "https://ucarecdn.com/525befa7-be4d-4812-9f30-2564117e02e4/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/48612dcd-37f1-4125-96d4-267c88f9d9b5/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/48612dcd-37f1-4125-96d4-267c88f9d9b5/"
                     },
                     "textLocalized": "",
                     "id": "71897199-72da-4d4b-b515-912c4086b369",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 600,
                       "height": 1299.2,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "c0949afd-3783-43ae-9689-09bf3c007ef5",
                         "name": "a9a94d1d-58d9-4055-a63d-d4d76e6766aa filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "7b78f7bb-6326-4b83-9dab-2ad9fefdabed",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/c5c7a216-80ee-4402-8e98-4fb329e5936e/",
                             "filterId": "c0949afd-3783-43ae-9689-09bf3c007ef5"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/e243b748-feb5-4af4-a5a3-49d096f40252/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/c5c7a216-80ee-4402-8e98-4fb329e5936e/",
                       "placeholderUrl": "https://ucarecdn.com/e243b748-feb5-4af4-a5a3-49d096f40252/"
                     },
                     "textLocalized": "Pic 1",
                     "id": "a9a94d1d-58d9-4055-a63d-d4d76e6766aa",
                     "config": {
                       "x": 72,
                       "y": -68.8,
                       "width": 171.2,
                       "height": 130.4,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "6c470716-3851-4111-97a6-a763d3a41e17",
                         "name": "74ed1408-c702-4be2-98de-25f2459dcda7 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "032e53a9-33ae-4f90-a768-fba8df47afcd",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/470768b3-1eeb-495f-9dca-4f2e6af8af11/",
                             "filterId": "6c470716-3851-4111-97a6-a763d3a41e17"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/0dc4d09b-814e-4549-9ad3-ce60561236f0/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/470768b3-1eeb-495f-9dca-4f2e6af8af11/",
                       "placeholderUrl": "https://ucarecdn.com/0dc4d09b-814e-4549-9ad3-ce60561236f0/"
                     },
                     "textLocalized": "Pic 2",
                     "id": "74ed1408-c702-4be2-98de-25f2459dcda7",
                     "config": {
                       "x": 69.6,
                       "y": 65.6,
                       "width": 171.2,
                       "height": 131.2,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "0e2052f2-370f-49bc-93e8-8c7008068cf0",
                         "name": "8d6e91ce-0ab5-45c3-bd84-98a70e8b94d7 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "c799544e-0482-46cb-aaf3-f03d46880eab",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/4c2ad504-12c3-4619-8a22-11bc48b83f7d/",
                             "filterId": "0e2052f2-370f-49bc-93e8-8c7008068cf0"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/5bb8a8b2-3d7a-4411-a23f-8788807bbf1a/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/4c2ad504-12c3-4619-8a22-11bc48b83f7d/",
                       "placeholderUrl": "https://ucarecdn.com/5bb8a8b2-3d7a-4411-a23f-8788807bbf1a/"
                     },
                     "textLocalized": "Pic 3",
                     "id": "8d6e91ce-0ab5-45c3-bd84-98a70e8b94d7",
                     "config": {
                       "x": 67.2,
                       "y": 201.6,
                       "width": 171.2,
                       "height": 130.4,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "96bd9d5d-b403-4c50-ad1f-89f827595669",
                         "name": "9d4f2935-1754-4058-8f0b-d03ade138d2f filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "56cc2d1b-d425-4019-ac85-b4717349911b",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/16fb9125-3746-471a-a0ba-96ef49589c03/",
                             "filterId": "96bd9d5d-b403-4c50-ad1f-89f827595669"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/63bab257-0927-4d47-8ca5-a4f8720dadf2/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/16fb9125-3746-471a-a0ba-96ef49589c03/",
                       "placeholderUrl": "https://ucarecdn.com/63bab257-0927-4d47-8ca5-a4f8720dadf2/"
                     },
                     "textLocalized": "Pic 4",
                     "id": "9d4f2935-1754-4058-8f0b-d03ade138d2f",
                     "config": {
                       "x": 64.8,
                       "y": 336,
                       "width": 171.2,
                       "height": 131.2,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/9dbff6cc-419c-4a7a-9d68-b1f2610ea565/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/9dbff6cc-419c-4a7a-9d68-b1f2610ea565/"
                     },
                     "textLocalized": "",
                     "id": "e7bc4612-fb43-4b94-8284-9f122ec2abe0",
                     "config": {
                       "x": 31.152,
                       "y": -77.2,
                       "width": 241.6,
                       "height": 555.2,
                       "zIndex": 6
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "df150005-56de-4ad3-87d2-4175847fd7c4",
               "cover": "https://ucarecdn.com/b5f38811-b625-4fe2-8a6a-aab608c39987/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/0a515c8a-6e18-4561-a9a2-77a161ba94b0/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/0a515c8a-6e18-4561-a9a2-77a161ba94b0/"
                     },
                     "textLocalized": "",
                     "id": "4f1858d5-a62a-421c-a99d-05fa563e0805",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "ca252d98-4a23-46e4-a36a-9d72c597c42d",
                         "name": "71c3a40b-52e7-481b-9e4c-618e209f82f1 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "13307623-ed7c-4d84-9277-75b7a5ccd311",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/fe9c77d2-ab65-4b91-be59-5ad226e746e3/",
                             "filterId": "ca252d98-4a23-46e4-a36a-9d72c597c42d"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/f6b786d6-73ec-4328-8d1f-fe19eff9a3e5/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/fe9c77d2-ab65-4b91-be59-5ad226e746e3/",
                       "placeholderUrl": "https://ucarecdn.com/f6b786d6-73ec-4328-8d1f-fe19eff9a3e5/"
                     },
                     "textLocalized": "Pic 1",
                     "id": "71c3a40b-52e7-481b-9e4c-618e209f82f1",
                     "config": {
                       "x": -4.232,
                       "y": -124.4,
                       "width": 158.4,
                       "height": 339.2,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "6aef89e4-abcd-4461-8826-a8abed26ace0",
                         "name": "cec4fe71-b9a1-4027-a4f7-cf1c15c07a79 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "e14e2c15-b3de-4148-805b-844a8e6b68f8",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/77d9572b-418f-47a3-9499-a2185a867759/",
                             "filterId": "6aef89e4-abcd-4461-8826-a8abed26ace0"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/f095e43f-5c7d-4ed0-8d9e-7170937da704/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/77d9572b-418f-47a3-9499-a2185a867759/",
                       "placeholderUrl": "https://ucarecdn.com/f095e43f-5c7d-4ed0-8d9e-7170937da704/"
                     },
                     "textLocalized": "Pic 2",
                     "id": "cec4fe71-b9a1-4027-a4f7-cf1c15c07a79",
                     "config": {
                       "x": 148.424,
                       "y": -124.8,
                       "width": 156.8,
                       "height": 324.8,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "62b2d440-f747-4305-a51b-ee37731f9bbb",
                         "name": "e7c54b58-6e26-442c-a29b-27529716ed19 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "c3224e83-e44b-4bcd-837e-934bde240567",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/b9f5c159-c5d0-4f31-9dd1-47cd61420d1d/",
                             "filterId": "62b2d440-f747-4305-a51b-ee37731f9bbb"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/231921d4-ddcc-4473-a26d-2e3ad1e5c103/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/b9f5c159-c5d0-4f31-9dd1-47cd61420d1d/",
                       "placeholderUrl": "https://ucarecdn.com/231921d4-ddcc-4473-a26d-2e3ad1e5c103/"
                     },
                     "textLocalized": "Pic 3",
                     "id": "e7c54b58-6e26-442c-a29b-27529716ed19",
                     "config": {
                       "x": -1.448,
                       "y": 201.6,
                       "width": 162.4,
                       "height": 328.8,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "22ccbab6-1b6f-4fd4-9fd8-6728cc3849c3",
                         "name": "f10bcd73-2731-4f76-93b0-6ecabde693b8 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "590c756c-a7de-4c1e-9038-5af1f41a20ca",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/4f8aea48-cee9-4eaa-a5af-f2b3f154e19e/",
                             "filterId": "22ccbab6-1b6f-4fd4-9fd8-6728cc3849c3"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/bda747ae-d5cf-4f89-9f3d-be3e7d4f77c6/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/4f8aea48-cee9-4eaa-a5af-f2b3f154e19e/",
                       "placeholderUrl": "https://ucarecdn.com/bda747ae-d5cf-4f89-9f3d-be3e7d4f77c6/"
                     },
                     "textLocalized": "Pic 4",
                     "id": "f10bcd73-2731-4f76-93b0-6ecabde693b8",
                     "config": {
                       "x": 144,
                       "y": 190.728,
                       "width": 164,
                       "height": 341.6,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "0ea1391f-7237-4435-b77c-d409d7b3ce13",
               "cover": "https://ucarecdn.com/13827714-6b50-45da-972f-ed66fedff184/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/99a88ab9-1917-4e30-8c0c-ebc729606c8e/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/99a88ab9-1917-4e30-8c0c-ebc729606c8e/"
                     },
                     "textLocalized": "",
                     "id": "763d99a2-0705-40d4-95ff-da215d388c61",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "abc6bedd-a41e-4722-9635-3da5aa83eef0",
                         "name": "42aa8556-3974-4063-99c0-cd8dd2c3bba3 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "f1e5c8a3-e8db-4a96-abca-b96b7b197355",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/ef578109-8d03-45f7-b3ab-0527c63f7374/",
                             "filterId": "abc6bedd-a41e-4722-9635-3da5aa83eef0"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/64134434-787f-47e8-90e1-e99af830a35a/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/ef578109-8d03-45f7-b3ab-0527c63f7374/",
                       "placeholderUrl": "https://ucarecdn.com/64134434-787f-47e8-90e1-e99af830a35a/"
                     },
                     "textLocalized": "Pic 1",
                     "id": "42aa8556-3974-4063-99c0-cd8dd2c3bba3",
                     "config": {
                       "x": 34.712,
                       "y": 98.4,
                       "width": 56.8,
                       "height": 72,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "55f5c35e-fbac-4c15-a6b2-ec9abe6639c2",
                         "name": "5b03484e-23b6-45e3-af95-96795cf4eb55 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "59f0a0bd-5582-410d-8025-53ebe820e98f",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/02df4246-6188-4348-b14b-e6cf14089548/",
                             "filterId": "55f5c35e-fbac-4c15-a6b2-ec9abe6639c2"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/fd67eefb-71c1-42d0-90fb-a7c54de1554a/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/02df4246-6188-4348-b14b-e6cf14089548/",
                       "placeholderUrl": "https://ucarecdn.com/fd67eefb-71c1-42d0-90fb-a7c54de1554a/"
                     },
                     "textLocalized": "Pic 2",
                     "id": "5b03484e-23b6-45e3-af95-96795cf4eb55",
                     "config": {
                       "x": 115.84,
                       "y": 62.888,
                       "width": 56.8,
                       "height": 72,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "de152760-8331-44ec-9c25-0e308aed74f5",
                         "name": "a6975cd0-bbd7-4b5e-b51b-d1b0738cc3a3 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "61afe2ce-c6ad-416b-804e-ab0455a88fbf",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/6e7fb9d3-9ce9-4d77-9799-7cdf8a98f0ed/",
                             "filterId": "de152760-8331-44ec-9c25-0e308aed74f5"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/86c6addd-b06d-4a3f-bc62-61b1aefc29ee/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/6e7fb9d3-9ce9-4d77-9799-7cdf8a98f0ed/",
                       "placeholderUrl": "https://ucarecdn.com/86c6addd-b06d-4a3f-bc62-61b1aefc29ee/"
                     },
                     "textLocalized": "Pic 3",
                     "id": "a6975cd0-bbd7-4b5e-b51b-d1b0738cc3a3",
                     "config": {
                       "x": 206.712,
                       "y": 20,
                       "width": 56.8,
                       "height": 72,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "5bd53775-5ec6-4137-90f6-c983e794764e",
                         "name": "4253f403-e6c3-478a-828d-5111cabc4644 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "048207a2-ff77-4afb-82aa-424cd5e47850",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/2f8620a0-6bd7-4ff4-9eab-65818910d1f8/",
                             "filterId": "5bd53775-5ec6-4137-90f6-c983e794764e"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/da0505a8-bc7b-44ab-a135-e68320d875be/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/2f8620a0-6bd7-4ff4-9eab-65818910d1f8/",
                       "placeholderUrl": "https://ucarecdn.com/da0505a8-bc7b-44ab-a135-e68320d875be/"
                     },
                     "textLocalized": "Pic 4",
                     "id": "4253f403-e6c3-478a-828d-5111cabc4644",
                     "config": {
                       "x": 38.16,
                       "y": 280.488,
                       "width": 56.8,
                       "height": 72,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "37c91ede-c6f3-4aac-aaf0-92d5becf10d4",
                         "name": "fe9ae71d-e382-4577-a20c-f2da2b782a2d filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "5fb7f444-36f8-45ac-8fab-74efeed53347",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/e4ab4987-4c35-4c2d-991c-6c275fec68ae/",
                             "filterId": "37c91ede-c6f3-4aac-aaf0-92d5becf10d4"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/2f4c16d5-354b-48ae-93cd-36cf3ebede23/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/e4ab4987-4c35-4c2d-991c-6c275fec68ae/",
                       "placeholderUrl": "https://ucarecdn.com/2f4c16d5-354b-48ae-93cd-36cf3ebede23/"
                     },
                     "textLocalized": "Pic 5",
                     "id": "fe9ae71d-e382-4577-a20c-f2da2b782a2d",
                     "config": {
                       "x": 122.4,
                       "y": 208.488,
                       "width": 56.8,
                       "height": 72,
                       "zIndex": 6
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "771e0f4f-d6cb-402e-bef7-94f5b143488c",
                         "name": "15a0c7fe-b229-4003-913e-be272fec07a1 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "38013387-555c-4072-a340-b8cdf54f3669",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/25d90bd7-3a35-4ffb-b603-e87ccad5c31b/",
                             "filterId": "771e0f4f-d6cb-402e-bef7-94f5b143488c"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/1dc66b18-680d-4592-a138-da5a227e48e7/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/25d90bd7-3a35-4ffb-b603-e87ccad5c31b/",
                       "placeholderUrl": "https://ucarecdn.com/1dc66b18-680d-4592-a138-da5a227e48e7/"
                     },
                     "textLocalized": "Pic 6",
                     "id": "15a0c7fe-b229-4003-913e-be272fec07a1",
                     "config": {
                       "x": 206.712,
                       "y": 288,
                       "width": 56.8,
                       "height": 72,
                       "zIndex": 7
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             },
             {
               "__typename": "EditorTemplateVariant",
               "id": "a37a4a81-f676-4f08-8a1a-6f0b976a41f3",
               "cover": "https://ucarecdn.com/48df6e96-68e3-4ec5-8231-d72bb5d4089c/",
               "clientConfig": {
                 "__typename": "EditorTemplateVariantConfig",
                 "items": [
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/681f4d14-f0cb-44a6-88ae-8eb06fdbde14/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/681f4d14-f0cb-44a6-88ae-8eb06fdbde14/"
                     },
                     "textLocalized": "",
                     "id": "48b683f0-a95e-4ed2-8784-a54fa64d079e",
                     "config": {
                       "x": 0,
                       "y": -124.8,
                       "width": 300,
                       "height": 649.6,
                       "zIndex": 1
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "fe3337aa-0c7f-4c3d-962a-f066447f55fa",
                         "name": "67e5bd25-08a6-4a0f-ae53-42c077600554 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "9cb54a61-ba7b-42f5-bb4f-dc8c38af49b6",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/a4fafc66-5a14-4f42-b615-57a2165fee48/",
                             "filterId": "fe3337aa-0c7f-4c3d-962a-f066447f55fa"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/c18b11da-35f1-459a-836c-ef806c3a94c9/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/a4fafc66-5a14-4f42-b615-57a2165fee48/",
                       "placeholderUrl": "https://ucarecdn.com/c18b11da-35f1-459a-836c-ef806c3a94c9/"
                     },
                     "textLocalized": "Pic 1",
                     "id": "67e5bd25-08a6-4a0f-ae53-42c077600554",
                     "config": {
                       "x": 13.768,
                       "y": 25.888,
                       "width": 88.8,
                       "height": 108.8,
                       "zIndex": 2
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "c986a66a-9262-4e06-b1f6-bb4577349c37",
                         "name": "9799811a-c16b-4b08-83e3-54aef50f6926 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "5c92f1e3-fea2-4759-a77a-b15805ff5a07",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/1b8357f5-34c5-4a00-a460-635284e6f2a9/",
                             "filterId": "c986a66a-9262-4e06-b1f6-bb4577349c37"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/6bd281ae-9958-42cb-b0a3-5b39995a299d/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/1b8357f5-34c5-4a00-a460-635284e6f2a9/",
                       "placeholderUrl": "https://ucarecdn.com/6bd281ae-9958-42cb-b0a3-5b39995a299d/"
                     },
                     "textLocalized": "Pic 2",
                     "id": "9799811a-c16b-4b08-83e3-54aef50f6926",
                     "config": {
                       "x": 105.536,
                       "y": 25.456,
                       "width": 96,
                       "height": 116,
                       "zIndex": 3
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "738a552d-b3fc-4d2f-8f1e-3a8540a3873d",
                         "name": "00f21e23-6065-4302-b6ca-e3ca92bbf2e8 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "c28480ee-f5c4-4259-99f7-c7f2ca4f2deb",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/015b15de-c7fb-44e6-b3c9-a8613bb803b8/",
                             "filterId": "738a552d-b3fc-4d2f-8f1e-3a8540a3873d"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/348779ef-fe8f-4efa-bbdf-40d9a28b85d9/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/015b15de-c7fb-44e6-b3c9-a8613bb803b8/",
                       "placeholderUrl": "https://ucarecdn.com/348779ef-fe8f-4efa-bbdf-40d9a28b85d9/"
                     },
                     "textLocalized": "Pic 3",
                     "id": "00f21e23-6065-4302-b6ca-e3ca92bbf2e8",
                     "config": {
                       "x": 10.448,
                       "y": 144.2,
                       "width": 89.6,
                       "height": 112,
                       "zIndex": 4
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "7f8ab78a-4310-4b14-bcb1-b6c64966b9fc",
                         "name": "fdc71147-9f6d-4b84-afab-8ab9952c12f4 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "a82e570e-48d5-498a-a8ca-c4b21e60af75",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/90d07147-c73d-4761-b22d-7e783a6eb05b/",
                             "filterId": "7f8ab78a-4310-4b14-bcb1-b6c64966b9fc"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/f8d3dd1b-abcf-4611-a8ca-b9a835d4b1d4/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/90d07147-c73d-4761-b22d-7e783a6eb05b/",
                       "placeholderUrl": "https://ucarecdn.com/f8d3dd1b-abcf-4611-a8ca-b9a835d4b1d4/"
                     },
                     "textLocalized": "Pic 4",
                     "id": "fdc71147-9f6d-4b84-afab-8ab9952c12f4",
                     "config": {
                       "x": 195.528,
                       "y": 143.624,
                       "width": 87.2,
                       "height": 108.8,
                       "zIndex": 5
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "c454b3b8-6c6a-4f6c-a905-667c230f16a6",
                         "name": "77a91476-c96f-4141-9cdd-9431e85daf56 filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "d9035fa7-3138-404a-bd6f-22cc0478e266",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/b3bec352-16f6-430a-8da4-47c04347d780/",
                             "filterId": "c454b3b8-6c6a-4f6c-a905-667c230f16a6"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/4c3488fc-a3ba-4172-99fb-efa4d805ac46/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/b3bec352-16f6-430a-8da4-47c04347d780/",
                       "placeholderUrl": "https://ucarecdn.com/4c3488fc-a3ba-4172-99fb-efa4d805ac46/"
                     },
                     "textLocalized": "Pic 5",
                     "id": "77a91476-c96f-4141-9cdd-9431e85daf56",
                     "config": {
                       "x": 104.216,
                       "y": 249.792,
                       "width": 88,
                       "height": 108.8,
                       "zIndex": 6
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [
                       {
                         "__typename": "EditorFilter",
                         "id": "a006e864-f9a1-4e3e-ad9d-6988751aa9e3",
                         "name": "bbd17b50-1ea4-4f6e-b2e2-bca36c12c95e filter",
                         "cover": null,
                         "stepsFull": [
                           {
                             "__typename": "EditorFilterStep",
                             "id": "4fa5f0a1-1741-4e0d-8a96-24821667ca37",
                             "index": 1,
                             "type": "mask",
                             "settings": {},
                             "url": "https://ucarecdn.com/d0be8f8e-2f46-4ae2-a96c-ba221b9c0e34/",
                             "filterId": "a006e864-f9a1-4e3e-ad9d-6988751aa9e3"
                           }
                         ]
                       }
                     ],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/96d5d360-a004-4c50-811c-3fd2303fa6fd/",
                     "type": 1,
                     "settings": {
                       "type": 0,
                       "maskUrl": "https://ucarecdn.com/d0be8f8e-2f46-4ae2-a96c-ba221b9c0e34/",
                       "placeholderUrl": "https://ucarecdn.com/96d5d360-a004-4c50-811c-3fd2303fa6fd/"
                     },
                     "textLocalized": "Pic 6",
                     "id": "bbd17b50-1ea4-4f6e-b2e2-bca36c12c95e",
                     "config": {
                       "x": 194.928,
                       "y": 260.744,
                       "width": 94.4,
                       "height": 116,
                       "zIndex": 7
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   },
                   {
                     "__typename": "ClientEditorTemplateItem",
                     "filters": [],
                     "blendMode": "CISourceOverCompositing",
                     "imageUrl": "https://ucarecdn.com/87f15948-e7ff-4de0-9c09-d25480bf1b37/",
                     "type": 0,
                     "settings": {
                       "url": "https://ucarecdn.com/87f15948-e7ff-4de0-9c09-d25480bf1b37/"
                     },
                     "textLocalized": "",
                     "id": "bd009b4c-1f99-45fd-86fb-d03e2f78be09",
                     "config": {
                       "x": 10.448,
                       "y": 25.888,
                       "width": 278.52,
                       "height": 349.768,
                       "zIndex": 8
                     },
                     "isMovable": false,
                     "isText": false,
                     "verticalAlign": null,
                     "defaultColor": null,
                     "fontPreset": null
                   }
                 ]
               }
             }
           ]
         }
       ]
     }
   }
 }
 */
