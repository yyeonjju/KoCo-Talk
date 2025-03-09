//
//  ChatRealmManager.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/9/25.
//

import Foundation
import Combine

enum RealmError : Error {
    case getObjectsError
}

final class ChatRealmManager : BaseRealmManager {
    
    func add(chat : RealmChatContent){
        self.createItem(chat)
    }
    
    func add(chats : [RealmChatContent]){
        for chat in chats{
            self.createItem(chat)
        }
    }
    
//    func getChatsFor(roomId : String) -> AnyPublisher<[RealmChatContent], RealmError> {
//        guard let chats = getAllObjects(tableModel: RealmChatContent.self) else {
//            return Fail(error: RealmError.getObjectsError).eraseToAnyPublisher()
//        }
//        
//        //해당하는 roomId의 채팅만 get
//        let chatsForRoomId = chats.where({ chat in
//            chat.roomId.equals(roomId)
//        })
//        
//        return Just(Array(chatsForRoomId))
//            .setFailureType(to: RealmError.self)
//            .eraseToAnyPublisher()
//    }
    
    func getChatsFor(roomId : String) -> AnyPublisher<[RealmChatContent], FetchError> {
        guard let chats = getAllObjects(tableModel: RealmChatContent.self) else {
            return Just([RealmChatContent]())
                .setFailureType(to: FetchError.self)
                .eraseToAnyPublisher()
        }
        
        //해당하는 roomId의 채팅만 get
        let chatsForRoomId = chats.where({ chat in
            chat.roomId.equals(roomId)
        })
        
        return Just(Array(chatsForRoomId))
            .setFailureType(to: FetchError.self)
            .eraseToAnyPublisher()
    }
    
}
