//
//  ChattingRoomModel.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/30/25.
//

import Foundation


protocol ChattingRoomModelStateProtocol {
    var chatRoomRows : [ChatRoomContentRow] {get}
}
protocol ChattingRoomModelActionProtocol : AnyObject {
    func updateChatRoomRows(_ contents : [ChatRoomContentRow])
    func appendChat(_ content : ChatRoomContentDTO )
}

final class ChattingRoomModel : ChattingRoomModelStateProtocol, ObservableObject {
    @Published var chatRoomRows : [ChatRoomContentRow] = []
}

extension ChattingRoomModel : ChattingRoomModelActionProtocol {
    
    func updateChatRoomRows(_ contents : [ChatRoomContentRow]) {
        chatRoomRows = contents
    }
    
    func appendChat(_ content : ChatRoomContentDTO ) {
        //내가 보낸 챗인지 여부
        let isMyChat = (content.sender.userId == APIKEY.myUserId)
        //보낸 날짜
        let dateString =  content.createdAt.serverDateConvertTo(.chatRoomDateFormat)
        //보낸 시간
        let timeString = content.createdAt.serverDateConvertTo(.chatTimeFormat)
        
        var newChatRoomRows : [ChatRoomContentRow] = chatRoomRows
        
        //챗 내역이 없는 챗방일 경우
        guard let lastRow = chatRoomRows.last else {

            let newRow = ChatRoomContentRow(
                isMyChat: isMyChat,
                isDateShown: true,
                createdDate: dateString,
                createdTime: timeString,
                senderNickname: content.sender.nick,
                chats: [ChatRoomContent(chatId: content.chatId, content: content.content ?? "-", files: content.files)]
            )
            
            newChatRoomRows.append(newRow)
            chatRoomRows = newChatRoomRows
            
            return
        }
        
        //마지막 row의 content로 넣어주어야할 때
        // -> lastRow의 isMyChat, createdDate, createdTime이 동일할 때
        if lastRow.isMyChat == isMyChat &&
        lastRow.createdDate == dateString &&
        lastRow.createdTime == timeString {
            var chats = lastRow.chats
            chats.append(ChatRoomContent(chatId: content.chatId, content: content.content ?? "-", files: content.files))
            
            let newRow = ChatRoomContentRow(
                isMyChat: lastRow.isMyChat,
                isDateShown: lastRow.isDateShown,
                createdDate: lastRow.createdDate,
                createdTime: lastRow.createdTime,
                senderNickname: lastRow.senderNickname,
                chats: chats
            )
            
            newChatRoomRows.removeLast(1) // 기존의 마지막 요소 없애주고
            newChatRoomRows.append(newRow) // 새로 만든 요소 넣어준다
            
            chatRoomRows = newChatRoomRows
            
            return
        }
        
        
        //새로운 row 생성해주어야할 때
        // -> lastRow의 isMyChat, createdDate, createdTime 중 한가지라도 일치하지 않을 경우
        let isDateShown = dateString != lastRow.createdDate
        let newRow = ChatRoomContentRow(
            isMyChat: isMyChat,
            isDateShown: isDateShown,
            createdDate: dateString,
            createdTime: timeString,
            senderNickname: content.sender.nick,
            chats: [ChatRoomContent(chatId: content.chatId, content: content.content ?? "-", files: content.files)]
        )
        
        newChatRoomRows.append(newRow)
        chatRoomRows = newChatRoomRows
        
        return

        
    }
}
