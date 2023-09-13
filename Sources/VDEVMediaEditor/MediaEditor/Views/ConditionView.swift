//
//  ConditionView.swift
//  
//
//  Created by Vladislav Gushin on 19.08.2023.
//

import SwiftUI

struct OR<V1: View, V2: View>: View {
    private let _view1: V1
    private let _view2: V2
    private let condition: Bool
    
    init(_ condition: Bool,
         @ViewBuilder firstView: () -> V1,
         @ViewBuilder secondView: () -> V2
    ) {
        self.condition = condition
        self._view1 = firstView()
        self._view2 = secondView()
    }
    
    var body: some View {
        if condition {
            _view1
        } else {
            _view2
        }
    }
}

struct IF<V1: View>: View {
    private let _view1: V1
    private let condition: Bool
    
    init(_ condition: Bool,
         @ViewBuilder firstView: () -> V1
    ) {
        self.condition = condition
        self._view1 = firstView()
    }
    
    var body: some View {
        if condition {
            _view1
        }
    }
}

struct OBJECT<T, V1: View, V2: View>: View {
    private let _view1: (T) -> V1
    private let _view2: () -> V2
    private let checkObject: T?
    
    init(_ checkObject: T?,
         @ViewBuilder firstView: @escaping (T) -> V1,
         @ViewBuilder secondView: @escaping () -> V2
    ) {
        self.checkObject = checkObject
        self._view1 = firstView
        self._view2 = secondView
    }
    
    var body: some View {
        if let checkObject = checkObject {
            _view1(checkObject)
        } else {
            _view2()
        }
    }
}
