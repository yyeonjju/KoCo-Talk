//
//  DIContainer.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/21/25.
//

import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    private let assembler: Assembler
    
    private init() {
        assembler = Assembler([
            DataSourceAssembly(),
            MapAssembly(),
            ChatAssembly(),
            AuthAssembly(),
            StoreAssembly()
        ])
    }
    
    func resolve<T>() -> T {
        guard let dependency = assembler.resolver.resolve(T.self) else {
            fatalError("Failed to resolve dependency: \(T.self)")
        }
        return dependency
    }
}
