//
//  ExampleConfig.swift
//  MediaEditorSample
//
//  Created by Vladislav Gushin on 15.05.2023.
//

import UIKit
import Combine
import VDEVEditorFramework
import OSLog

/*
 - Main
 - Subscription
 - Security
 - Editor Settings
 - Canvas
 - Images
 - Strings
 - Neural Config
 - Logger
 - Result
 */

// MARK: - Main
extension VDEVMediaEditorConfig {
    static var exampleConfig: Self {
        
        // let id = "f4ae6408-4dde-43fe-b52d-f9d87a0e68c4"
       // let id = "9b22fbb1-554c-4e6b-94a6-96793028c20b"
       // let id = "d8281e91-4768-4e1f-9e33-24a0ee160acc"
        let id = "df04ed9e-e768-4e3c-ba52-66773d98a4a6"
        // let id = "4b09ff7b-8978-45fd-91f7-af10d6bcb529"
        
        let repository = VDEVMediaEditorResourceRepository(
            baseChallengeId: id,
            sourceService: NetworkAdapter(client: NetworkClientImpl())
        )
        
        return .init(
            security: Security(),
            subscription: Subscription(),
            settings: EditorSettings(repository: repository),
            repository: repository,
            images: Images(),
            strings: Strings(),
            resultSettings: ResultSettings(),
            logger: Logger(),
            networkModulesConfig: [Imge2ImageModuleConfig()]
        )
    }
}

// MARK: - Subscription
private final class Subscription: VDEVMediaEditorSubscription {
    var status: VDEVMediaEditorSubscriptionStatus
    
    func status(completion: (VDEVMediaEditorSubscriptionStatus) -> Void) {
        status = .unSubscribed
        completion(status)
    }
    
    init(status: VDEVMediaEditorSubscriptionStatus = .unSubscribed) {
        self.status = status
    }
}

// MARK: - Security
private final class Security: VDEVMediaEditorSecurity {
    var apiKey: String { "2671176eac-0370c6-20244bd3-8a93-f738506a7fd2_sample" }
}
      
// MARK: - Editor Settings
private final class EditorSettings: VDEVMediaEditorSettings {
    private(set) var title: String = ""
    private(set) var subTitle: String? = nil
    
    private(set) var neetToGetStartMeta: Bool = false //нужна ли загрузка стартовой меты
    
    private(set) var hasAttachedMasks: Bool = false
    private(set) var hasAttachedFilters: Bool = false
    private(set) var hasAttachedTextures: Bool = false
    private(set) var hasAttachedNeuralFilters: Bool = true
    private(set) var hasAttachedTemplates: Bool = false
    private(set) var hasAttachedStickerPacks: Bool = false
    
    private(set) var repository: VDEVMediaEditorResourceRepository
    private(set) var isLoading = CurrentValueSubject<Bool, Never>(true)
    
    var aspectRatio: CGFloat? { 9/16 }
    // var aspectRatio: CGFloat? { nil }
    var isInternalModule: Bool { false }
    var needGuideLinesGrid: Bool { true }
    var showCommonSettings: Bool { true }
    var showAspectRatioSettings: Bool { true }
    var canTurnOnSoundInVideos: Bool { true }
    var canAddMusic: Bool { false }
    var historyLimit: Int { 200 }
    var maximumLayers: Int { 20 }
    var canRemoveAllLayers: Bool { true }
    var canMergeAllLayers: Bool { true }
    var canShowOnboarding: Bool { true }
    var canUndo: Bool { true }
    var сanRemoveOrChangeTemplate: Bool { true }
    var showNeuralFilters: Bool { true }
    
    var canLockAllEditor: Bool { true }
    var isLocked: CurrentValueSubject<Bool, Never> = .init(false)
    
    var canvasSettings: VDEVMediaEditorCanvasSettings = {
        CanvasSettings()
    }()
    
    init(repository: VDEVMediaEditorResourceRepository) {
        defer { getMeta() }
        self.repository = repository
    }
    
