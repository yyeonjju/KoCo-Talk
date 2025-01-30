//
//  Chatting.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/30/25.
//

import Foundation

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
