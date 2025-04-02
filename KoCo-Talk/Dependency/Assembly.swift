//
//  Assembly.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/21/25.
//

import Foundation
import Swinject

final class DataSourceAssembly : Assembly {
    func assemble(container: Swinject.Container) {
        
        container.register(NetworkManagerType.self) { _ in
//            return NetworkManager2.shared
            return MockDataLoadManager.shared
        }.inObjectScope(.container)
        
        container.register(ChatRealmManagerType.self) { _ in
            return ChatRealmManager()
        }.inObjectScope(.container)
        
        container.register(SocketIOManager.self) { _ in
            return SocketIOManager.shared
        }.inObjectScope(.container)
        
    }
}

final class MapAssembly : Assembly{
    func assemble(container: Swinject.Container) {
        
        container.register(MapRepository.self) { _ in
            return DefaultMapRepository()
        }.inObjectScope(.container)
        
    }
}

final class ChatAssembly : Assembly{
    func assemble(container: Swinject.Container) {
        
        container.register(ChatListRepository.self) { _ in
            return DefaultChatListRepository()
        }.inObjectScope(.container)
        
        container.register(ChatRoomRepository.self) { _ in
            return DefaultChatRoomRepository()
            //ChatRoomRepository 프로토콜이 @MainActor를 채택하기 때문에 생기는 아래 에러
            //Call to main actor-isolated initializer 'init()' in a synchronous nonisolated context
            // DefaultChatRoomRepository 구현체에 `nonisolated init(){}`을 함으로써 해결
        }.inObjectScope(.container)
        
    }
}

final class AuthAssembly : Assembly{
    func assemble(container: Swinject.Container) {
        
        container.register(AuthRepository.self) { _ in
            return DefaultAuthRepository()
        }.inObjectScope(.container)
        
    }
}

final class StoreAssembly : Assembly{
    func assemble(container: Swinject.Container) {

        container.register(StoreInfoRegisterRepository.self) { _ in
            return DefaultStoreInfoRegisterRepository()
        }.inObjectScope(.container)
        
    }
}