    private func getMeta() {
        title = "SHARE YOUR RESULT!"
        subTitle = "+ ADD MEDIA"
        
        Task(priority: .high) {
            isLoading.send(true)
            await repository.execute()
            
            guard neetToGetStartMeta else {
                isLoading.send(false)
                return
            }
            
            let meta = await repository.meta
            
            await MainActor.run { [weak self] in
                guard let self = self else { return }
                self.title = meta.title
                self.subTitle = meta.subTitle
                self.hasAttachedMasks = meta.hasAttachedMasks
                self.hasAttachedFilters = meta.hasAttachedFilters
                self.hasAttachedTextures = meta.hasAttachedTextures
                self.hasAttachedTemplates = meta.hasAttachedTemplates
                self.hasAttachedStickerPacks = meta.hasAttachedStickerPacks
                self.hasAttachedNeuralFilters = meta.hasAttachedNeuralFilters
                self.isLoading.send(false)
            }
        }
    }
    
    func getStartTemplate(
        for size: CGSize,
        completion: @escaping ([TemplatePack.Variant.Item]?) -> Void
    ) {
        guard hasAttachedTemplates else {
            return completion(nil)
        }
        
        Task(priority: .high) {
            let attached = await repository.attachedTemplate(
                challengeTitle: title,
                renderSize: size
            )
            await MainActor.run {
                completion(attached)
            }
        }
    }
}

// MARK: - Canvas
struct CanvasSettings: VDEVMediaEditorCanvasSettings {
    private(set) var maxBlur: CGFloat = 0.0
    private(set) var minBlur: CGFloat = 2
    private(set) var superMinBlur: CGFloat = 20
    
    private(set) var maxOpacity: CGFloat = 1.0
    private(set) var minOpacity: CGFloat = 0.6
    private(set) var superMinOpacity: CGFloat = 0.2
}

// MARK: - Images
private struct Images: VDEVImageConfig {
    let common: VDEVMediaEditorButtonsCommonImages = Common()
    
    var currentItem: VDEVMediaEditorButtonsCurrentItemImages = CurrentItem()
    
    var currentItemAttached: VDEVMediaEditorButtonsCurrentItemAttachedImages = CurrentItemAttached()
    
    var textEdit: VDEVMediaEditorButtonsTextEditingImages = TextEdit()
    
    var typed: VDEVMediaEditorButtonsTypedImages = Typed()
    
    var typedAttached: VDEVMediaEditorButtonsTypedAttachedImages = TypedAttached()
    
    var adjustments: VDEVAdjustmentsButtonsCommonImages = AdjustmentsItem()
    
    struct CurrentItemAttached: VDEVMediaEditorButtonsCurrentItemAttachedImages {
        var currentItemFilterAttached: UIImage = .init(named: "CurrentItemFilterAttached")!
        var currentItemMaskAttached: UIImage = .init(named: "CurrentItemMaskAttached")!
        var currentItemTextureAttached: UIImage = .init(named: "CurrentItemTextureAttached")!
        var currentItemAIFilterAttached: UIImage = .init(named: "CurrentItemAIFilterAttached")!
    }
    
    struct TypedAttached: VDEVMediaEditorButtonsTypedAttachedImages {
        var typeStickers: UIImage = .init(named: "TypeStickersAttached")!
        var typeTemplate: UIImage = .init(named: "TypeTemplateAttached")!
    }
    
    struct AdjustmentsItem: VDEVAdjustmentsButtonsCommonImages {
        var blur: UIImage = .init(named: "blur")!
        var brightness: UIImage = .init(named: "brightness")!
        var color: UIImage = .init(named: "color")!
        var contrast: UIImage = .init(named: "contrast")!
        var fade: UIImage = .init(named: "fade")!
        var highlights: UIImage = .init(named: "highlights")!
        var magic: UIImage = .init(named: "magic")!
        var mask: UIImage = .init(named: "mask")!
        var saturation: UIImage = .init(named: "saturation")!
        var shadows: UIImage = .init(named: "shadows")!
        var sharpen: UIImage = .init(named: "sharpen")!
        var sliderThumb: UIImage = .init(named: "slider_thumb")!
        var structure: UIImage = .init(named: "structure")!
        var temperature: UIImage = .init(named: "temperature")!
        var vignette: UIImage = .init(named: "vignette")!
        var flip: UIImage = .init(named: "flip")!
    }
    
