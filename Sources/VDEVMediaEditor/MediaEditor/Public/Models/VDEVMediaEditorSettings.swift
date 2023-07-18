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
    // Показывать ли кнопку undo
    var canUndo: Bool { get }
    // Показывать или не показывать онбординг
    var canShowOnboarding: Bool { get }
    // Возможность удаление слоев
    var canRemoveAllLayers: Bool { get }
    // Кол-во возможных слоев на канвасе
    var maximumLayers: Int { get }
    // На сколько шагов назад нужно вернуться по истории
    var historyLimit: Int { get }
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
    // Можно ли добавлять музыку
    var canAddMusic: Bool { get }
    // Можно работать с генерацией картинок
    var canGenerateImageByPrompt: Bool { get }
    
    // Можно ли удалять или рефрешить шаблоны
    var сanRemoveOrChangeTemplate: Bool { get }
    
    var resourceID: String { get }
    var title: String { get }
    var subTitle: String? { get }
    var withAttach: Bool { get }
    var sourceService: VDEVMediaEditorSourceService { get }
    
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    func getStartTemplate(for size: CGSize,
                          completion: @escaping ([TemplatePack.Variant.Item]?) -> Void)
}
