
import SwiftUIX
import SwiftUI
import Combine

public final class VDEVMediaEditorViewModel: ObservableObject {
    private let appModules: [Module]
    private(set) var colorScheme: ColorScheme = .dark
    
    public init(config: VDEVMediaEditorConfig,
                onComplete:(@MainActor (CombinerOutput) -> ())? = nil,
                onClose: (@MainActor () -> ())? = nil) {
        
        appModules = [
            AppModule(baseChallengeId: config.baseChallengeId,
                      dataService: config.networkService,
                      images: config.images,
                      strings: config.strings,
                      output: OutputModel(onComplete: onComplete,
                                          onClose: onClose),
                      uiConfig: config.uiConfig)
        ]
        
        appModules.bootstrap()
    }
}

struct OutputModel: VDEVMediaEditorOut {
    var onComplete: (@MainActor (CombinerOutput) -> ())?
    var onClose: (@MainActor () -> ())?
}

public struct VDEVMediaEditorView: View {
    @ObservedObject private var vm: VDEVMediaEditorViewModel
    
    public init(vm: VDEVMediaEditorViewModel) {
        
        self.vm = vm
    }
    
    public var body: some View {
        MediaEditorView().preferredColorScheme(vm.colorScheme)
    }
}
