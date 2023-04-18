//
//  ContentView.swift
//  MediaEditorSample
//
//  Created by Vladislav Gushin on 17.04.2023.
//

import SwiftUI
import VDEVMediaEditor

struct ContentView: View {
    private let mediaEditorEntryPoint: VDEVMediaEditor
    
    init() {
        let config: VDEVMediaEditorConfig  =
            .init(challengeId: "f4ae6408-4dde-43fe-b52d-f9d87a0e68c4",
                  networkService: NetworkAdapter(client: NetworkClientImpl()),
                  images: Images())
        mediaEditorEntryPoint = .init(config: config)
    }
    
    var body: some View {
        mediaEditorEntryPoint.rootView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Images: VDEVImageConfig {
    let common: VDEVMediaEditorButtonsCommonImages = Common()

    var currentItem: VDEVMediaEditorButtonsCurrentItemImages = CurrentItem()

    var textEdit: VDEVMediaEditorButtonsTextEditingImages = TextEdit()

    var typed: VDEVMediaEditorButtonsTypedImages = Typed()
    
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
    }
}

