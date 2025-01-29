//
//  ChatContentsResponseDTO.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation

///채팅 내역
struct ChatRoomContentsResponseDTO : Decodable {
    let data : [ChatRoomContentDTO]
}


struct ChatRoomContentDTO : Decodable {
    let roomId : String
    let chatId : String
    let content : String
    let createdAt : String
    let sender : ChatRoomParticipantDTO
    let files : [String]
    
    enum CodingKeys: String,CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content, createdAt, sender, files
    }
}
