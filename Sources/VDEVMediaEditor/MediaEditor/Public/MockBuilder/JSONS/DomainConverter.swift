//
//  DomainConverter.swift
//  
//
//  Created by Vladislav Gushin on 14.05.2023.
//

import Foundation

struct DomainConverter {
    static func makeFrom<T: Codable>(_ jsonString: String) throws -> T {
        let data = jsonString.data(using: .utf8)!
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    static func unique<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    static func convertToDomain(_ maskData: MasksData) -> [EditorFilter] {
        let masks = maskData.masks
            .filter {
                !$0.appEditorMasks.isEmpty
            }.flatMap {
                $0.appEditorMasks
            }
            .filter {
                !$0.stepsFull.isEmpty
            }
        
        var result: [EditorFilter] = []
        
        masks.forEach { mask in
            let id = mask.id
            let name = mask.name
            let cover = URL(string: mask.cover)
            
            var steps: [EditorFilter.Step] = []
            
            for step in mask.stepsFull {
                guard let stepType = EditorFilter.Step.StepType(value: step.type) else {
                    continue
                }
                
                let domainStep = EditorFilter.Step(type: stepType,
                                                   url: URL(string: step.url))
                
                steps.append(domainStep)
            }
            
            
            let filter = EditorFilter(id: id, name: name, cover: cover, steps: steps)
            
            let contains = result.contains { $0.id == filter.id }
            
            if !contains { result.append(filter) }
        }
        
        return result
    }
    
    static func convertToDomain(_ texturesData: TexturesData) -> [EditorFilter] {
        let textures = texturesData.textures
            .filter {
                !$0.appEditorTextures.isEmpty
            }.flatMap {
                $0.appEditorTextures
            }
            .filter {
                !$0.stepsFull.isEmpty
            }
        
        var result: [EditorFilter] = []
        textures.forEach { texture in
            let id = texture.id
            let name = texture.name
            let cover = URL(string: texture.cover)
            var steps: [EditorFilter.Step] = []
            
            for step in texture.stepsFull {
                guard let stepType = EditorFilter.Step.StepType(value: step.type) else {
                    continue
                }
                
                var json: [String: Any] = [:]
                json["blendMode"] = step.settings.blendMode
                if let contentMode = step.settings.contentMode {
                    json["contentMode"] = contentMode
                }
                
                let domainStep = EditorFilter.Step(type: stepType,
                                             url: URL(string: step.url),
                                             settings: EditorFilter.StepSettings(jsonValue: json))
                
                steps.append(domainStep)
            }
            
            let filter = EditorFilter(id: id, name: name, cover: cover, steps: steps)
            
            let contains = result.contains { $0.id == filter.id }
            
            if !contains { result.append(filter) }
        }
        
        return result
    }
    
    static func convertToDomain(_ stickersData: StickersData) -> [(String, [StickerItem])] {
        let packs = stickersData.stickers
            .filter {
                !$0.attachedStickerPacks.isEmpty
            }.flatMap {
                $0.attachedStickerPacks
            }
            .filter {
                !$0.stickersFull.isEmpty
            }
        
        let unikPacks = unique(source: packs)
        
        return unikPacks.map {
            let title = $0.titleLocalized
            let stickers: [StickerItem] = $0.stickersFull.compactMap { sticker in
                guard let url = URL(string: sticker.uri) else { return nil }
                return StickerItem.init(url: url)
            }
            return (title, stickers)
        }
    }
}
