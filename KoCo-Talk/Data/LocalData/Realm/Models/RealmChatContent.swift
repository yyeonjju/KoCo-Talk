//
//  RealmChatContent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/9/25.
//

import Foundation
import RealmSwift


final class RealmChatContent : Object {
    
    @Persisted(primaryKey: true) var chatId: String
    @Persisted var roomId : String
    @Persisted var content : String?
    @Persisted var createdAt : String
    
    @Persisted var files : List<String>
    
    @Persisted var senderUserId : String
    @Persisted var senderNickname : String
    @Persisted var senderProfileImage : String?
    
    convenience init(
        chatId: String,
        roomId: String,
        content: String?, 
        createdAt: String,
        files: [String],
        senderUserId : String,
        senderNickname : String,
        senderProfileImage : String? = nil
    ) {
        self.init()
        
        //array -> RealmSwift.List
        let fileList = RealmSwift.List<String>()
        fileList.append(objectsIn: files)
        
        self.chatId = chatId
        self.roomId = roomId
        self.content = content
        self.createdAt = createdAt
        self.files = fileList
        self.senderUserId = senderUserId
        self.senderNickname = senderNickname
        self.senderProfileImage = senderProfileImage
    }
    
}


extension RealmChatContent {
    func toRemoteDTO() -> ChatRoomContentDTO {
        return ChatRoomContentDTO(
            roomId: roomId,
            chatId: chatId,
            content: content,
            createdAt: createdAt,
            sender: ChatRoomParticipantDTO(userId: senderUserId, nick: senderNickname, profileImage: senderProfileImage),
            files: Array(files)
        )
    }
}
