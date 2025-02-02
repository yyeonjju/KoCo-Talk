//
//  CreateChatRoom.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation

// MARK: - 채팅방 만들 때
struct CreateChatRoomBody : Encodable {
    let opponent_id : String
}

// MARK: - 채팅 보낼 때
struct PostChatBody : Encodable {
    let content : String
    let files : [String]
}
