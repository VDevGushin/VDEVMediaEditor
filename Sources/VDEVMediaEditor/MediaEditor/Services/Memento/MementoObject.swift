//
//  MementoObject.swift
//  
//
//  Created by Vladislav Gushin on 27.06.2023.
//

import Foundation

protocol MementoObject: AnyObject {
    func forceSave()
    func undo()
}
