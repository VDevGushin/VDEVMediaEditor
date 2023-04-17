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
                  networkService: NetworkAdapter(client: NetworkClientImpl()))
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
