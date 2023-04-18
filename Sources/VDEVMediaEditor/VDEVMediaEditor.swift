
import SwiftUIX
import SwiftUI

public struct VDEVMediaEditor {
    private let appModules: [Module]
    private let colorScheme: ColorScheme = .dark
    
    public init(config: VDEVMediaEditorConfig) {
        
        appModules = [
            AppModule(baseChallengeId: config.baseChallengeId,
                      dataService: config.networkService,
                      images: config.images,
                      strings: config.strings)
        ]
        
        appModules.bootstrap()
    }
    
    public var rootView: some View {
        MediaEditorView().preferredColorScheme(colorScheme)
    }
}
