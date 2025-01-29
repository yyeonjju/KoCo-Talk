//
//  ChatRoomResponseDTO+Mapping.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation

///채팅방 리스트
struct ChatRoomListResponseDTO : Decodable {
    let data : [ChatRoomResponseDTO]
}

///채팅방
struct ChatRoomResponseDTO : Decodable {
    let roomId : String
    let createdAt : String
    let updatedAt : String
    let participants : [ChatRoomParticipantDTO]
    let lastChat : LastChatDTO?
    
    enum CodingKeys: String,CodingKey {
        case roomId = "room_id"
        case createdAt, updatedAt, participants, lastChat
    }
    
    func toDomain() -> ChatRoomEntity {
        let opponent = participants.filter{
            $0.userId != APIKEY.myUserId
        }.first
        let opponentId = opponent?.userId
        let opponentNickname = opponent?.nick
        
        return ChatRoomEntity(
            roomId: roomId,
            opponentId: opponentId ?? "-",
            opponentNickname : opponentNickname ?? "-"
        )
    }
    
}


struct ChatRoomParticipantDTO : Decodable {
    let userId : String
    let nick : String
    let profileImage : String?
    
    enum CodingKeys: String,CodingKey {
        case userId = "user_id"
        case nick, profileImage
    }
}

struct LastChatDTO : Decodable {
    let chatId : String
    let roomId : String
    let content : String
    let sender : ChatRoomParticipantDTO
    let files : [String]

    enum CodingKeys: String,CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content, sender, files
    }
}
