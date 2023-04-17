
import SwiftUIX

public struct VDEVMediaEditor {
    private let appModules: [Module]
    private let colorScheme: ColorScheme = .dark

    public init(baseChallengeId: String, dataService: MediaEditorSourceService) {
        appModules = [AppModule(baseChallengeId: baseChallengeId, dataService: dataService)]
        appModules.bootstrap()
    }
    
    public var rootView: some View {
        MediaEditorView().preferredColorScheme(colorScheme)
    }
}
