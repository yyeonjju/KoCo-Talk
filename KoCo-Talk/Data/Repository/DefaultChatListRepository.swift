//
//  DefaultChatListRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

final class DefaultChatListRepository : ChatListRepository {
    private let networkManager = NetworkManager2.shared
    
    func getChatRoomList() async throws -> [ChatRoom] {
        let result = try await  networkManager.getChatRoomList()
        return result.data.map{$0.toDomain()}
    }
}
