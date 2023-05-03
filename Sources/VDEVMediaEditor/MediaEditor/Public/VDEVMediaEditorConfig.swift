//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 17.04.2023.
//

import Foundation
import UIKit

public struct VDEVMediaEditorConfig {
    // settings
    private(set) var settings: VDEVMediaEditorSettings
    // network service
    private(set) var networkService: VDEVMediaEditorSourceService
    // images
    private(set) var images: VDEVImageConfig
    // strings
    private(set) var strings: VDEVMediaEditorStrings
    
    public init(settings: VDEVMediaEditorSettings,
                networkService: VDEVMediaEditorSourceService,
                images: VDEVImageConfig,
                strings: VDEVMediaEditorStrings) {
        self.settings = settings
        self.networkService = networkService
        self.images = images
        self.strings = strings
    }
}

public protocol VDEVImageConfig {
    var common: VDEVMediaEditorButtonsCommonImages { get }
    var currentItem: VDEVMediaEditorButtonsCurrentItemImages { get }
    var textEdit: VDEVMediaEditorButtonsTextEditingImages { get }
    var typed: VDEVMediaEditorButtonsTypedImages { get }
}

// MARK: - Common Images
public protocol VDEVMediaEditorButtonsCommonImages {
    var add: UIImage { get }
    var addMediaM: UIImage { get }
    var backArrow: UIImage { get }
    var bg: UIImage { get }
    var close: UIImage { get }
    var fontBGSelect: UIImage { get }
    var fontSelect: UIImage { get }
    var photoVideoCapture: UIImage { get }
    var iGStories: UIImage { get }
    var layers: UIImage { get }
    var share: UIImage { get }
    var xmark: UIImage { get }
    var resultGradient: UIImage { get }
    var undo: UIImage { get }
}

// MARK: - Selected layer images
public protocol VDEVMediaEditorButtonsCurrentItemImages {
    var currentIteDublicate: UIImage { get }
    var currentItemAdjustments: UIImage { get }
    var currentItemBringToBottom: UIImage { get }
    var currentItemBringToTop: UIImage { get }
    var currentItemCrop: UIImage { get }
    var currentItemDown: UIImage { get }
    var currentItemEditText: UIImage { get }
    var currentItemFilter: UIImage { get }
    var currentItemMask: UIImage { get }
    var currentItemReset: UIImage { get }
    var currentItemRM: UIImage { get }
    var currentItemRMBack: UIImage { get }
    var currentItemTexture: UIImage { get }
    var currentItemUp: UIImage { get }
    var currentItemMerge: UIImage { get }
}

// MARK: - Text editing tools
public protocol VDEVMediaEditorButtonsTextEditingImages {
    var textEditingAlignCenter: UIImage { get }
    var textEditingAlignLeft: UIImage { get }
    var textEditingAlignRight: UIImage { get }
    var textEditingColorSelectIcon: UIImage { get }
    var textEditingRemoveText: UIImage { get }
}

// MARK: - Typed images
public protocol VDEVMediaEditorButtonsTypedImages {
    var typeCamera: UIImage { get }
    var typeDraw: UIImage { get }
    var typePaste: UIImage { get }
    var typePhoto: UIImage { get }
    var typeStickers: UIImage { get }
    var typeTemplate: UIImage { get }
    var typeText: UIImage { get }
    var typeVideo: UIImage { get }
}

// MARK: - Strings
public protocol VDEVMediaEditorStrings {
    var paste: String { get }
    var brightness: String { get }
    var contrast: String { get }
    var saturation: String { get }
    var highlight: String { get }
    var shadow: String { get }
    var `default`: String { get }
    var mask: String { get }
    var filter: String { get }
    var texture: String { get }
    var adjustments: String { get }
    var crop: String { get }
    var removeBack: String { get }
    var editText: String { get }
    var dublicate: String { get }
    var reset: String { get }
    var remove: String { get }
    var up: String { get }
    var down: String { get }
    var bringToTop: String { get }
    var bringToBottom: String { get }
    var selectMedia: String { get }
    var colorFilter: String { get }
    var close: String { get }
    var layers: String { get }
    var templatePack: String { get }
    var addMedia: String { get }
    var challengeTitle: String { get }
    var shareOrSave: String { get }
    var template: String { get }
    var text: String { get }
    var stickersCustom: String { get }
    var addPhoto: String { get }
    var addVideo: String { get }
    var camera: String { get }
    var drawing: String { get }
    var background: String { get }
    var error: String { get }
    var ok: String { get }
    var publish: String { get }
    var see: String { get }
    var answers: String { get }
    var defaultPlaceholder: String { get }
    var delete: String { get }
    var done: String { get }
    var `continue`: String { get }
    var processing: String { get }
    var loading: String { get }
    var applied: String { get }
    var templates: String { get }
    var merge: String { get }
}
