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
    //result settings
    private(set) var resultSettings: VDEVMediaEditorResultSettings
    // logger
    private(set) var logger: VDEVLogger?
    // modules for internal newtork
    private(set) var networkModulesConfig: [VDEVNetworkModuleConfig]
    
    public init(settings: VDEVMediaEditorSettings,
                networkService: VDEVMediaEditorSourceService,
                images: VDEVImageConfig,
                strings: VDEVMediaEditorStrings,
                resultSettings: VDEVMediaEditorResultSettings,
                logger: VDEVLogger? = nil,
                networkModulesConfig: [VDEVNetworkModuleConfig]) {
        self.settings = settings
        self.networkService = networkService
        self.images = images
        self.strings = strings
        self.resultSettings = resultSettings
        self.logger = logger
        self.networkModulesConfig = networkModulesConfig
    }
}

public protocol VDEVImageConfig {
    var common: VDEVMediaEditorButtonsCommonImages { get }
    var currentItem: VDEVMediaEditorButtonsCurrentItemImages { get }
    var textEdit: VDEVMediaEditorButtonsTextEditingImages { get }
    var typed: VDEVMediaEditorButtonsTypedImages { get }
    var adjustments: VDEVAdjustmentsButtonsCommonImages { get }
}


// MARK: - Common Images
public protocol VDEVAdjustmentsButtonsCommonImages {
    var blur: UIImage { get }
    var brightness: UIImage { get }
    var color: UIImage { get }
    var contrast: UIImage { get }
    var fade: UIImage { get }
    var highlights: UIImage { get }
    var magic: UIImage { get }
    var mask: UIImage { get }
    var saturation: UIImage { get }
    var shadows: UIImage { get }
    var sharpen: UIImage { get }
    var sliderThumb: UIImage { get }
    var structure: UIImage { get }
    var temperature: UIImage { get }
    var vignette: UIImage { get }
    var flip: UIImage { get }
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
    var currentItemSoundON: UIImage { get }
    var currentItemSoundOFF: UIImage { get }
    var currentItemAIFilter: UIImage { get }
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
    var blurRadius: String { get }
    var alpha: String { get }
    var sharpen: String { get }
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
    var neuralFilter: String { get }
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
    var addMusic: String { get }
    var promptImageGenerate: String { get }
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
    var removeAllLayersTitle: String { get }
    var removeAllLayersSubTitle: String { get }
    var confirm: String { get }
    var cancel: String { get }
    var aspectRatio: String { get }
    var resolution: String { get }
    var settings: String { get }
    var quality: String { get }
    var questionQualityImage: String { get }
    var sound: String { get }
    var hint: String { get }
    var submit: String { get }
    var random: String { get }
    var doingSomeMagic: String { get }
    var none: String { get }
    var temperature: String { get }
    var vignette: String { get }
    var radius: String { get }
    var flip: String { get }
    var vertical: String { get }
    var horizontal: String { get }
}
