//
//  JSONStikers.swift
//  
//
//  Created by Vladislav Gushin on 13.05.2023.
//

import Foundation

// MARK: - Welcome
struct StickersData: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let baseChallenges: [BaseChallenge]
}

// MARK: - BaseChallenge
struct BaseChallenge: Codable {
    let attachedStickerPacks: [AttachedStickerPack]
}

// MARK: - AttachedStickerPack
struct AttachedStickerPack: Codable {
    let id: String
    let titleLocalized: String
    let stickersFull: [StickersFull]
}

// MARK: - StickersFull
struct StickersFull: Codable {
    let uri: String
}

let stickersJSON: String = """
{
  "data": {
    "baseChallenges": [
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "bd30ecac-3b33-4423-8973-d6d40e9ae2d1",
            "titleLocalized": "Googly eyes",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/1c24ef1a-f0e4-42e0-b5d7-c5f6b0fcd334/"
              },
              {
                "uri": "https://ucarecdn.com/8d3eeef7-36d6-40c7-a4c7-816b9a3c5953/"
              },
              {
                "uri": "https://ucarecdn.com/3f7bb480-dd18-4530-a214-1b71defeec35/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "e47280a7-c284-436f-ad6e-aca7d346370c",
            "titleLocalized": "Baldesari dots ",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/8da2e77a-963e-4c3f-b66c-e4c226f30727/"
              },
              {
                "uri": "https://ucarecdn.com/117b80ff-fb5c-4f52-8fe2-f528246854af/"
              },
              {
                "uri": "https://ucarecdn.com/b1bce62e-89b4-4b59-ba04-7fd5e8c1ab69/"
              },
              {
                "uri": "https://ucarecdn.com/1b26ec21-744a-4da7-8218-137fd5da5195/"
              },
              {
                "uri": "https://ucarecdn.com/86a42ab7-d6f4-4d15-bfa4-c70621601b23/"
              },
              {
                "uri": "https://ucarecdn.com/30ae6ef7-9ba2-48a7-99d5-2fb9c6caba6f/"
              },
              {
                "uri": "https://ucarecdn.com/3dded770-26b7-4c4a-a119-a2efdb7747f3/"
              },
              {
                "uri": "https://ucarecdn.com/f4f3d746-fd6a-441f-951c-606037345ba3/"
              },
              {
                "uri": "https://ucarecdn.com/7c75259c-0dd0-4af3-9eee-2bcafd8c2999/"
              },
              {
                "uri": "https://ucarecdn.com/3519acb8-1933-4c3d-a98e-237e454647f8/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "9878e01e-8fdd-45d5-85dc-fae18c7fc7a9",
            "titleLocalized": "Sergei Svyatchenko collages",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/9c4d74f8-2a67-4d43-a886-88735b956f02/"
              },
              {
                "uri": "https://ucarecdn.com/f03e491a-21d4-47af-b35d-79acf5a4f3c1/"
              },
              {
                "uri": "https://ucarecdn.com/1cab32e0-80f4-4425-8744-f809be5e3116/"
              },
              {
                "uri": "https://ucarecdn.com/b99476d3-902f-4365-a73c-d4f3e7de4bf6/"
              },
              {
                "uri": "https://ucarecdn.com/351b7880-e7bd-4383-a459-6e8249b34c9e/"
              },
              {
                "uri": "https://ucarecdn.com/5da684f3-d001-407e-9ca6-dddcedec1622/"
              },
              {
                "uri": "https://ucarecdn.com/05390d8f-dc50-4e46-8130-14d0fdc197fa/"
              },
              {
                "uri": "https://ucarecdn.com/62033a9e-2635-4ebb-b3b5-d9f8d2a2bcf6/"
              },
              {
                "uri": "https://ucarecdn.com/e2bcf10e-8e74-4d83-9b28-7238fee50bc1/"
              },
              {
                "uri": "https://ucarecdn.com/6b711a96-8d49-4f6a-b124-446b2393b607/"
              },
              {
                "uri": "https://ucarecdn.com/71a17a90-71c2-4f55-8490-3973f2ed90d5/"
              },
              {
                "uri": "https://ucarecdn.com/3462d1dd-1f65-4b15-858e-cabe2feefffe/"
              },
              {
                "uri": "https://ucarecdn.com/939ba32f-8491-4f6a-b4c7-7d110f87a914/"
              },
              {
                "uri": "https://ucarecdn.com/a1c67a1a-3847-480f-bede-613bfb7742b8/"
              },
              {
                "uri": "https://ucarecdn.com/58c85c89-b903-4bd5-8d78-83b66efc20cf/"
              },
              {
                "uri": "https://ucarecdn.com/562cf728-f301-4b70-a9b1-6c5e4b1e7fb6/"
              },
              {
                "uri": "https://ucarecdn.com/7eaac374-79e4-464b-9993-52404fa2b18f/"
              },
              {
                "uri": "https://ucarecdn.com/e7ba38ea-6882-4f35-9143-53b2e791eaaf/"
              },
              {
                "uri": "https://ucarecdn.com/cd4669b3-1590-456c-8213-e656ef90d666/"
              },
              {
                "uri": "https://ucarecdn.com/759ae1a2-c3c1-4ec8-a649-0d97e1693191/"
              },
              {
                "uri": "https://ucarecdn.com/5d067fd7-9cab-43aa-85e4-03777c9ec428/"
              },
              {
                "uri": "https://ucarecdn.com/9e6fdacf-bbdf-4b5a-b196-1af4b6d2742b/"
              },
              {
                "uri": "https://ucarecdn.com/470bbe45-a86f-4dfb-aca1-3380d19467ba/"
              },
              {
                "uri": "https://ucarecdn.com/2c20e756-408f-410b-865e-9caf58a55b61/"
              },
              {
                "uri": "https://ucarecdn.com/c453b9bc-bb44-4eb3-862f-5c1d8ec0f5b2/"
              },
              {
                "uri": "https://ucarecdn.com/8c7de7a9-a41f-4996-a16c-f2c5b5df5330/"
              },
              {
                "uri": "https://ucarecdn.com/b3ef3076-5063-4bfd-89a3-90b8d51f53da/"
              },
              {
                "uri": "https://ucarecdn.com/c1de9c23-fffd-43aa-9a60-e3aafdfc4bb4/"
              },
              {
                "uri": "https://ucarecdn.com/7bbc3f7d-eac1-44ae-9890-7c5e4e602ceb/"
              },
              {
                "uri": "https://ucarecdn.com/7ff36a0b-ef19-4db8-84a3-b39bf3e5f84d/"
              },
              {
                "uri": "https://ucarecdn.com/881c238f-1f92-455d-b93b-a4e72e28a416/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": [
          {
            "id": "a845027f-4e82-48b2-95a2-8c73218744aa",
            "titleLocalized": "Kazimir Malevich",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/56869437-ebe5-4305-9c4e-b4316970d48c/"
              },
              {
                "uri": "https://ucarecdn.com/d83e2caf-9dc5-482a-a80f-66aa416cf950/"
              },
              {
                "uri": "https://ucarecdn.com/fb62494c-8388-4da9-b2a1-1e9b3837eef4/"
              },
              {
                "uri": "https://ucarecdn.com/ae4e57d6-6154-48ef-aab8-17dbae388a88/"
              },
              {
                "uri": "https://ucarecdn.com/d046e4b1-0d61-47fd-a600-5c45e046ca03/"
              },
              {
                "uri": "https://ucarecdn.com/a60a6d61-ad73-4a9e-ad59-0b9e406583b2/"
              },
              {
                "uri": "https://ucarecdn.com/bed146d8-8977-4a27-9145-5790549d0ce4/"
              },
              {
                "uri": "https://ucarecdn.com/ecb95f7a-5caa-459f-afc5-47ecb3042fa6/"
              },
              {
                "uri": "https://ucarecdn.com/b4b40c3e-a04c-41ed-ba9e-f2cb527e3a3e/"
              },
              {
                "uri": "https://ucarecdn.com/e0aab1e4-6f0f-4783-a67b-843c810a8015/"
              },
              {
                "uri": "https://ucarecdn.com/a4a1ce7e-15ef-4b60-b4ae-549879622ddd/"
              },
              {
                "uri": "https://ucarecdn.com/625e3f5a-b836-48e3-b34a-9dbe687a903a/"
              },
              {
                "uri": "https://ucarecdn.com/d30bd23c-8fb3-4faa-a60e-fe8eb0ac394d/"
              },
              {
                "uri": "https://ucarecdn.com/ad236a54-73f7-4778-9ad3-1405a1a004ef/"
              },
              {
                "uri": "https://ucarecdn.com/2e93bc3b-6007-40a9-bf54-1f55c8e97f13/"
              },
              {
                "uri": "https://ucarecdn.com/57be5354-b686-4366-91e9-accfb7f5a580/"
              },
              {
                "uri": "https://ucarecdn.com/02ba7ea5-bce6-46e3-a842-edfa468c3045/"
              },
              {
                "uri": "https://ucarecdn.com/541cd224-7818-44e4-ae38-c94d5ce33487/"
              },
              {
                "uri": "https://ucarecdn.com/80df1410-cfc4-452a-9c63-2917900623d8/"
              },
              {
                "uri": "https://ucarecdn.com/fcb46469-45a2-4f91-86da-39867a896daa/"
              },
              {
                "uri": "https://ucarecdn.com/2898f629-a2d1-463f-9318-68524b9d9f28/"
              },
              {
                "uri": "https://ucarecdn.com/ac6429bf-79ea-4ce4-b637-1eb08b422af0/"
              },
              {
                "uri": "https://ucarecdn.com/2d614199-5f2b-41ac-a96c-4daf48eff236/"
              },
              {
                "uri": "https://ucarecdn.com/e0a33a3e-2f38-4061-997f-beab24286b02/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": [
          {
            "id": "36ced04e-2ea3-4bd3-8b96-7a0cddd1dca6",
            "titleLocalized": "2oo2 avatars",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/fe5df2ca-9ddc-47d2-8125-303dc77ed3a4/"
              },
              {
                "uri": "https://ucarecdn.com/504efb9d-b8d0-4b67-8c1b-934a36ae220f/"
              },
              {
                "uri": "https://ucarecdn.com/7bf4782d-8f99-4c38-a1ee-78032d58949f/"
              },
              {
                "uri": "https://ucarecdn.com/3ce11f9c-45a6-4052-8485-9a7465fc77c7/"
              },
              {
                "uri": "https://ucarecdn.com/028c33b9-e7d2-483d-927b-dc44c45d1a94/"
              },
              {
                "uri": "https://ucarecdn.com/f453ac3c-5a11-4de8-a1a9-a6f897eebd44/"
              },
              {
                "uri": "https://ucarecdn.com/ba8f0d7a-cf92-45f8-a37d-48896cdd17b9/"
              },
              {
                "uri": "https://ucarecdn.com/e413d216-4a5f-42e4-b56c-4ceb1494074f/"
              },
              {
                "uri": "https://ucarecdn.com/5039724e-4cbf-4b6a-a86c-d88907a0f6f5/"
              },
              {
                "uri": "https://ucarecdn.com/0a35ec31-b155-4e06-8e93-6bc73acd1e94/"
              },
              {
                "uri": "https://ucarecdn.com/287bd044-1b97-4a38-a8bc-9bfd83d61b89/"
              },
              {
                "uri": "https://ucarecdn.com/c6066ecb-efa8-4e49-9cc8-2eec03051905/"
              },
              {
                "uri": "https://ucarecdn.com/70ff1e62-c337-41a7-a902-d4070c9c0a62/"
              },
              {
                "uri": "https://ucarecdn.com/651a1739-23c6-49c5-b9ec-2b52b3c9de62/"
              },
              {
                "uri": "https://ucarecdn.com/c8bd7fe6-f69e-455a-907e-d65a3e025314/"
              },
              {
                "uri": "https://ucarecdn.com/2e2b9810-ca7e-4292-97c1-629d93da6828/"
              },
              {
                "uri": "https://ucarecdn.com/f60e486e-6622-450c-b614-e14b981924f9/"
              },
              {
                "uri": "https://ucarecdn.com/3c4388cd-9cfd-4e56-b9c9-d3d13ea4f413/"
              },
              {
                "uri": "https://ucarecdn.com/c6a9f0a7-81b6-4111-95b0-4502eb650f38/"
              },
              {
                "uri": "https://ucarecdn.com/ba22b610-ee2e-416e-8d99-47a54bbad437/"
              },
              {
                "uri": "https://ucarecdn.com/d84af1cb-dfda-450b-9231-0ec077eb8a4a/"
              },
              {
                "uri": "https://ucarecdn.com/39b18366-2acd-49ef-808f-1c1a3992d25f/"
              },
              {
                "uri": "https://ucarecdn.com/4b46c069-b10c-4bff-933d-562ac8790622/"
              },
              {
                "uri": "https://ucarecdn.com/e8be47c8-2f24-4028-b6b2-14446719b193/"
              },
              {
                "uri": "https://ucarecdn.com/b4ed0577-6903-412b-9aae-e5ec9e31a3f6/"
              },
              {
                "uri": "https://ucarecdn.com/cd204e3b-1453-42b8-a0ff-f56c1147b883/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": [
          {
            "id": "d77b5545-af56-4afc-9cf6-de0ea153e6cc",
            "titleLocalized": "Collage poetry with Zohra Hussain",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/e2abb89e-aa3d-4e4f-a94a-600f99b6fe0d/"
              },
              {
                "uri": "https://ucarecdn.com/8bb98f48-006d-4e16-9a81-5e6eef9b8417/"
              },
              {
                "uri": "https://ucarecdn.com/044c406d-3240-43df-9767-bb1930515ba4/"
              },
              {
                "uri": "https://ucarecdn.com/aaa6b6bc-0d9c-41ac-a537-e189a4edc438/"
              },
              {
                "uri": "https://ucarecdn.com/b2c06968-9adc-41b6-8760-5c7ace7788a6/"
              },
              {
                "uri": "https://ucarecdn.com/211d7ee3-d070-4f28-ba5c-4cf929cdfef8/"
              },
              {
                "uri": "https://ucarecdn.com/0324193f-9fff-4acc-b8d6-67522c5eda8f/"
              },
              {
                "uri": "https://ucarecdn.com/b0be8cfe-dc59-44b2-bc65-e80c04b73272/"
              },
              {
                "uri": "https://ucarecdn.com/d18f702c-2935-458b-b089-34f75c1f6831/"
              },
              {
                "uri": "https://ucarecdn.com/e6f9248e-69d3-4584-ad3b-49c8bf86af61/"
              },
              {
                "uri": "https://ucarecdn.com/4c1035e1-9f28-430d-b162-bdc8eb668e35/"
              },
              {
                "uri": "https://ucarecdn.com/301af288-efac-4a9c-b3dc-a4df3aa29ed1/"
              },
              {
                "uri": "https://ucarecdn.com/45cdb8db-203d-4d6e-91f1-378b0e2677e2/"
              },
              {
                "uri": "https://ucarecdn.com/a957e69c-fa4b-4887-9cb1-72a756d2c1d6/"
              },
              {
                "uri": "https://ucarecdn.com/48f1569c-affa-4f5d-856e-4c847474ed59/"
              },
              {
                "uri": "https://ucarecdn.com/07d69564-e662-47ed-9d2e-e4bcfff23507/"
              },
              {
                "uri": "https://ucarecdn.com/6e120e85-0436-4e76-970d-2220652965dc/"
              },
              {
                "uri": "https://ucarecdn.com/a0970cb1-3a2b-4891-8d69-23ed1d743064/"
              },
              {
                "uri": "https://ucarecdn.com/d5c110d9-821a-4c46-af33-e6c68ee77c0c/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "58c082d5-e1af-4b48-9d34-1b62cb8aaa38",
            "titleLocalized": "Confessions with Geloy Concepcion",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/f437b1a9-cd03-4944-8aec-a2bc39d27fb1/"
              },
              {
                "uri": "https://ucarecdn.com/6fb01f4d-ec83-40ed-820b-96a7307a7873/"
              },
              {
                "uri": "https://ucarecdn.com/f858ec31-d6ff-4800-bd1a-e10456c6069c/"
              },
              {
                "uri": "https://ucarecdn.com/b6223987-cf97-4d00-b535-7113df99a9ca/"
              },
              {
                "uri": "https://ucarecdn.com/f08517f7-0fc3-4083-a7d0-6b8bf4576f83/"
              },
              {
                "uri": "https://ucarecdn.com/1cc67c5c-4800-4efd-a58a-be0fbf0ac5ee/"
              },
              {
                "uri": "https://ucarecdn.com/889db4aa-432b-45b4-88e7-056669273122/"
              },
              {
                "uri": "https://ucarecdn.com/3f48003e-1d72-4ea3-b4da-54f540a0c8b7/"
              },
              {
                "uri": "https://ucarecdn.com/0747a003-1b39-42b3-bd92-4e05ebe74d48/"
              },
              {
                "uri": "https://ucarecdn.com/af34a02d-d7ef-48cc-88eb-ef146d5922c0/"
              },
              {
                "uri": "https://ucarecdn.com/bf59240e-fdbb-4829-b19e-a6b221f2869e/"
              },
              {
                "uri": "https://ucarecdn.com/682ab75b-c709-48a9-a33e-0619cd6711ce/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "5970b754-5ac1-4caf-9ccc-ac86045b212c",
            "titleLocalized": "Yokai",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/a979b5e6-e519-40b0-8ac1-d959afee0111/"
              },
              {
                "uri": "https://ucarecdn.com/9fde1160-e592-4f33-9b7e-d677a29ca687/"
              },
              {
                "uri": "https://ucarecdn.com/8041740b-021c-4771-a554-b18996573087/"
              },
              {
                "uri": "https://ucarecdn.com/6c205b90-697a-4158-81df-033bba22fb4a/"
              },
              {
                "uri": "https://ucarecdn.com/a8137c9d-2167-4a5e-99ea-6362c6a68172/"
              },
              {
                "uri": "https://ucarecdn.com/c92b97d2-2f1a-484b-a367-90f4db211320/"
              },
              {
                "uri": "https://ucarecdn.com/c4434a34-bfc0-4503-838e-1f108f719bd9/"
              },
              {
                "uri": "https://ucarecdn.com/19ebd73d-03e4-4bb2-a9d3-e626af17e5de/"
              },
              {
                "uri": "https://ucarecdn.com/16e0fbea-0c66-42a3-b21b-4dabe7cc74d0/"
              },
              {
                "uri": "https://ucarecdn.com/893b5036-c553-4814-851c-a75a7be2db11/"
              },
              {
                "uri": "https://ucarecdn.com/7c9be1b4-9863-4076-86f8-14b77fd8c67e/"
              },
              {
                "uri": "https://ucarecdn.com/4e2e9a80-e28d-45b7-b9c1-c3bc364aff5d/"
              },
              {
                "uri": "https://ucarecdn.com/9c5b879d-f15a-4bcb-9208-3923e5e770bf/"
              },
              {
                "uri": "https://ucarecdn.com/18d44413-28fb-4a4c-a77a-a01b02d82f4b/"
              },
              {
                "uri": "https://ucarecdn.com/8c3b88ad-b5f2-4bdb-a8ab-d399c615ce9f/"
              },
              {
                "uri": "https://ucarecdn.com/e8444d36-cd6c-4e86-8289-38dc7aa171a4/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": [
          {
            "id": "97b3d401-4156-46e1-9da7-46649dd505ef",
            "titleLocalized": "Chimeras",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/1c9de89a-dcf1-48a3-b023-5f4f200163c7/"
              },
              {
                "uri": "https://ucarecdn.com/c5da29b7-887f-4c58-ba6b-d4eebf2da3e7/"
              },
              {
                "uri": "https://ucarecdn.com/87fdfd8a-ed30-49e1-9e4c-af1fbe473a24/"
              },
              {
                "uri": "https://ucarecdn.com/27105b09-caa6-43bb-b761-24583ce93152/"
              },
              {
                "uri": "https://ucarecdn.com/ca1ca6be-3ffa-40a4-97df-9c17e2dd750b/"
              },
              {
                "uri": "https://ucarecdn.com/231494b9-3e4b-4c30-8c4e-675cda5c16a7/"
              },
              {
                "uri": "https://ucarecdn.com/c7bd0667-9748-417f-b4b7-79ea09e9c17c/"
              },
              {
                "uri": "https://ucarecdn.com/8564d2be-4480-4211-8fce-5c6e63622ca3/"
              },
              {
                "uri": "https://ucarecdn.com/ec173cb5-10d6-4e16-9f0c-4848b288e5df/"
              },
              {
                "uri": "https://ucarecdn.com/fe85e2d4-fd8f-4a4b-9646-7cf596b48d25/"
              },
              {
                "uri": "https://ucarecdn.com/8efcaac7-2f93-49de-999c-ea5d30656d93/"
              },
              {
                "uri": "https://ucarecdn.com/ed72fca9-2f16-4e9c-a62b-8b5d3b779154/"
              },
              {
                "uri": "https://ucarecdn.com/59c813bf-47c6-4797-a7d7-faa2648c193e/"
              },
              {
                "uri": "https://ucarecdn.com/b0e0f260-de7d-411b-bcc1-b5a1dffbceb6/"
              },
              {
                "uri": "https://ucarecdn.com/acb2106d-c8fa-466c-af41-53345b216d6f/"
              },
              {
                "uri": "https://ucarecdn.com/6d98a569-29bc-426e-b7be-464bd5a4ea4f/"
              },
              {
                "uri": "https://ucarecdn.com/921551fa-db0a-414b-afe0-5d449019fbf0/"
              },
              {
                "uri": "https://ucarecdn.com/9c2b00de-2abc-4d9d-8495-ea8aee4fbd76/"
              },
              {
                "uri": "https://ucarecdn.com/d42ca59f-1c42-444c-aca0-30cacc98dc63/"
              },
              {
                "uri": "https://ucarecdn.com/857bf5df-8325-4db9-a448-ade8ada2ec9a/"
              },
              {
                "uri": "https://ucarecdn.com/bbb2cd4d-47dc-47d9-9e4b-f014853da6cb/"
              },
              {
                "uri": "https://ucarecdn.com/82d39aba-940b-4f63-857b-9ec9d75e403c/"
              },
              {
                "uri": "https://ucarecdn.com/8bf4f320-4ed3-4ad1-a46f-7bb5ac6606b5/"
              },
              {
                "uri": "https://ucarecdn.com/2c0d9b27-dd48-4088-9575-b4bddbbe02b1/"
              },
              {
                "uri": "https://ucarecdn.com/882be409-c34a-4d00-ad01-3c226ead13e0/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "f9f9f7a0-258c-4776-90ac-3ef9f799a01a",
            "titleLocalized": "Past vs present",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/90d86c1c-7e85-4011-b9b4-7a86bfae5837/"
              },
              {
                "uri": "https://ucarecdn.com/46e478c7-1429-42f4-9800-438ba7414521/"
              },
              {
                "uri": "https://ucarecdn.com/d7bfd3e2-1d7e-4139-a13e-c5a388903374/"
              },
              {
                "uri": "https://ucarecdn.com/f8d422e8-2fab-49c4-ac5b-9201dd5f272d/"
              },
              {
                "uri": "https://ucarecdn.com/8f5d86d8-bc02-492d-8172-6ae8941cc1bb/"
              },
              {
                "uri": "https://ucarecdn.com/ccfd3528-0800-4cc7-90ad-f37c82b2800a/"
              },
              {
                "uri": "https://ucarecdn.com/bfff7de3-947d-4a9f-998e-5ee9ba7599c9/"
              },
              {
                "uri": "https://ucarecdn.com/0a03400d-08d3-4ae8-b392-7e019a08f82f/"
              },
              {
                "uri": "https://ucarecdn.com/759293ae-5908-4489-866c-960d68f9fa7b/"
              },
              {
                "uri": "https://ucarecdn.com/3e31f904-e527-42bc-be27-d4ed9c9af435/"
              },
              {
                "uri": "https://ucarecdn.com/24de2d30-d370-4aa8-9c60-14c189967b78/"
              },
              {
                "uri": "https://ucarecdn.com/fab14fec-e7ff-40e5-90fe-7e1472514016/"
              },
              {
                "uri": "https://ucarecdn.com/6957da46-9707-47dc-b3a4-0ab92e0a3ee2/"
              },
              {
                "uri": "https://ucarecdn.com/2c77534a-3cda-4328-8f3e-6af2c972bf6e/"
              },
              {
                "uri": "https://ucarecdn.com/a9b7a210-59d6-4746-88e4-b44373ceb041/"
              },
              {
                "uri": "https://ucarecdn.com/bcdfa4b1-fc85-4dce-a3fa-79f1ed9f8306/"
              },
              {
                "uri": "https://ucarecdn.com/23d51e04-744c-4646-ab34-6c59f8e3a656/"
              },
              {
                "uri": "https://ucarecdn.com/eb88cb24-7df2-495f-86f1-801d9f62246b/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": [
          {
            "id": "25600cc6-b45e-4cbd-b49c-4d451bf45a27",
            "titleLocalized": "Nature in unusual places",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/c5077e5b-de92-4f5e-b33d-a3cbd9148c09/"
              },
              {
                "uri": "https://ucarecdn.com/f5392d87-40da-40a4-920e-92660a79c1bf/"
              },
              {
                "uri": "https://ucarecdn.com/f0ad7680-ca26-4b65-8d52-813cc2e258a5/"
              },
              {
                "uri": "https://ucarecdn.com/4b66c5ca-d086-46f9-8199-9beebc586918/"
              },
              {
                "uri": "https://ucarecdn.com/ec238a4b-6885-4e31-8037-58aaddd8a9e4/"
              },
              {
                "uri": "https://ucarecdn.com/a9853c7b-3bd8-4545-8686-193d345f9d4d/"
              },
              {
                "uri": "https://ucarecdn.com/b5d7cb0b-2087-4877-8c4a-79a424eca2cb/"
              },
              {
                "uri": "https://ucarecdn.com/41d7b695-4bad-47c4-821b-ef53b70a76d9/"
              },
              {
                "uri": "https://ucarecdn.com/279da0b4-5e87-4ce8-8392-1037828682bc/"
              },
              {
                "uri": "https://ucarecdn.com/f0bb99c8-6ba1-4b03-a9dc-51256d5843f5/"
              },
              {
                "uri": "https://ucarecdn.com/2d35a5ee-67b5-48c9-8646-4236ade18668/"
              },
              {
                "uri": "https://ucarecdn.com/ab2c12cf-f1a2-4216-a7d9-904a981bff82/"
              },
              {
                "uri": "https://ucarecdn.com/df563361-1de8-4b7a-af04-41144f82b4c0/"
              },
              {
                "uri": "https://ucarecdn.com/072a20cf-c8ed-46a1-8a91-a1a9b0e92164/"
              },
              {
                "uri": "https://ucarecdn.com/ea0d853b-c755-468c-acff-0484998d46dd/"
              },
              {
                "uri": "https://ucarecdn.com/6c9d2925-97e8-40e3-8e20-1ac778a0cad8/"
              },
              {
                "uri": "https://ucarecdn.com/7a2d85c5-4b8c-45d6-aa33-851be304bea9/"
              },
              {
                "uri": "https://ucarecdn.com/98a59d01-7a77-473c-b693-bc6039e236d3/"
              },
              {
                "uri": "https://ucarecdn.com/8d038062-88c8-464d-a772-caf41cfc5157/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "61f092a5-db49-4888-aac4-709577520c6f",
            "titleLocalized": "Splashes with Gerhard Richter",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/29373ce6-0e4d-47eb-afd0-f7d981e4fdb4/"
              },
              {
                "uri": "https://ucarecdn.com/3c407114-d08e-42f9-9780-8809938f99dd/"
              },
              {
                "uri": "https://ucarecdn.com/d40ade4d-3a5e-4b88-b828-fef23dfbee82/"
              },
              {
                "uri": "https://ucarecdn.com/d4714a17-0711-4bf9-a1e9-b86bdc473be3/"
              },
              {
                "uri": "https://ucarecdn.com/38744300-e9f1-4614-b919-78428e98b0fe/"
              },
              {
                "uri": "https://ucarecdn.com/f18a55f0-4b14-4a2e-99f0-f7c1ad804fc5/"
              },
              {
                "uri": "https://ucarecdn.com/b5ef1003-c907-4299-8d5f-06e22ba6dc80/"
              },
              {
                "uri": "https://ucarecdn.com/47b06fbf-29e5-4f3e-82ae-29505f485432/"
              },
              {
                "uri": "https://ucarecdn.com/b114955e-5ec1-4d01-b110-08d61764b841/"
              },
              {
                "uri": "https://ucarecdn.com/2e2e4bc5-8ce8-434d-b161-1e897cc0b158/"
              },
              {
                "uri": "https://ucarecdn.com/811a29c9-0868-4fe4-b6c8-0c3c0d76b2f3/"
              },
              {
                "uri": "https://ucarecdn.com/63a49eff-2e04-47ee-9f77-01dad18bbb31/"
              },
              {
                "uri": "https://ucarecdn.com/18394c4f-02eb-461d-a12d-9386891ed521/"
              },
              {
                "uri": "https://ucarecdn.com/ce3d9fef-ed97-4c8f-bd94-5c9c78e94757/"
              },
              {
                "uri": "https://ucarecdn.com/4940c6fa-db2f-4d77-8a2d-1ded79d8ff23/"
              },
              {
                "uri": "https://ucarecdn.com/fb7df2f0-5b91-4153-8f03-9bb3bbea0f63/"
              },
              {
                "uri": "https://ucarecdn.com/f291c79e-0b64-4767-a28b-5a5fa0e18508/"
              },
              {
                "uri": "https://ucarecdn.com/df28bf4b-a0cd-4bdd-80e8-6016e66ac689/"
              },
              {
                "uri": "https://ucarecdn.com/deac8903-ecf6-4fc1-adcf-8acc6acc7f81/"
              },
              {
                "uri": "https://ucarecdn.com/f8912f85-0228-42ed-ae79-2cabed07ffaf/"
              },
              {
                "uri": "https://ucarecdn.com/9236d2fc-d3b3-4d8a-bba6-ac4e79aca5bb/"
              },
              {
                "uri": "https://ucarecdn.com/81a1bb76-26ca-4550-8684-cb33e0ce0569/"
              },
              {
                "uri": "https://ucarecdn.com/6eb286fb-7d50-411c-8cf8-9b54b6840494/"
              },
              {
                "uri": "https://ucarecdn.com/9ea0463f-9d70-4306-8303-1e0d4a9db364/"
              },
              {
                "uri": "https://ucarecdn.com/080ffcea-d79b-4ad3-80f4-56a668fb4461/"
              },
              {
                "uri": "https://ucarecdn.com/ce4e3298-f6fb-4dea-8383-0dd6f0cf81df/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": [
          {
            "id": "138e3b05-de8e-4be5-80fd-64d4e5f65550",
            "titleLocalized": "Small people, big world",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/74a48922-c15a-4a53-af4f-c8a982f39038/"
              },
              {
                "uri": "https://ucarecdn.com/a4a7c093-8d9a-403e-8fcc-038320baa15f/"
              },
              {
                "uri": "https://ucarecdn.com/9267599c-924f-4542-8e85-7852ebfa70e0/"
              },
              {
                "uri": "https://ucarecdn.com/9267d38f-4365-4fbb-8f4a-c00076db149c/"
              },
              {
                "uri": "https://ucarecdn.com/bae51145-2cc0-4cb1-b4a6-c5ab5ae66b4e/"
              },
              {
                "uri": "https://ucarecdn.com/a5af44ca-221a-4a7e-aaa8-8774014f3854/"
              },
              {
                "uri": "https://ucarecdn.com/9b6c9ace-fe80-4aae-9605-e43967a47c22/"
              },
              {
                "uri": "https://ucarecdn.com/089dfd9b-bb34-46a3-bd68-2d5b846b54e5/"
              },
              {
                "uri": "https://ucarecdn.com/9e2db79c-9dd0-4fa0-830e-3187210778f5/"
              },
              {
                "uri": "https://ucarecdn.com/07c8aee2-7423-43a5-bb28-98a00230d07c/"
              },
              {
                "uri": "https://ucarecdn.com/4f27a01d-ce39-4b3e-8a75-bf2a2be3dc45/"
              },
              {
                "uri": "https://ucarecdn.com/4d91ca72-457c-4447-9d26-51de5520ab45/"
              },
              {
                "uri": "https://ucarecdn.com/96c502d9-0c23-4aad-a898-d0aad3d749b1/"
              },
              {
                "uri": "https://ucarecdn.com/b72c9736-54b7-4d36-83f1-0a8c42ba03e3/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "4ae696c6-4067-45ba-b890-63df2d10e3bc",
            "titleLocalized": "Hannah Höch",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/7d5380ea-e1fe-464e-bef6-6710ba495423/"
              },
              {
                "uri": "https://ucarecdn.com/340f90b3-b3df-4b57-984f-56d6d2b8841b/"
              },
              {
                "uri": "https://ucarecdn.com/97ee48a1-3522-48e5-a3dd-8b587a853435/"
              },
              {
                "uri": "https://ucarecdn.com/1256ad81-4ee9-476f-ba10-9b90074f3d45/"
              },
              {
                "uri": "https://ucarecdn.com/9d4464df-711e-4e39-b1ca-2a4697ade0ea/"
              },
              {
                "uri": "https://ucarecdn.com/f3f52f03-a36b-4836-97f6-cff9d80f9b0b/"
              },
              {
                "uri": "https://ucarecdn.com/98ad343a-e6e2-40be-b738-ad66c36279d5/"
              },
              {
                "uri": "https://ucarecdn.com/81d89979-bd30-43e1-b813-15d5b9dfc008/"
              },
              {
                "uri": "https://ucarecdn.com/01625770-ff9a-49cd-b77d-4a3a798e3b60/"
              },
              {
                "uri": "https://ucarecdn.com/9e43e0b7-adec-44b8-993e-1f5ab43f4441/"
              },
              {
                "uri": "https://ucarecdn.com/1f8e5b35-a6f5-4564-95d9-6c61d3938ad9/"
              },
              {
                "uri": "https://ucarecdn.com/41b34601-0e6c-4685-a459-4cadb8675652/"
              },
              {
                "uri": "https://ucarecdn.com/32e3ddf6-da30-4f35-8f4d-dfc88099f350/"
              },
              {
                "uri": "https://ucarecdn.com/d69e7da1-69a2-4d84-981b-80c53767d3a5/"
              },
              {
                "uri": "https://ucarecdn.com/0a0dd228-74d3-48b7-8ce5-607de4f32441/"
              },
              {
                "uri": "https://ucarecdn.com/1e8f5e26-17fb-4682-91ac-a56e88954a47/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "4d192d8c-2e23-4190-ba20-6edcac3fc773",
            "titleLocalized": "Samira Alikhanzadeh",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/be51a4a4-e8d5-4b1d-8a1f-25e7c6ba8a9f/"
              },
              {
                "uri": "https://ucarecdn.com/91cb8364-bbef-4044-b58f-44a255df5b68/"
              },
              {
                "uri": "https://ucarecdn.com/7bd56f4e-4d95-4fb1-a215-41140691c2a4/"
              },
              {
                "uri": "https://ucarecdn.com/0a0db69d-1a9c-467e-95e5-4f1698ce6f7f/"
              },
              {
                "uri": "https://ucarecdn.com/a8a04f80-b7ad-45ab-9f91-6b0baead3820/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "910f3186-c37a-469f-a9f5-73a144383960",
            "titleLocalized": "Yayoi Kusama",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/c2b79344-be25-4663-81d8-8763d722c139/"
              },
              {
                "uri": "https://ucarecdn.com/d1086a4c-a851-4506-b8f8-0ab5bc6da578/"
              },
              {
                "uri": "https://ucarecdn.com/58737f26-2846-42a1-8c3f-87d203796ac7/"
              },
              {
                "uri": "https://ucarecdn.com/c2718590-a4cb-4a63-a4e4-8db7c0ee58b8/"
              },
              {
                "uri": "https://ucarecdn.com/633b0ca4-1623-4bc2-ad10-91e1c3b0a01c/"
              },
              {
                "uri": "https://ucarecdn.com/d5a8477b-b240-44aa-98fd-e7ec93e7c648/"
              },
              {
                "uri": "https://ucarecdn.com/a61186fb-ffaa-4281-9b33-6742e64c5a02/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "cdffa7ac-402b-4365-991f-15586c1846d5",
            "titleLocalized": "Cloud",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/6df8e67e-7a95-43a2-adc5-33e4176dec97/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "aa76997a-e1f4-4049-8fad-78a485764511",
            "titleLocalized": "Bulatov",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/27b76e95-7428-461d-a1a6-df72b0a436ab/"
              },
              {
                "uri": "https://ucarecdn.com/744a3b61-b5b4-48a2-bae2-b2169a242d2a/"
              },
              {
                "uri": "https://ucarecdn.com/f352cb8e-0630-4edb-8453-ad5be3263d33/"
              },
              {
                "uri": "https://ucarecdn.com/04f2e2c3-4772-4a52-a84d-fc1b00c0b3d6/"
              },
              {
                "uri": "https://ucarecdn.com/ef73bc18-1725-4985-a007-5a2d82be3bb8/"
              },
              {
                "uri": "https://ucarecdn.com/45a13426-bf8f-4f5f-80fe-75fe51b52e84/"
              },
              {
                "uri": "https://ucarecdn.com/a3a10fa2-6385-40c4-abd2-d62f8bbe35a7/"
              },
              {
                "uri": "https://ucarecdn.com/dfddcca1-801e-47c5-bcfe-36822a974bfe/"
              },
              {
                "uri": "https://ucarecdn.com/9c928295-0ba8-4322-8934-d111f8a990e5/"
              },
              {
                "uri": "https://ucarecdn.com/b8cab106-d4e1-45d2-b8e3-429be7e25224/"
              },
              {
                "uri": "https://ucarecdn.com/bd99cce1-5d16-4464-af09-fd0a2525c08b/"
              },
              {
                "uri": "https://ucarecdn.com/8e76e2b6-9962-4c31-8b0f-2c346a9579e2/"
              },
              {
                "uri": "https://ucarecdn.com/f67d2147-4366-4b8a-b9d5-989ebb4cc90a/"
              },
              {
                "uri": "https://ucarecdn.com/1eefa1af-c925-47c7-ac21-2a66aeef500d/"
              },
              {
                "uri": "https://ucarecdn.com/9330f7b9-dad4-4bb4-87f6-f8f3d8b323f6/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "e6f2944e-2249-43a9-98a8-ab46bffc2a2b",
            "titleLocalized": "sticker pack",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/7efb74fa-2a97-466b-a3e4-33d0cb578978/"
              },
              {
                "uri": "https://ucarecdn.com/de8aa847-dc64-4e66-a83e-8f3b79d7a4f0/"
              },
              {
                "uri": "https://ucarecdn.com/d61aa4eb-884c-4485-b151-ff913a676989/"
              },
              {
                "uri": "https://ucarecdn.com/4c3cdf65-c837-43d4-9635-f99b71a52979/"
              },
              {
                "uri": "https://ucarecdn.com/6026708d-1b53-4eff-9dfb-12c85545b30d/"
              },
              {
                "uri": "https://ucarecdn.com/41905ae2-fa2b-44ce-a819-540fb7ca1edb/"
              },
              {
                "uri": "https://ucarecdn.com/66a2c2c8-9f2e-44f1-b406-d9b6608c36ef/"
              },
              {
                "uri": "https://ucarecdn.com/a8caa348-af10-49b3-a4e7-7a7c59fff860/"
              },
              {
                "uri": "https://ucarecdn.com/20002fa3-6560-442f-912c-dd7ec851b30d/"
              },
              {
                "uri": "https://ucarecdn.com/f116aed3-8535-4770-998c-a315a83afdc9/"
              },
              {
                "uri": "https://ucarecdn.com/9a59ccc5-2217-4e51-9624-729d701c9801/"
              },
              {
                "uri": "https://ucarecdn.com/8d67487f-3246-450b-b8a8-1b73cec7cca0/"
              },
              {
                "uri": "https://ucarecdn.com/c9cd2bd1-bf4f-4960-b6d2-6bb40895d96f/"
              },
              {
                "uri": "https://ucarecdn.com/23f252d8-e672-4cb0-8f31-a60ca5549470/"
              },
              {
                "uri": "https://ucarecdn.com/f6646b55-392b-4a19-afe6-60af44066d32/"
              },
              {
                "uri": "https://ucarecdn.com/c371ffdf-2075-4675-8833-2d2a299e2cbd/"
              },
              {
                "uri": "https://ucarecdn.com/3e388627-90f7-4a30-aca4-e8507d2fe0dc/"
              },
              {
                "uri": "https://ucarecdn.com/16291653-a927-4297-b029-88c48e1d32ac/"
              },
              {
                "uri": "https://ucarecdn.com/e2d17a9c-a2cf-4c3e-9611-15070c22d3cd/"
              },
              {
                "uri": "https://ucarecdn.com/cb14d028-0172-498f-b8b4-5052a19531b7/"
              },
              {
                "uri": "https://ucarecdn.com/568b4d5d-3e3f-4256-80ca-376b750527b3/"
              },
              {
                "uri": "https://ucarecdn.com/42aed940-cd69-44be-95a7-95e30255a155/"
              },
              {
                "uri": "https://ucarecdn.com/09d08c0e-4bdf-4b5d-b9ef-0d30ccaa6b86/"
              },
              {
                "uri": "https://ucarecdn.com/6dcf07ba-8b8f-4d16-a04f-8715a18a4bbd/"
              },
              {
                "uri": "https://ucarecdn.com/1ab789de-d924-4946-824b-cc0701ecb129/"
              },
              {
                "uri": "https://ucarecdn.com/036e113f-9347-4fb6-b8b4-b47dfc64690e/"
              },
              {
                "uri": "https://ucarecdn.com/39bfc823-eb81-4500-b9d5-7c71d226190b/"
              },
              {
                "uri": "https://ucarecdn.com/a3f3bdca-428a-4b9e-858b-dd25ca9c61b7/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "aa76997a-e1f4-4049-8fad-78a485764511",
            "titleLocalized": "Bulatov",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/27b76e95-7428-461d-a1a6-df72b0a436ab/"
              },
              {
                "uri": "https://ucarecdn.com/744a3b61-b5b4-48a2-bae2-b2169a242d2a/"
              },
              {
                "uri": "https://ucarecdn.com/f352cb8e-0630-4edb-8453-ad5be3263d33/"
              },
              {
                "uri": "https://ucarecdn.com/04f2e2c3-4772-4a52-a84d-fc1b00c0b3d6/"
              },
              {
                "uri": "https://ucarecdn.com/ef73bc18-1725-4985-a007-5a2d82be3bb8/"
              },
              {
                "uri": "https://ucarecdn.com/45a13426-bf8f-4f5f-80fe-75fe51b52e84/"
              },
              {
                "uri": "https://ucarecdn.com/a3a10fa2-6385-40c4-abd2-d62f8bbe35a7/"
              },
              {
                "uri": "https://ucarecdn.com/dfddcca1-801e-47c5-bcfe-36822a974bfe/"
              },
              {
                "uri": "https://ucarecdn.com/9c928295-0ba8-4322-8934-d111f8a990e5/"
              },
              {
                "uri": "https://ucarecdn.com/b8cab106-d4e1-45d2-b8e3-429be7e25224/"
              },
              {
                "uri": "https://ucarecdn.com/bd99cce1-5d16-4464-af09-fd0a2525c08b/"
              },
              {
                "uri": "https://ucarecdn.com/8e76e2b6-9962-4c31-8b0f-2c346a9579e2/"
              },
              {
                "uri": "https://ucarecdn.com/f67d2147-4366-4b8a-b9d5-989ebb4cc90a/"
              },
              {
                "uri": "https://ucarecdn.com/1eefa1af-c925-47c7-ac21-2a66aeef500d/"
              },
              {
                "uri": "https://ucarecdn.com/9330f7b9-dad4-4bb4-87f6-f8f3d8b323f6/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "bd30ecac-3b33-4423-8973-d6d40e9ae2d1",
            "titleLocalized": "Googly eyes",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/1c24ef1a-f0e4-42e0-b5d7-c5f6b0fcd334/"
              },
              {
                "uri": "https://ucarecdn.com/8d3eeef7-36d6-40c7-a4c7-816b9a3c5953/"
              },
              {
                "uri": "https://ucarecdn.com/3f7bb480-dd18-4530-a214-1b71defeec35/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": [
          {
            "id": "aa76997a-e1f4-4049-8fad-78a485764511",
            "titleLocalized": "Bulatov",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/27b76e95-7428-461d-a1a6-df72b0a436ab/"
              },
              {
                "uri": "https://ucarecdn.com/744a3b61-b5b4-48a2-bae2-b2169a242d2a/"
              },
              {
                "uri": "https://ucarecdn.com/f352cb8e-0630-4edb-8453-ad5be3263d33/"
              },
              {
                "uri": "https://ucarecdn.com/04f2e2c3-4772-4a52-a84d-fc1b00c0b3d6/"
              },
              {
                "uri": "https://ucarecdn.com/ef73bc18-1725-4985-a007-5a2d82be3bb8/"
              },
              {
                "uri": "https://ucarecdn.com/45a13426-bf8f-4f5f-80fe-75fe51b52e84/"
              },
              {
                "uri": "https://ucarecdn.com/a3a10fa2-6385-40c4-abd2-d62f8bbe35a7/"
              },
              {
                "uri": "https://ucarecdn.com/dfddcca1-801e-47c5-bcfe-36822a974bfe/"
              },
              {
                "uri": "https://ucarecdn.com/9c928295-0ba8-4322-8934-d111f8a990e5/"
              },
              {
                "uri": "https://ucarecdn.com/b8cab106-d4e1-45d2-b8e3-429be7e25224/"
              },
              {
                "uri": "https://ucarecdn.com/bd99cce1-5d16-4464-af09-fd0a2525c08b/"
              },
              {
                "uri": "https://ucarecdn.com/8e76e2b6-9962-4c31-8b0f-2c346a9579e2/"
              },
              {
                "uri": "https://ucarecdn.com/f67d2147-4366-4b8a-b9d5-989ebb4cc90a/"
              },
              {
                "uri": "https://ucarecdn.com/1eefa1af-c925-47c7-ac21-2a66aeef500d/"
              },
              {
                "uri": "https://ucarecdn.com/9330f7b9-dad4-4bb4-87f6-f8f3d8b323f6/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "fa0572b3-d806-4997-9e61-0c281bf8f98a",
            "titleLocalized": "Malevich",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/d48dcfac-7eab-43b9-86ff-20543650175e/"
              },
              {
                "uri": "https://ucarecdn.com/684f8db3-23dd-4625-aaf9-e7e48f32386f/"
              },
              {
                "uri": "https://ucarecdn.com/656820c4-2c13-4b0b-9780-9a8fea5fdea7/"
              },
              {
                "uri": "https://ucarecdn.com/d36e38ae-a7a3-4138-af0f-fdbc9ca24fb6/"
              },
              {
                "uri": "https://ucarecdn.com/67dc8934-e55d-4ea4-a1ba-dbd4975cf664/"
              },
              {
                "uri": "https://ucarecdn.com/566a91f3-fb8f-4803-beae-17312bd7351d/"
              },
              {
                "uri": "https://ucarecdn.com/57709edc-8038-4ba7-ae87-5f1713b45010/"
              },
              {
                "uri": "https://ucarecdn.com/41bf40e2-610a-4b52-8f11-8f8b5c84c2c3/"
              },
              {
                "uri": "https://ucarecdn.com/57565e1a-6bfb-477d-b634-75db7e4509ca/"
              },
              {
                "uri": "https://ucarecdn.com/8780340b-0a58-4aa6-b2e0-a78118ccf5a1/"
              },
              {
                "uri": "https://ucarecdn.com/afbf2387-c1f0-41ab-b15a-be25da083393/"
              },
              {
                "uri": "https://ucarecdn.com/937d4347-def3-4367-97ef-8d2652c05ed9/"
              },
              {
                "uri": "https://ucarecdn.com/4ef7fc6a-1aa0-4bcd-a175-cf9e3da1e72b/"
              },
              {
                "uri": "https://ucarecdn.com/873b5bbc-1a91-4e82-a344-08fa5e749842/"
              },
              {
                "uri": "https://ucarecdn.com/d26de25b-d952-4e30-87ae-8e932e567f40/"
              },
              {
                "uri": "https://ucarecdn.com/6d419f11-f3f7-4c94-8925-337739b60d01/"
              },
              {
                "uri": "https://ucarecdn.com/5072193e-a1c0-4d1e-907f-46170eb47ca4/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "e47280a7-c284-436f-ad6e-aca7d346370c",
            "titleLocalized": "Baldesari dots ",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/8da2e77a-963e-4c3f-b66c-e4c226f30727/"
              },
              {
                "uri": "https://ucarecdn.com/117b80ff-fb5c-4f52-8fe2-f528246854af/"
              },
              {
                "uri": "https://ucarecdn.com/b1bce62e-89b4-4b59-ba04-7fd5e8c1ab69/"
              },
              {
                "uri": "https://ucarecdn.com/1b26ec21-744a-4da7-8218-137fd5da5195/"
              },
              {
                "uri": "https://ucarecdn.com/86a42ab7-d6f4-4d15-bfa4-c70621601b23/"
              },
              {
                "uri": "https://ucarecdn.com/30ae6ef7-9ba2-48a7-99d5-2fb9c6caba6f/"
              },
              {
                "uri": "https://ucarecdn.com/3dded770-26b7-4c4a-a119-a2efdb7747f3/"
              },
              {
                "uri": "https://ucarecdn.com/f4f3d746-fd6a-441f-951c-606037345ba3/"
              },
              {
                "uri": "https://ucarecdn.com/7c75259c-0dd0-4af3-9eee-2bcafd8c2999/"
              },
              {
                "uri": "https://ucarecdn.com/3519acb8-1933-4c3d-a98e-237e454647f8/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": [
          {
            "id": "f404755b-b138-468d-9899-0260fffc8681",
            "titleLocalized": "Parajanov",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/80b3ff5b-db05-41a3-b3a0-f8132a3bac39/"
              },
              {
                "uri": "https://ucarecdn.com/7cde6f19-6917-4117-ad13-7edfaaa790e2/"
              },
              {
                "uri": "https://ucarecdn.com/3c5ebe9e-a753-4359-b68d-b046bddcf2af/"
              },
              {
                "uri": "https://ucarecdn.com/e686a1e5-1240-423e-b5c3-74e13e8bceec/"
              },
              {
                "uri": "https://ucarecdn.com/dd389ac7-3c5c-4971-b2f2-9054bbf6c4d7/"
              },
              {
                "uri": "https://ucarecdn.com/3b81caac-baf4-4a23-b4b6-8fb0f7059146/"
              },
              {
                "uri": "https://ucarecdn.com/0dd2c717-d4fe-413a-a590-00cc527ec007/"
              },
              {
                "uri": "https://ucarecdn.com/92272690-3ded-49ad-991c-66c4938c311c/"
              },
              {
                "uri": "https://ucarecdn.com/a39ae1d5-951f-4328-b431-07b79be1f7de/"
              },
              {
                "uri": "https://ucarecdn.com/937358ad-6099-4d54-aa77-5325ef29c85b/"
              },
              {
                "uri": "https://ucarecdn.com/d5370033-8f96-4b6c-8d0e-2e728c8a7a09/"
              },
              {
                "uri": "https://ucarecdn.com/7cd455ce-fea9-435d-b5e6-019237893120/"
              },
              {
                "uri": "https://ucarecdn.com/14481511-3edb-456e-9df8-70f903aa4219/"
              },
              {
                "uri": "https://ucarecdn.com/1e4b53f3-7ff3-42e5-88de-1ff96b78e8a6/"
              },
              {
                "uri": "https://ucarecdn.com/7642a4c1-09bb-4a0e-9c7a-43cd1c04f7bf/"
              },
              {
                "uri": "https://ucarecdn.com/262c382b-72d8-46f7-9fe8-317ea29ba6f8/"
              },
              {
                "uri": "https://ucarecdn.com/79e64ce6-96cb-4b77-8c49-07fe127314a4/"
              },
              {
                "uri": "https://ucarecdn.com/02b684a3-7c18-4226-8f40-b630448cd9f6/"
              },
              {
                "uri": "https://ucarecdn.com/aa190876-d41e-4e4f-9342-34c190b40aab/"
              },
              {
                "uri": "https://ucarecdn.com/e30ce853-cdb0-454a-99f3-7f81ace83c78/"
              },
              {
                "uri": "https://ucarecdn.com/0986435b-b637-428e-9455-88109478dd5c/"
              },
              {
                "uri": "https://ucarecdn.com/e771e525-799a-4762-abef-b9f5e31f0d98/"
              },
              {
                "uri": "https://ucarecdn.com/4bd11f79-8ca8-4174-9e7c-6554b6639fba/"
              },
              {
                "uri": "https://ucarecdn.com/8fbcdba5-4f90-4caf-a674-f83d41aaeec5/"
              },
              {
                "uri": "https://ucarecdn.com/e3405a3e-dac8-4da0-9a32-ac5ca96f0642/"
              },
              {
                "uri": "https://ucarecdn.com/aa470ca7-6804-4069-bcf5-cf13a1cbf680/"
              },
              {
                "uri": "https://ucarecdn.com/cfaf0849-e63b-41f9-9114-41b219ece26a/"
              },
              {
                "uri": "https://ucarecdn.com/f81937ac-ca93-4b12-ac53-0f16f1207032/"
              },
              {
                "uri": "https://ucarecdn.com/7fd6a180-d1ef-408d-a9fa-676593c33a2e/"
              },
              {
                "uri": "https://ucarecdn.com/b82e98a6-f1a4-4a89-baa3-48c2826e203c/"
              },
              {
                "uri": "https://ucarecdn.com/5def07c4-7cfa-4fba-81f5-de4e41e18b40/"
              },
              {
                "uri": "https://ucarecdn.com/75dc20a4-2533-4d4e-a3be-5214cdfd3590/"
              },
              {
                "uri": "https://ucarecdn.com/a5b96a31-2080-42d8-ae8a-b61ba7beb8f7/"
              },
              {
                "uri": "https://ucarecdn.com/4eb4f980-0889-4085-abcd-8e02693877bb/"
              },
              {
                "uri": "https://ucarecdn.com/7c66ab64-23bd-4d30-9592-840014897afd/"
              },
              {
                "uri": "https://ucarecdn.com/ac5bdc6a-e416-4e04-b71d-1d5c53c8efb7/"
              },
              {
                "uri": "https://ucarecdn.com/cf43357c-b637-4d28-9a0c-3992dae95344/"
              },
              {
                "uri": "https://ucarecdn.com/f0cbe0c3-054c-4eae-b0b7-0af3ea564662/"
              },
              {
                "uri": "https://ucarecdn.com/03d8f33e-0c88-4340-84f3-f31d74c2946f/"
              },
              {
                "uri": "https://ucarecdn.com/df2b4595-0e31-4b8f-81fd-b1c920db0a37/"
              },
              {
                "uri": "https://ucarecdn.com/b9bfa86c-2608-4974-81ac-d512eb7d8cc9/"
              },
              {
                "uri": "https://ucarecdn.com/f61849b0-6e2f-4cfa-9687-ab2af8151a8b/"
              },
              {
                "uri": "https://ucarecdn.com/5c6a492d-947c-43fc-a702-b21247faed5d/"
              },
              {
                "uri": "https://ucarecdn.com/5c24e7fc-0eb1-41a9-8bb7-9a73a854f841/"
              },
              {
                "uri": "https://ucarecdn.com/1bb0955c-5fcc-48d8-8876-29229f597234/"
              },
              {
                "uri": "https://ucarecdn.com/5b383b89-401b-46f4-9b43-8f16f26a3998/"
              },
              {
                "uri": "https://ucarecdn.com/4bb7e7a6-39b4-49ae-93d8-1b71f2cffdd4/"
              },
              {
                "uri": "https://ucarecdn.com/c2f1af23-af55-4436-825e-baf0a559ab38/"
              },
              {
                "uri": "https://ucarecdn.com/6f9ae973-a3a7-4137-8db2-e317ef9ef4ee/"
              },
              {
                "uri": "https://ucarecdn.com/c6089425-9a3d-471e-b626-17d0a748296e/"
              },
              {
                "uri": "https://ucarecdn.com/1c21f828-4e66-4472-b5fa-26f95876700d/"
              },
              {
                "uri": "https://ucarecdn.com/7538304f-a2f4-482b-b0be-1bb3f5032b3e/"
              },
              {
                "uri": "https://ucarecdn.com/9606db78-acd3-4b43-bacd-cf82800a7cef/"
              },
              {
                "uri": "https://ucarecdn.com/d7e7f379-93b0-49f6-99c1-bfa39893e4fa/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": [
          {
            "id": "e6f2944e-2249-43a9-98a8-ab46bffc2a2b",
            "titleLocalized": "sticker pack",
            "stickersFull": [
              {
                "uri": "https://ucarecdn.com/7efb74fa-2a97-466b-a3e4-33d0cb578978/"
              },
              {
                "uri": "https://ucarecdn.com/de8aa847-dc64-4e66-a83e-8f3b79d7a4f0/"
              },
              {
                "uri": "https://ucarecdn.com/d61aa4eb-884c-4485-b151-ff913a676989/"
              },
              {
                "uri": "https://ucarecdn.com/4c3cdf65-c837-43d4-9635-f99b71a52979/"
              },
              {
                "uri": "https://ucarecdn.com/6026708d-1b53-4eff-9dfb-12c85545b30d/"
              },
              {
                "uri": "https://ucarecdn.com/41905ae2-fa2b-44ce-a819-540fb7ca1edb/"
              },
              {
                "uri": "https://ucarecdn.com/66a2c2c8-9f2e-44f1-b406-d9b6608c36ef/"
              },
              {
                "uri": "https://ucarecdn.com/a8caa348-af10-49b3-a4e7-7a7c59fff860/"
              },
              {
                "uri": "https://ucarecdn.com/20002fa3-6560-442f-912c-dd7ec851b30d/"
              },
              {
                "uri": "https://ucarecdn.com/f116aed3-8535-4770-998c-a315a83afdc9/"
              },
              {
                "uri": "https://ucarecdn.com/9a59ccc5-2217-4e51-9624-729d701c9801/"
              },
              {
                "uri": "https://ucarecdn.com/8d67487f-3246-450b-b8a8-1b73cec7cca0/"
              },
              {
                "uri": "https://ucarecdn.com/c9cd2bd1-bf4f-4960-b6d2-6bb40895d96f/"
              },
              {
                "uri": "https://ucarecdn.com/23f252d8-e672-4cb0-8f31-a60ca5549470/"
              },
              {
                "uri": "https://ucarecdn.com/f6646b55-392b-4a19-afe6-60af44066d32/"
              },
              {
                "uri": "https://ucarecdn.com/c371ffdf-2075-4675-8833-2d2a299e2cbd/"
              },
              {
                "uri": "https://ucarecdn.com/3e388627-90f7-4a30-aca4-e8507d2fe0dc/"
              },
              {
                "uri": "https://ucarecdn.com/16291653-a927-4297-b029-88c48e1d32ac/"
              },
              {
                "uri": "https://ucarecdn.com/e2d17a9c-a2cf-4c3e-9611-15070c22d3cd/"
              },
              {
                "uri": "https://ucarecdn.com/cb14d028-0172-498f-b8b4-5052a19531b7/"
              },
              {
                "uri": "https://ucarecdn.com/568b4d5d-3e3f-4256-80ca-376b750527b3/"
              },
              {
                "uri": "https://ucarecdn.com/42aed940-cd69-44be-95a7-95e30255a155/"
              },
              {
                "uri": "https://ucarecdn.com/09d08c0e-4bdf-4b5d-b9ef-0d30ccaa6b86/"
              },
              {
                "uri": "https://ucarecdn.com/6dcf07ba-8b8f-4d16-a04f-8715a18a4bbd/"
              },
              {
                "uri": "https://ucarecdn.com/1ab789de-d924-4946-824b-cc0701ecb129/"
              },
              {
                "uri": "https://ucarecdn.com/036e113f-9347-4fb6-b8b4-b47dfc64690e/"
              },
              {
                "uri": "https://ucarecdn.com/39bfc823-eb81-4500-b9d5-7c71d226190b/"
              },
              {
                "uri": "https://ucarecdn.com/a3f3bdca-428a-4b9e-858b-dd25ca9c61b7/"
              }
            ]
          }
        ]
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      },
      {
        "attachedStickerPacks": []
      }
    ]
  }
}
"""
