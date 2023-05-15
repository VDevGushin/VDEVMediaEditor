
import SwiftUIX
import SwiftUI
import Combine


public final class VDEVMediaEditorViewModel: ObservableObject {
    private(set) var colorScheme: ColorScheme = .dark
    
    public init(config: VDEVMediaEditorConfig) {
        DiController.register(settings: config.settings,
                              dataService: config.networkService,
                              images: config.images,
                              strings: config.strings,
                              resultSettings: config.resultSettings,
                              logger: config.logger)
    }
    
    deinit {
        Log.d("❌ Deinit: VDEVMediaEditorViewModel")
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
