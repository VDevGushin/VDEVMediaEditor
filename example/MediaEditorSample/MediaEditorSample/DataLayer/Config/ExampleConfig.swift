//
//  ExampleConfig.swift
//  MediaEditorSample
//
//  Created by Vladislav Gushin on 15.05.2023.
//

import UIKit
import Combine
import VDEVMediaEditor

extension VDEVMediaEditorConfig {
    static var exampleConfig: Self {
        let source = NetworkAdapter(client: NetworkClientImpl())
        //let id = "f4ae6408-4dde-43fe-b52d-f9d87a0e68c4"
        // let id = "9b22fbb1-554c-4e6b-94a6-96793028c20b"
        let id = "d8281e91-4768-4e1f-9e33-24a0ee160acc"
       // let id = "df04ed9e-e768-4e3c-ba52-66773d98a4a6"
        //let id = "d32cb5c8-5810-437a-a895-1ca43983d253"
        return .init(
            security: Security(),
            settings: EditorSettings(id, sourceService: source),
            networkService: source,
            images: Images(),
            strings: Strings(),
            resultSettings: ResultSettings(),
            logger: Logger(),
            networkModulesConfig: [Imge2ImageModuleConfig()]
        )
    }
}

struct Security: VDEVMediaEditorSecurity {
    var apiKey: String {
        "2671176eac-0370c6-20244bd3-8a93-f738506a7fd2_sample"
    }
}

struct Imge2ImageModuleConfig: VDEVNetworkModuleConfig {
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

final class Logger: VDEVLogger {
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

final class ResultSettings: VDEVMediaEditorResultSettings {
    var needAutoEnhance: CurrentValueSubject<Bool, Never> = .init(false)
    var resolution: VDEVMediaResolution { .fullHD }
    var maximumVideoDuration: Double { 15.0 }
}

final class EditorSettings: VDEVMediaEditorSettings {
    private(set) var resourceID: String
    private(set) var title: String = ""
    private(set) var subTitle: String? = nil
    private(set) var withAttach: Bool = false
    
    private(set) var sourceService: VDEVMediaEditorSourceService
    private(set) var isLoading = CurrentValueSubject<Bool, Never>(true)
    
    // var aspectRatio: CGFloat? { 9/16 }
    var aspectRatio: CGFloat? { nil }
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
    var canShowOnboarding: Bool { false }
    var canUndo: Bool { true }
    var сanRemoveOrChangeTemplate: Bool { true }
    var showNeuralFilters: Bool { true }
    
    init(_ resourceID: String,
         sourceService: VDEVMediaEditorSourceService) {
        defer {
            getMeta()
        }
        self.resourceID = resourceID
        self.sourceService = sourceService
    }
    
    private func getMeta() {
        isLoading.send(true)
        title = "SHARE YOUR RESULT!"
        subTitle = "+ ADD MEDIA"
        withAttach = false
        self.isLoading.send(false)
//        isLoading.send(true)
//        Task {
//            let meta = await sourceService.startMeta(forChallenge: resourceID) ?? .init(isAttachedTemplate: false, title: "", subTitle: "")
//
//            await MainActor.run { [weak self] in
//                guard let self = self else { return }
//                self.title = meta.title
//                self.subTitle = meta.subTitle
//                self.withAttach = meta.isAttachedTemplate
//                self.isLoading.send(false)
//            }
//        }
    }
    
    func getStartTemplate(for size: CGSize,
                          completion: @escaping ([TemplatePack.Variant.Item]?) -> Void) {
        guard withAttach else { return completion(nil) }
        
        Task {
            guard let templatesDataSource = try? await sourceService.editorTemplates(forChallenge: resourceID, challengeTitle: title, renderSize: size) else {
                await MainActor.run { completion(nil) }
                return
            }
            
            await MainActor.run {
                let attached = templatesDataSource.first { $0.isAttached }?.variants.first?.items
                completion(attached)
            }
        }
    }
}

struct Images: VDEVImageConfig {
    let common: VDEVMediaEditorButtonsCommonImages = Common()
    
    var currentItem: VDEVMediaEditorButtonsCurrentItemImages = CurrentItem()
    
    var textEdit: VDEVMediaEditorButtonsTextEditingImages = TextEdit()
    
    var typed: VDEVMediaEditorButtonsTypedImages = Typed()
    
    var adjustments: VDEVAdjustmentsButtonsCommonImages = AdjustmentsItem()
    
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

struct Strings: VDEVMediaEditorStrings {
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
    let adjustments = "ADJUSTMENTS"
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
    let neuralFilter = "AI FILTER"
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
