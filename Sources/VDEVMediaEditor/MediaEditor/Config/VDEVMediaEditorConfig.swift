//
//  File.swift
//  
//
//  Created by Vladislav Gushin on 17.04.2023.
//

import Foundation
import UIKit

public struct VDEVMediaEditorConfig {
    // challenge id
    private(set) var baseChallengeId: String
    // network service
    private(set) var networkService: MediaEditorSourceService
    // images
    private(set) var images: VDEVImageConfig
    
    public init(challengeId: String,
                networkService: MediaEditorSourceService,
                images: VDEVImageConfig) {
        self.baseChallengeId = challengeId
        self.networkService = networkService
        self.images = images
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
}

// MARK: - Text editing tools
public protocol VDEVMediaEditorButtonsTextEditingImages {
    var textEditingAlignCenter: UIImage { get }
    var textEditingAlignleft: UIImage { get }
    var textEditingAlignright: UIImage { get }
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
