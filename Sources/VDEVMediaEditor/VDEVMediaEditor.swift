
import SwiftUIX
import SwiftUI
import Combine
import Resolver

public final class VDEVMediaEditorViewModel: ObservableObject {
    private var appModules: [Module]
    private(set) var colorScheme: ColorScheme = .dark
    
    public init(config: VDEVMediaEditorConfig) {
        
        appModules = [
            AppModule(baseChallengeId: config.baseChallengeId,
                      dataService: config.networkService,
                      images: config.images,
                      strings: config.strings,
                      uiConfig: config.uiConfig)
        ]
        
        appModules.bootstrap()
    }
    
    deinit {
        appModules.removeAll()
        Resolver.reset()
    }
}

public struct VDEVMediaEditorView: View {
    @ObservedObject private var vm: VDEVMediaEditorViewModel
    private var onPublish: (@MainActor (CombinerOutput) -> Void)?
    private var onClose: (@MainActor () -> Void)?
    
    public init(vm: VDEVMediaEditorViewModel,
                onPublish: (@MainActor (CombinerOutput) -> Void)? = nil,
                onClose: (@MainActor () -> Void)? = nil) {
        self.onClose = onClose
        self.onPublish = onPublish
        self.vm = vm
    }
    
    public var body: some View {
        MediaEditorView(onPublish: onPublish,
                        onClose: onClose).preferredColorScheme(vm.colorScheme)
    }
}
