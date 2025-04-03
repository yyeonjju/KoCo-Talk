//
//  MockChatRoomRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 4/2/25.
//

import Foundation

final class MockChatRoomRepository : ChatRoomRepository {
    nonisolated init(){}
    
    func getPrevRealmChats(roomId : String) -> [ChatRoomContentDTO] {
        return prevChats
    }
 
    func getUnreadChats(roomId : String, cursorDate : String) async throws -> [ChatRoomContentDTO] {
        return unreadChats
    }
    
    func submitMessage(roomId : String, text : String, files : [String]) async throws -> String {
        return "new chat id"
    }
    
    func submitFiles(roomId : String, fileDatas : [Data]) async throws -> String {
        return "new chat id"
    }
    
}


fileprivate let prevChats = [
    ChatRoomContentDTO(
        roomId: "roomId-1",
        chatId: "chatId-1",
        content: "첫번째 챗입니다",
        createdAt: "2025-03-20T12:51:21.463Z",
        sender: ChatRoomParticipantDTO(userId: "userId-1", nick: "userId-1", profileImage: nil),
        files: []
    ),
    ChatRoomContentDTO(
        roomId: "roomId-1",
        chatId: "chatId-2",
        content: "두번째 챗입니다",
        createdAt: "2025-03-21T06:22:29.097Z",
        sender: ChatRoomParticipantDTO(userId: "userId-1", nick: "userId-1", profileImage: nil),
        files: []
    ),
    ChatRoomContentDTO(
        roomId: "roomId-1",
        chatId: "chatId-3",
        content: "세번째 챗입니다",
        createdAt: "2025-03-21T06:27:28.494Z",
        sender: ChatRoomParticipantDTO(userId: "userId-1", nick: "userId-1", profileImage: nil),
        files: []
    )
]

fileprivate let unreadChats = [
    ChatRoomContentDTO(
        roomId: "roomId-1",
        chatId: "chatId-4",
        content: "네번째 챗입니다",
        createdAt: "2025-03-23T12:51:21.463Z",
        sender: ChatRoomParticipantDTO(userId: "userId-1", nick: "userId-1", profileImage: nil),
        files: []
    ),
    ChatRoomContentDTO(
        roomId: "roomId-1",
        chatId: "chatId-5",
        content: "다섯번째 챗입니다",
        createdAt: "2025-03-24T06:22:29.097Z",
        sender: ChatRoomParticipantDTO(userId: "userId-1", nick: "userId-1", profileImage: nil),
        files: []
    )
]
