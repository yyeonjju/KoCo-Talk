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
    
    func toDomain() -> ChatRoom {
        let opponent = participants.filter{
            $0.userId != UserDefaultsManager.userInfo?.id
        }.first
        var presentationDate = "-"
        
        //서버의 날짜 형식을 변환
        let serverDateFormatter = DateFormatter.getServerDateFormatter()
        let date = serverDateFormatter.date(from: updatedAt)
        
        if let date {
            if Calendar.current.isDateInToday(date) {
                //오늘 날짜라면 시간으로 포맷팅
                let presentationTimeFormatter = DateFormatter.getKRLocaleDateFormatter(format: .chatTimeFormat)
                presentationDate = presentationTimeFormatter.string(from: date)
            } else {
                //오늘 날짜 아니라면 날짜로 포맷팅
                let presentationDateFormatter = DateFormatter.getKRLocaleDateFormatter(format: .chatListDateFormat)
                presentationDate = presentationDateFormatter.string(from: date)
            }
        }
        
        return ChatRoom(
            roomId: roomId,
            updatedAt : presentationDate,
            opponentId: opponent?.userId ?? "-",
            opponentNickname : opponent?.nick ?? "-",
            opponentProfileImage : opponent?.profileImage,
            lastChatText : lastChat?.content ?? "지난 대화가 없습니다"
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
    let content : String?
    let sender : ChatRoomParticipantDTO
    let files : [String]

    enum CodingKeys: String,CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content, sender, files
    }
}
