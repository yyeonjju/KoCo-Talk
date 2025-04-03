//
//  DefaultChatRoomRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

final class DefaultChatRoomRepository : ChatRoomRepository {
    @Injected private var networkManager : NetworkManagerType
    @Injected private var chatRealmManager : ChatRealmManagerType
//    private let socketIOManager = SocketIOManager.shared
    
    nonisolated init(){}
    
    func getPrevRealmChats(roomId : String) -> [ChatRoomContentDTO] {
        let realmChats = chatRealmManager.getChatsFor(roomId: roomId)
        print("💕💕💕💕💕💕💕앞서 저장된 realm chats💕💕💕💕💕💕💕", realmChats)
        
        let prevChats = realmChats.map{$0.toRemoteDTO()}
        print("💕💕💕💕💕💕💕prevChats💕💕💕💕💕💕💕", prevChats)
        return prevChats
    }
 
    func getUnreadChats(roomId : String, cursorDate : String) async throws -> [ChatRoomContentDTO] {
        let result = try await networkManager.getChatRoomContents(roomId: roomId, cursorDate: cursorDate)
        print("🍀🍀🍀🍀🍀🍀🍀isMainThread🍀🍀🍀🍀🍀🍀🍀", Thread.isMainThread)
        print("🍀🍀🍀🍀🍀🍀🍀서버 chat result🍀🍀🍀🍀🍀🍀🍀", result)
        //realm에 저장되지 않은 데이터는 realm에 저장 ( 메인 스레드에서 실행되어야함 -> 프로토콜에서의 @MainActor 때문에 가능 )
        chatRealmManager.add(chats: result.data.map{$0.toRealmType()})
        
        return result.data
    }
    
    func submitMessage(roomId : String, text : String, files : [String]) async throws -> String {
        let body = PostChatBody(content: text, files: files)
        
        let result = try await networkManager.postChat(roomId: roomId, body: body)
        return result.chatId
    }
    
    func submitFiles(roomId : String, fileDatas : [Data]) async throws -> String {
        //✅ 서버에 파일 업로드 이후
        let uploadResult = try await networkManager.uploadFiles(fileDatas: fileDatas)
        print("💕💕💕 파일 업로드 완료!!", uploadResult.files)
        
        //✅ 메시지 전송
        let chatId = try await submitMessage(roomId: roomId, text: "", files: uploadResult.files)
        
        return chatId
    }
    
}
