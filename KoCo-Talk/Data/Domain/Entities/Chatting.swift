//
//  Chatting.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/30/25.
//

import Foundation

// MARK: - 채팅 룸 정보 ( 채팅 리스트 )

struct ChatRoom  {
    //채팅룸 정보
    let roomId : String
    let updatedAt : String
    
    //상대방 정보
    let opponentId : String
    let opponentNickname : String
    let opponentProfileImage : String?
    
    //지난 대화
    let lastChatText : String
}


// MARK: - 채팅 내역 정보 ( 채팅 룸 내부 )

//시간 & 상대방 여부에 따라 채팅 내역을 묶어 하나의 Row로 관리하기위해
struct ChatRoomContentRow {
    let isMyChat : Bool // 채팅 UI의 말풍선 방향 결정을 위함
    let isDateShown : Bool // 날짜 달라졌을 때 날짜 표시 여부
    let createdDate : String // 날짜 변경되었을 때 날짜 표시를 위함
    let createdTime : String // Row마다 하단에 이 컨텐츠들의 시간 표시를 위함
    let opponentNickname : String
    
    let data : [ChatRoomContent]
}

struct ChatRoomContent {
    let chatId : String
    let content : String
    let files : [String]
}
