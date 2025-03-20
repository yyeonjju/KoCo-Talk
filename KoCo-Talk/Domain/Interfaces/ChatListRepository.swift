//
//  ChatListRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

protocol ChatListRepository {
    func getChatRoomList() async throws -> [ChatRoom]
}
