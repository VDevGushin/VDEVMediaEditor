//
//  CanvasRedactorEditorViewModel.swift
//  CameraWork
//
//  Created by Vladislav Gushin on 01.02.2023.
//

import SwiftUI
import Combine
import AVKit


final class CanvasEditorViewModel: ObservableObject {
    @Injected private var strings: VDEVMediaEditorStrings
    @Injected private var settings: VDEVMediaEditorSettings
    
    @Published var alertData: AlertData?
    @Published var ui: CanvasUISettingsViewModel = .init()
    @Published var data: CanvasLayersDataViewModel = .init()
    @Published var tools: CanvasToolsViewModel = .init()
    @Published var isLoading: LoadingModel = .false
    @Published var contentPreview: EditorPreview.Content?
    @Published private var contentPreviewDidLoad: Bool = false
    @Published var showRemoveAllAlert: Bool = false
    @Published private(set) var resultResolution: MediaResolution = .fullHD
    
    private var onPublish: (@MainActor (CombinerOutput) -> Void)?
    private var onClose: (@MainActor () -> Void)?
    
    private let builder = MediaBuilder()
    private let merger = LayersMerger()
    
    private var storage: Set<AnyCancellable> = Set()
    
    private let deviceOrientationService: DeviceOrientationService = .init()
    private let imageProcessingController = ImageProcessingController()
    
    init(onPublish: (@MainActor (CombinerOutput) -> Void)?, onClose: (@MainActor () -> Void)?) {
        isLoading = .init(value: true, message: strings.loading)
        
        self.onClose = onClose
        self.onPublish = onPublish
        
        observe(nested: self.ui).store(in: &storage)
        
        observe(nested: self.tools).store(in: &storage)
        
        observeOnMain(nested: self.data).store(in: &storage)
        
        resultResolution = settings.resolution.value
        
        deviceOrientationService.$isFaceDown
            .removeDuplicates()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                if self.showRemoveAllAlert { return }
                if self.data.isEmpty { return }
                
                self.showRemoveAllAlert = value
            }
            .store(in: &storage)
        
        merger.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case .idle:
                    self?.isLoading = .false
                    self?.contentPreview = nil
                case .inProgress:
                    self?.isLoading = .init(value: true, message: self?.strings.processing ?? "")
                case .successImage(let imageItem):
                    makeHaptics(.light)
                    self?.data.add(imageItem)
                    
                    self?.tools.showAddItemSelector(false)
                    self?.tools.openLayersList(false)
                    self?.tools.seletedTool(.concreteItem(imageItem))
                    
                    self?.isLoading = .false
                case .successVideo(let videoItem):
                    makeHaptics(.light)
                    self?.data.add(videoItem)
                    
                    self?.tools.showAddItemSelector(false)
                    self?.tools.openLayersList(false)
                    self?.tools.seletedTool(.concreteItem(videoItem))
                    
                    self?.isLoading = .false
                case .error(let error):
                    makeHaptics(.light)
                    self?.isLoading = .false
                    self?.contentPreview = nil
                    self?.alertData = .init(error)
                }
            }
            .store(in: &storage)
        
        builder.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case .idle:
                    self?.isLoading = .false
                    self?.contentPreview = nil
                case .inProgress:
                    self?.isLoading = .init(value: true, message: self?.strings.processing ?? "")
                case .success(let combinerOutput):
                    makeHaptics(.light)
                    self?.contentPreview = .init(model: combinerOutput)
                    self?.isLoading = .false
                case .error(let error):
                    makeHaptics(.light)
                    self?.isLoading = .false
                    self?.contentPreview = nil
                    self?.alertData = .init(error)
                }
            }
            .store(in: &storage)

        settings.isLoading.combineLatest(ui.$editorSize, $contentPreviewDidLoad)
            .map { return !$0.0 && ($0.1 != .zero) && $0.2}
            .removeDuplicates()
            .sink { [weak self] value in
                if value { self?.getStartTemplate() }
            }
            .store(in: &storage)
    }
    
    deinit { Log.d("❌ Deinit: CanvasEditorViewModel") }
    
    func onBuildMedia() {
        builder.makeMediaItem(layers: data.layers.elements,
                              size: ui.editorSize,
                              backgrondColor: ui.mainLayerBackgroundColor,
                              resolution: resultResolution)
    }
    
    func onMergeMedia(_ layers: [CanvasItemModel]) {
        merger.merge(layers: layers, on: ui.editorSize)
    }
    
    func contentViewDidLoad() {
        self.contentPreviewDidLoad = true
    }
}

// FIXME: - Перенести в другое место
extension CanvasEditorViewModel {
    func removeBackground(on item: CanvasItemModel,
                          completion: @escaping (CanvasItemModel) -> Void) {
        isLoading = .init(value: true, message: strings.processing)
        imageProcessingController.removeBackground(on: item) { [weak self] new in
            self?.data.delete(item)
            self?.data.add(new)
            self?.isLoading = .false
            completion(new)
        }
    }
}

// MARK: - Get started template
extension CanvasEditorViewModel {
    func getStartTemplate() {
        isLoading = .init(value: true, message: strings.loading)
        data.getStartTemplate(size: ui.editorSize) { [weak self] in
            self?.isLoading = .false
        }
    }
}


// MARK: - Remove all after screen down
extension CanvasEditorViewModel {
    func removeAllLayers() {
        tools.showAddItemSelector(false)
        tools.seletedTool(.empty)
        data.removeAll()
        tools.openLayersList(true)
    }
}

// MARK: - Resolution
extension CanvasEditorViewModel {
    func set(resolution: MediaResolution) {
        resultResolution = resolution
    }
}

// MARK: - Global actions to output
extension CanvasEditorViewModel {
    @MainActor
    func onCloseEditor() {
       onClose?()
    }
    
    @MainActor
    func onPublishResult(output: CombinerOutput) {
        if onPublish != nil {
            isLoading = .init(value: true, message: strings.processing)
            onPublish?(output)
        }
    }
}