    struct CurrentItem: VDEVMediaEditorButtonsCurrentItemImages {
        var currentIteDublicate: UIImage = .init(named: "CurrentIteDublicate")!
        var currentItemAdjustments: UIImage = .init(named: "CurrentItemAdjustments")!
        var currentItemBringToBottom: UIImage = .init(named: "CurrentItemBringToBottom")!
        var currentItemBringToTop: UIImage = .init(named: "CurrentItemBringToTop")!
        var currentItemCrop: UIImage = .init(named: "CurrentItemCrop")!
        var currentItemDown: UIImage = .init(named: "CurrentItemDown")!
        var currentItemEditText: UIImage = .init(named: "CurrentItemEditText")!
        var currentItemFilter: UIImage = .init(named: "CurrentItemFilter")!
        var currentItemMask: UIImage = .init(named: "CurrentItemMask")!
        var currentItemReset: UIImage = .init(named: "CurrentItemReset")!
        var currentItemRM: UIImage = .init(named: "CurrentItemRM")!
        var currentItemRMBack: UIImage = .init(named: "CurrentItemRMBack")!
        var currentItemTexture: UIImage = .init(named: "CurrentItemTexture")!
        var currentItemUp: UIImage = .init(named: "CurrentItemUp")!
        var currentItemMerge: UIImage = .init(named: "CurrentItemMerge")!
        var currentItemSoundON: UIImage = .init(named: "CurrentItemSoundON")!
        var currentItemSoundOFF: UIImage = .init(named: "CurrentItemSoundOFF")!
        var currentItemAIFilter: UIImage = .init(named: "CurrentItemAIFilter")!
    }
    
    struct TextEdit: VDEVMediaEditorButtonsTextEditingImages {
        var textEditingAlignCenter: UIImage = .init(named: "TextEditingAlignCenter")!
        var textEditingAlignLeft: UIImage = .init(named: "TextEditingAlignleft")!
        var textEditingAlignRight: UIImage = .init(named: "TextEditingAlignright")!
        var textEditingColorSelectIcon: UIImage = .init(named: "TextEditingColorSelectIcon")!
        var textEditingRemoveText: UIImage = .init(named: "TextEditingRemoveText")!
    }
    
    struct Typed: VDEVMediaEditorButtonsTypedImages {
        var typeCamera: UIImage = .init(named: "TypeCamera")!
        var typeDraw: UIImage = .init(named: "TypeDraw")!
        var typePaste: UIImage = .init(named: "TypePaste")!
        var typePhoto: UIImage = .init(named: "TypePhoto")!
        var typeStickers: UIImage = .init(named: "TypeStickers")!
        var typeTemplate: UIImage = .init(named: "TypeTemplate")!
        var typeText: UIImage = .init(named: "TypeText")!
        var typeVideo: UIImage = .init(named: "TypeVideo")!
    }
    
    struct Common: VDEVMediaEditorButtonsCommonImages {
        var add: UIImage = .init(named: "Add")!
        var addMediaM: UIImage = .init(named: "AddMediaM")!
        var backArrow: UIImage = .init(named: "BackArrow")!
        var bg: UIImage = .init(named: "Bg")!
        var close: UIImage = .init(named: "Close")!
        var fontBGSelect: UIImage = .init(named: "FontBGSelectIcon")!
        var fontSelect: UIImage = .init(named: "FontSelectIcon")!
        var photoVideoCapture: UIImage = .init(named: "iconCapture")!
        var iGStories: UIImage = .init(named: "IGStories")!
        var layers: UIImage = .init(named: "Layers")!
        var share: UIImage = .init(named: "Share")!
        var xmark: UIImage = .init(named: "Xmark")!
        var resultGradient: UIImage = .init(named: "BackGradient")!
        var undo: UIImage = .init(named: "Undo")!
    }
}

