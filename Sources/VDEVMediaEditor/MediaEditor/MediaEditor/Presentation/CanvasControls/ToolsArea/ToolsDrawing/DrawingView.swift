//
//  DrawingView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 08.02.2023.
//

import SwiftUI
import PencilKit
import Combine

struct DrawingViewOutput {
    let image: UIImage
    let offset: CGSize
    let bounds: CGRect
}

final class DrawingViewModel: NSObject,
                              ObservableObject,
                              PKCanvasViewDelegate {
    
    @Published var isLoading = false
    var canvas = PKCanvasView()
    let toolPicker = PKToolPicker()
    
    
    private let size: CGSize
    
    init(size: CGSize) {
        self.size = size
        super.init()
        canvas.delegate = self
    }
    
    deinit {
        cancelDrawing()
        Log.d("❌ Deinit: DrawingViewModel")
    }
    
    func getImage(_ completion: @escaping (DrawingViewOutput?) -> Void) {
        isLoading = true
        canvas.traitCollection.performAsCurrent { [weak self] in
            defer {
                self?.isLoading = false
                self?.cancelDrawing()
            }
            
            guard let self = self else { return }
            
            if self.canvas.drawing.bounds.isNull { return completion(nil) }
            
            let offset = self.canvas.bounds.getOffset(for: self.canvas.drawing.bounds)
            
            let image = self.canvas.drawing.image(from: self.canvas.drawing.bounds, scale: UIScreen.main.scale)
            
            completion(.init(image: image, offset: offset, bounds: self.canvas.drawing.bounds))
        }
    }
    
    func cancelDrawing() {
        canvas.drawing.strokes.removeAll()
        canvas.resignFirstResponder()
        canvas.delegate = nil
        toolPicker.removeObserver(canvas)
        toolPicker.setVisible(false, forFirstResponder: canvas)
        canvas = PKCanvasView()
    }
    
    func deleteDrawing() {
        _ = canvas.drawing.strokes.popLast()
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) { }
}

@MainActor
struct DrawingView: View {
    @StateObject private var vm: DrawingViewModel
    
    let onClose: (DrawingViewOutput?) -> Void
    
    init(_ size: CGSize, onClose: @escaping (DrawingViewOutput?) -> Void) {
        self.onClose = onClose
        self._vm = .init(wrappedValue: .init(size: size))
    }
    
    var body: some View {
        ZStack(alignment: .top){
            ZStack {
                AppColors.blackWithOpacity1
                
                DrawingCanvasView(canvas: vm.canvas,
                                  toolPicker: vm.toolPicker)
            }
            
            BackButton {
                vm.getImage(onClose)
            }
            .padding()
            .topTool()
            .leftTool()
            
        }
        .overlay(alignment: .center) {
            LoadingView(inProgress: vm.isLoading, style: .large)
        }
    }
}

private struct DrawingCanvasView: UIViewRepresentable {
    var canvas: PKCanvasView
    var toolPicker: PKToolPicker
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        canvas.overrideUserInterfaceStyle = .dark
        canvas.drawingPolicy = .anyInput
        
        canvas.tool = PKInkingTool(.marker, color: .red, width: 15)
        
        toolPicker.overrideUserInterfaceStyle = .dark
        
        canvas.becomeFirstResponder()
        
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        
        
        return canvas
    }
    
    static func dismantleUIView(_ uiView: PKCanvasView, coordinator: ()) {
        uiView.removeFromSuperview()
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) { }
}

