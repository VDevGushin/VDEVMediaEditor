//
//  AIImageGeneratorView.swift
//  
//
//  Created by Vladislav Gushin on 08.07.2023.
//

import SwiftUI

@available(iOS 16.2, *)
struct AIImageGeneratorView: View {
    @StateObject private var vm: AIImageGeneratorVM
    @State private var showErrorPopover = false
    
    init(_ pipeline: Pipeline) {
        self._vm = .init(wrappedValue: .init(pipeline: pipeline))
    }
    
    var body: some View {
        switch vm.state {
        case let .complete(text, image, speed, interval):
            Rectangle().fill(.green)
        case let.failed(error):
            ErrorWithDetails("Generation error", error: error)
        case let .running(progress):
            VStack {
                if let progress = progress, progress.stepCount > 0 {
                    let step = Int(progress.step) + 1
                    let fraction = Double(step) / Double(progress.stepCount)
                    HStack {
                        Text("Generating \(Int(round(100*fraction)))%")
                        
                    }
                } else {
                    HStack {
                        Text("Preparing model…")
                    }
                }
                Button("Cancel") {
                    vm.cancelGeneration()
                }
            }
        case .startup, .userCanceled:
            VStack {
                TextField("Positive prompt", text: $vm.positivePrompt,
                          axis: .vertical).lineLimit(5)
                    .textFieldStyle(.roundedBorder)
                    .listRowInsets(EdgeInsets(top: 0, leading: -20, bottom: 0, trailing: 20))
                
                TextField("Negative prompt", text: $vm.negativePrompt,
                          axis: .vertical).lineLimit(5)
                    .textFieldStyle(.roundedBorder)
                
                HStack {
                    Button("generate") {
                        vm.submit()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func ErrorWithDetails(_ message: String, error: Error) -> some View {
        HStack {
            Text(message)
            Spacer()
            Button {
                showErrorPopover.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showErrorPopover) {
                VStack {
                    Text(verbatim: "\(error)")
                    .lineLimit(nil)
                    .padding(.all, 5)
                    Button {
                        showErrorPopover.toggle()
                    } label: {
                        Text("Dismiss").frame(maxWidth: 200)
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}
