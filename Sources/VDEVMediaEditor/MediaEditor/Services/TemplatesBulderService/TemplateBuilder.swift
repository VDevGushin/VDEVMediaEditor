//
//  TemplateBuilder.swift
//  
//
//  Created by Vladislav Gushin on 12.06.2023.
//

import Foundation


protocol TemplateBuilder {
    @MainActor
    func buildTemplate(canvasSize: CGSize) -> TemplatePack
}
