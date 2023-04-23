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
    
    @Published var canvas = PKCanvasView()
    @Published var toolPicker = PKToolPicker()
    @Published var drawingCanvas = UIView()
    @Published var isLoading = false
    
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

struct DrawingView: View {
    @StateObject private var vm: DrawingViewModel
    
    let onClose: (DrawingViewOutput?) -> Void
    
    init(_ size: CGSize, onClose: @escaping (DrawingViewOutput?) -> Void) {
        self.onClose = onClose
        self._vm = .init(wrappedValue: .init(size: size))
    }
    
    var body: some View {
        ZStack(alignment: .top){
            GeometryReader { proxy in
                ZStack {
                    AppColors.blackWithOpacity1
                    
                    DrawingCanvasView(canvas: $vm.canvas,
                                      drawingCanvas: $vm.drawingCanvas,
                                      toolPicker: $vm.toolPicker,
                                      rect: proxy.frame(in: .global).size)
                }
            }
            
            //RoundButton(systemName: "arrow.uturn.backward") { vm.deleteDrawing() }
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
    @Binding var canvas: PKCanvasView
    @Binding var drawingCanvas: UIView
    @Binding var toolPicker: PKToolPicker
    
    var rect: CGSize
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvas.isOpaque = false
        canvas.backgroundColor = .clear
        
        drawingCanvas.frame = .init(x: 0, y: 0, width: rect.width, height: rect.height)
        drawingCanvas.contentMode = .scaleAspectFit
        drawingCanvas.clipsToBounds = true
        drawingCanvas.backgroundColor = .clear
        
        canvas.subviews[0].addSubview(drawingCanvas)
        canvas.subviews[0].sendSubviewToBack(drawingCanvas)
        
        canvas.overrideUserInterfaceStyle = .dark
        toolPicker.overrideUserInterfaceStyle = .dark
        
        setup()
        
        return canvas
    }
    
    static func dismantleUIView(_ uiView: PKCanvasView, coordinator: ()) {
        uiView.removeFromSuperview()
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        setup()
    }
    
    private func setup() {
        DispatchQueue.main.async {
            canvas.drawingPolicy = .default
            toolPicker.addObserver(canvas)
            toolPicker.setVisible(true, forFirstResponder: canvas)
            canvas.tool = PKInkingTool(.pen, color: AppColors.red.uiColor, width: 10)
            canvas.becomeFirstResponder()
        }
    }
}

