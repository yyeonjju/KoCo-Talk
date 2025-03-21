//
//  Injected.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/21/25.
//

import Foundation

@propertyWrapper
struct Injected<T> {
    var wrappedValue: T {
        DIContainer.shared.resolve()
    }
}
