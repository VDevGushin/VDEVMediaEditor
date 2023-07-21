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
    @Injected private var resultSettings: VDEVMediaEditorResultSettings
    @Injected private var resolutionService: ResolutionService
    @Injected private var removeLayersService: RemoveLayersService
    @Injected private var mementoService: MementoService
    @Injected private var merger: LayersMerger
    @Injected private var imageProcessingController: ImageProcessingController
    
    // VM
    @Published var ui: CanvasUISettingsViewModel = .init()
    @Published var data: CanvasLayersDataViewModel = .init()
    @Published var tools: CanvasToolsViewModel = .init()
    
    @Published private(set) var resultResolution: MediaResolution = .fullHD
    @Published private(set) var addMediaButtonTitle: String = ""
    @Published private(set) var addMediaButtonVisible: Bool = false
    @Published private(set) var canUndo: Bool = false
    @Published var alertData: AlertData?
    
    @Published var isLoading: LoadingModel = .true
    @Published var contentPreview: EditorPreview.Content?
    @Published var showRemoveAllAlert: Bool = false
    @Published private var contentPreviewDidLoad: Bool = false
    
    private let builder =  MediaBuilder()
    
    private var onPublish: (@MainActor (CombinerOutput) -> Void)?
    private var onClose: (@MainActor () -> Void)?
    
    private var storage = Cancellables()
    
    init(onPublish: (@MainActor (CombinerOutput) -> Void)?,
         onClose: (@MainActor () -> Void)?) {
        
        self.onClose = onClose
        self.onPublish = onPublish
        
        observe(nested: self.ui).store(in: &storage)
        observe(nested: self.tools).store(in: &storage)
        observeOnMain(nested: self.data).store(in: &storage)
        
        addMediaButtonTitle = strings.hint
        
        mementoService
            .$canUndo
            .receiveOnMain()
            .weakAssign(to: \.canUndo, on: self)
            .store(in: &storage)
        
        resolutionService.resolution
            .removeDuplicates()
            .receiveOnMain()
            .weakAssign(to: \.resultResolution, on: self)
            .store(in: &storage)
        
        removeLayersService.$isNeedRemoveAllLayers
            .removeDuplicates()
            .sink(on: .main, object: self) { wSelf, value in
                if wSelf.showRemoveAllAlert { return }
                if wSelf.data.isEmpty { return }
                makeHaptics()
                wSelf.showRemoveAllAlert = value
            }
            .store(in: &storage)
        
        merger.$state
            .sink(on: .main, object: self) { wSelf, value in
                switch value {
                case .idle:
                    wSelf.isLoading = .false
                    wSelf.contentPreview = nil
                case .inProgress:
                    wSelf.isLoading = .processing
                case .successImage(let imageItem):
                    makeHaptics(.light)
                    wSelf.data.add(imageItem)
                    wSelf.tools.showAddItemSelector(false)
                    wSelf.tools.openLayersList(false)
                    wSelf.tools.seletedTool(.concreteItem(imageItem))
                    wSelf.isLoading = .false
                case .successVideo(let videoItem):
                    makeHaptics(.light)
                    wSelf.data.add(videoItem)
                    wSelf.tools.showAddItemSelector(false)
                    wSelf.tools.openLayersList(false)
                    wSelf.tools.seletedTool(.concreteItem(videoItem))
                    wSelf.isLoading = .false
                case .error(let error):
                    makeHaptics(.light)
                    Log.e(error)
                    wSelf.isLoading = .false
                    wSelf.contentPreview = nil
                    wSelf.alertData = .init(error)
                }
            }
            .store(in: &storage)
        
        builder.$state
            .sink(on: .main, object: self) { wSelf, value in
                switch value {
                case .idle:
                    wSelf.isLoading = .false
                    wSelf.contentPreview = nil
                case .inProgress:
                    wSelf.isLoading = .processing
                case .success(let combinerOutput):
                    makeHaptics(.light)
                    wSelf.contentPreview = .init(model: combinerOutput)
                    wSelf.isLoading = .false
                case .error(let error):
                    makeHaptics(.light)
                    Log.e(error)
                    wSelf.isLoading = .false
                    wSelf.contentPreview = nil
                    wSelf.alertData = .init(error)
                }
            }
            .store(in: &storage)

        settings.isLoading.combineLatest(ui.$editorSize, $contentPreviewDidLoad)
            .map { return !$0.0 && ($0.1 != .zero) && $0.2 }
            .removeDuplicates()
            .sink(on: .main, object: self) { wSelf, value in
                if value {  
                    wSelf.addMediaButtonTitle = wSelf.settings.subTitle ?? wSelf.strings.hint
                    if wSelf.addMediaButtonTitle == "" {
                        wSelf.addMediaButtonTitle = wSelf.strings.hint
                    }
                    wSelf.getStartTemplate()
                }
            }
            .store(in: &storage)
        
        // Не разрешать работать с видео в формате 8к 4к
        data.$layers.flatMap { result -> AnyPublisher<Bool, Never> in result.elements.withVideoAsync() }
            .removeDuplicates()
            .sink(on: .main, object: self) { wSelf, value in
                switch wSelf.resultResolution {
                case .ultraHD4k, .ultraHD8k: wSelf.set(resolution: .fullHD)
                default: break
                }
            }
            .store(in: &storage)
        
        // Показывать или не показывать кнопку
        data.$layers
            .combineLatest(tools.$currentToolItem)
            .map { $0.0.isEmpty && $0.1 != .drawing }
            .removeDuplicates()
            .sink(on: .main, object: self) { wSelf, value in
                wSelf.addMediaButtonVisible = value
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
    
    func contentViewDidLoad() { self.contentPreviewDidLoad = true }
}

// FIXME: - Перенести в другое место
extension CanvasEditorViewModel {
    func removeBackground(on item: CanvasItemModel,
                          completion: @escaping (CanvasItemModel) -> Void) {
        isLoading = .processing
        forceSave()
        imageProcessingController.removeBackground(on: item) { [weak self] new in
            self?.data.delete(item, withSave: false)
            self?.data.add(new, withSave: false)
            self?.isLoading = .false
            completion(new)
        }
    }
}

// MARK: - Get started template
extension CanvasEditorViewModel {
    func getStartTemplate() {
        isLoading = .true
        data.getStartTemplate(size: ui.roundedEditorSize) { [weak self] in
            self?.isLoading = .false
        }
    }
}

// MARK: - Remove all after screen down
extension CanvasEditorViewModel {
    func removeAllLayers() {
        defer { removeLayersService.notNeedToRemoveAllLayers() }
        tools.showAddItemSelector(false)
        tools.seletedTool(.empty)
        data.removeAll()
        tools.openLayersList(true)
    }
    
    func cancelRemoveAllLayers() {
        removeLayersService.notNeedToRemoveAllLayers()
    }
}

// MARK: - Resolution
extension CanvasEditorViewModel {
    func set(resolution: MediaResolution) {
        resolutionService.set(resolution: resolution)
    }
}

// MARK: - Global actions to output
extension CanvasEditorViewModel {
    @MainActor
    func onCloseEditor() { onClose?() }
    
    @MainActor
    func onPublishResult(output: CombinerOutput) {
        if onPublish != nil {
            isLoading = .processing
            onPublish?(output)
        }
    }
}

// MARK: - History proxy do data
extension CanvasEditorViewModel: MementoObject {
    func undo() {
        data.undo()
    }
    
    func forceSave() {
        data.forceSave()
    }
}
