//
//  DrawingView.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 08.02.2023.
//

import SwiftUI
import PencilKit

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
            
            HStack {
                RoundButton(systemName: "arrow.uturn.backward") { vm.deleteDrawing() }
                
                Spacer()
                
                RoundButton(systemName: "checkmark") { vm.getImage(onClose) }
            }
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
        
        let subviews = canvas.subviews[0]
        subviews.addSubview(drawingCanvas)
        subviews.sendSubviewToBack(drawingCanvas)
        canvas.overrideUserInterfaceStyle = .dark
        toolPicker.overrideUserInterfaceStyle = .dark
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        canvas.becomeFirstResponder()
        canvas.tool = PKInkingTool(.pen, color: AppColors.red.uiColor, width: 10)
        
        return canvas
    }
    
    static func dismantleUIView(_ uiView: PKCanvasView, coordinator: ()) {
        uiView.removeFromSuperview()
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) { }
}

