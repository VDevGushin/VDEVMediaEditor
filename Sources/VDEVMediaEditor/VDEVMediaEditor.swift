
import SwiftUIX
import SwiftUI
import Combine


public final class VDEVMediaEditorViewModel: ObservableObject {
    private let appModules: [Module]
    private(set) var colorScheme: ColorScheme = .dark
    
    public init(config: VDEVMediaEditorConfig,
                onComplete: @escaping (@MainActor (CombinerOutput) -> ()),
                onClose: @escaping (@MainActor () -> ())) {
        
        appModules = [
            AppModule(baseChallengeId: config.baseChallengeId,
                      dataService: config.networkService,
                      images: config.images,
                      strings: config.strings,
                      output: OutputModel(onComplete: onComplete,
                                          onClose: onClose))
        ]
        
        appModules.bootstrap()
    }
}

struct OutputModel: VDEVMediaEditorOut {
    var onComplete: (@MainActor (CombinerOutput) -> ())
    var onClose: (@MainActor () -> ())
}

public struct VDEVMediaEditorView: View {
    @StateObject private var vm: VDEVMediaEditorViewModel
    
    public init(config: VDEVMediaEditorConfig,
         onComplete: @escaping (@MainActor (CombinerOutput) -> ()),
         onClose: @escaping (@MainActor () -> ())) {
        
        self._vm = .init(wrappedValue: .init(config: config,
                                             onComplete: onComplete,
                                             onClose: onClose))
    }
    
    public var body: some View {
        MediaEditorView().preferredColorScheme(vm.colorScheme)
    }
}