// MARK: - Strings
private struct Strings: VDEVMediaEditorStrings {
    let photos = "Photos"
    let videos = "Videos"
    let addPhotoOrVideo = "MEDIA"
    let paste = "PASTE"
    let brightness = "BRIGHTNESS"
    let contrast = "CONTRAST"
    let saturation = "SATURATION"
    let highlight = "HIGHLIGHT"
    let shadow = "SHADOW"
    let alpha = "OPACITY"
    let blurRadius = "BLUR"
    let `default` = "DEFAULT"
    let mask = "MASK"
    let filter = "FILTER"
    let texture = "TEXTURE"
    let adjustments = "COLOR"
    let crop = "CROP"
    let removeBack = "REMOVE BG"
    let editText = "EDIT"
    let dublicate = "DUPLICATE"
    let reset = "RESET"
    let remove = "REMOVE"
    let up = "UP"
    let down = "DOWN"
    let bringToTop = "TOP"
    let bringToBottom = "BOTTOM"
    let selectMedia = "SELECT MEDIA"
    let colorFilter = "COLOR FILTER"
    let neuralFilter = "NEURAL"
    let close = "CLOSE"
    let layers = "LAYERS"
    let templatePack = "TEMPLATE PACK"
    let addMedia = "ADD MEDIA"
    let challengeTitle = "TEST"
    let shareOrSave = "SHARE\nOR SAVE"
    let template = "TEMPLATE"
    let text = "TEXT"
    let stickersCustom = "STICKER"
    let addPhoto = "PHOTO"
    let promptImageGenerate = "AI IMAGE"
    let addVideo = "VIDEO"
    let camera = "CAMERA"
    let drawing = "DRAWING"
    let background = "BG"
    let error = "ERROR"
    let ok = "OK"
    let publish = "PUBLISH"
    let see = "SEE"
    let answers = "ANSWERS"
    let defaultPlaceholder = "WRITE HERE"
    let delete = "DELETE"
    let done = "DONE"
    let `continue` = "CONTINUE"
    let processing = "PROCESSING"
    let loading = "LOADING"
    let applied = "APPLIED"
    let templates = "templates"
    let merge = "MERGE"
    let confirm = "Confirm"
    let cancel = "Cancel"
    let removeAllLayersTitle = "Remove all layers"
    let removeAllLayersSubTitle = "Are you sure that you want to clear the canvas?"
    let aspectRatio = "RATIO"
    let resolution = "RESOLUTION"
    let settings = "SETTINGS"
    let quality = "QUALITY"
    let questionQualityImage = "AUTO"
    let sound = "SOUND"
    let hint = "+ ADD MEDIA"
    let addMusic = "MUSIC"
    let submit = "SUBMIT"
    let random = "RANDOM"
    let doingSomeMagic = "DOING SOME\nMAGIC"
    let sharpen = "SHARPEN"
    let none = "NONE"
    let vignette = "VIGNETTE"
    let temperature = "TEMP"
    let radius = "RADIUS"
    let flip = "FLIP"
    let vertical = "VERTICAL"
    let horizontal = "HORIZONTAL"
}

// MARK: - Neural Config
private struct Imge2ImageModuleConfig: VDEVNetworkModuleConfig {
    //Продакшн: https://app.w1d1.com/api/v2/fileProcessing/stable-diffusion/app/image-to-image`
    //Test: https://app.w1d1.com/api/v2/fileProcessing/stable-diffusion/test/image-to-image`
    var type: VDEVNetworkModuleConfigType = .image2image
    var host: String = "app.w1d1.com"
    var path: String = "/api/v2/fileProcessing/stable-diffusion/app/image-to-image"
    var headers: [String : String]? = [
        "id": "a3542326-e295-4ab0-acdb-596928f15015",
        "x-w1d1-version": Bundle.main.shortVersion
    ]
    var timeOut: TimeInterval { 60 }
    var token: String? = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJhMzU0MjMyNi1lMjk1LTRhYjAtYWNkYi01OTY5MjhmMTUwMTUifQ.IpBFC6qaEXFaRs6cFk30nzBkjr2f54ipb6Ch7azXTCs"
}

// MARK: - Logger
private final class Logger: VDEVLogger {
    func e(_ message: Any) {
        print("===>", message)
    }
    
    func i(_ message: Any) {
        print("===>", message)
    }
    
    func d(_ message: Any) {
        print("===>", message)
    }
    
    func v(_ message: Any) {
        print("===>", message)
    }
    
    func w(_ message: Any) {
        print("===>", message)
    }
    
    func s(_ message: Any) {
        print("===>", message)
    }
}

// MARK: - Result
final class ResultSettings: VDEVMediaEditorResultSettings {
    var needAutoEnhance: CurrentValueSubject<Bool, Never> = .init(false)
    var resolution: VDEVMediaResolution { .fullHD }
    var maximumVideoDuration: Double { 15.0 }
}
