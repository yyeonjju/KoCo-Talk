//
//  ChatContentsResponseDTO.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation

///채팅 내역
struct ChatRoomContentListResponseDTO : Decodable {
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


extension ChatRoomContentListResponseDTO{
    func toDomain() -> [ChatRoomContentRow] {
        
        var result : [ChatRoomContentRow] = []
        var chatContents : [ChatRoomContent] = []
        
        for (offset, element) in data.enumerated() {
            
            ///✅ 유저 비교하여 Row 분리를 위해
            let currentIndexSenderId = data[offset].sender.userId
            var nextIndexSenderId = ""
            if offset+1 < data.count {
                nextIndexSenderId = data[offset+1].sender.userId
            }
            
            
            ///✅ 다음 index와 날짜/시간 비교하여 Row 분리를 위해
            //서버에서 받는 날짜 형태의 DateFormatter
            // String -> Date
            let serverDateFormatter = DateFormatter.getServerDateFormatter()
            let currentIndexDate : Date = serverDateFormatter.date(from: data[offset].createdAt) ?? Date()
            var nextIndexDate : Date = Date()
            if offset+1 < data.count {
                nextIndexDate = serverDateFormatter.date(from: data[offset+1].createdAt) ?? Date()
            }
            //Date -> String
            let dateFormatterForComparison = DateFormatter.getKRLocaleDateFormatter(format: .yyyyMMddhhmm)
            let currentIndexDateTimeString = dateFormatterForComparison.string(from: currentIndexDate)
            let nextIndexDateTimeString = dateFormatterForComparison.string(from: nextIndexDate)
            
            
            //채팅 내역(ChatRoomContent)을 추가
            chatContents.append(
                ChatRoomContent(
                    chatId: element.chatId,
                    content: element.content,
                    files: element.files
                )
            )
            
            //다음 인덱스 요소와 날짜/시간이 다르거나, 유저가 다르면 현재까지의 chatContents를 갖는 Row 생성하여 append
            if currentIndexSenderId != nextIndexSenderId ||
                currentIndexDateTimeString != nextIndexDateTimeString
            {
                ///✅이전 row의 날짜와 비교해서 날짜 표시 여부를 판단
                let chatDateFormatter = DateFormatter.getKRLocaleDateFormatter(format: .chatRoomDateFormat)
                let currentIndexPresentationDate = chatDateFormatter.string(from: currentIndexDate)
                //이전 row의 날짜
                let prevRowDate = result.last?.createdDate

                
                //시간 표시를 위함
                let chatTimeFormatter = DateFormatter.getKRLocaleDateFormatter(format: .chatTimeFormat)
                let presentationtTime = chatTimeFormatter.string(from: currentIndexDate)

                //현재까지 쌓인 chatContents를 담은 ChatRoomContentRow를 append
                result.append(
                    ChatRoomContentRow(
                        isMyChat: currentIndexSenderId == APIKEY.myUserId,
                        isDateShown : prevRowDate == nil || currentIndexPresentationDate != prevRowDate,
                        createdDate: currentIndexPresentationDate,
                        createdTime: presentationtTime,
                        opponentNickname: element.sender.nick,
                        
                        chats: chatContents
                    )
                )
                
                //현재까지 쌓인 chatContents 초기화
                chatContents.removeAll()
                
            }
        }

        
        return result
    }
}

