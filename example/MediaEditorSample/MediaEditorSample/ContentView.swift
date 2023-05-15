//
//  ContentView.swift
//  MediaEditorSample
//
//  Created by Vladislav Gushin on 17.04.2023.
//

import SwiftUI
import VDEVMediaEditor
import Combine

struct ContentView: View {
    private let config: VDEVMediaEditorConfig = .exampleConfig
    private let vm: VDEVMediaEditorViewModel
    
    init() {
        vm = .init(config: config)
    }
    
    var body: some View {
        VDEVMediaEditorView(vm: vm)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
