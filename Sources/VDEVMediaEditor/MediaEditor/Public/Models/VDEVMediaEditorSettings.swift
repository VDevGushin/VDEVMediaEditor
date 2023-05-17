//
//  VDEVMediaEditorSettings.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 13.04.2023.
//

import Foundation
import Combine

public protocol VDEVMediaEditorResultSettings: AnyObject {
    var needAutoEnhance: CurrentValueSubject<Bool, Never> { get set }
    var maximumVideoDuration: Double { get }
    var resolution: VDEVMediaResolution { get }
}

public protocol VDEVMediaEditorSettings {
    // Нужна ли сетка в редакторе
    var needGuideLinesGrid: Bool { get }
    // Используется ли модуль, как встроенный
    var isInternalModule: Bool { get }
    // Стартовое aspectRatio
    var aspectRatio: CGFloat? { get }
    
    // Показывать возможность менять разрешение сторон
    var showAspectRatioSettings: Bool { get }
    // Показывать возможность показывать настройки
    // - Включение/выключение автокачества финала
    // - Выбор финального разрешения
    var showCommonSettings: Bool { get }
    // Показать возможность включения звука в видосах
    var canTurnOnSoundInVideos: Bool { get }
    var canAddMusic: Bool { get }
    
    var resourceID: String { get }
    var title: String { get }
    var subTitle: String? { get }
    var withAttach: Bool { get }
    var sourceService: VDEVMediaEditorSourceService { get }
    
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    func getStartTemplate(for size: CGSize,
                          completion: @escaping ([TemplatePack.Variant.Item]?) -> Void)
}
