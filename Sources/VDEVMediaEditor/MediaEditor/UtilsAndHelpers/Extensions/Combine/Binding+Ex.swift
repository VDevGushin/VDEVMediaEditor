//
//  Binding+Ex.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 09.02.2023.
//

import Foundation
import SwiftUI
import Combine

extension Binding {
    func asBool<Tag: Equatable>(with tag: Tag) -> Binding<Bool> where Value == Tag? {
        Binding<Bool> {
            self.wrappedValue == tag
        } set: {
            guard !$0 else { return }
            self.wrappedValue = nil
        }
    }

    func asBool<Input>() -> Binding<Bool> where Value == Input? {
        Binding<Bool> {
            self.wrappedValue != nil
        } set: {
            guard !$0 else { return }
            self.wrappedValue = nil
        }
    }
}
