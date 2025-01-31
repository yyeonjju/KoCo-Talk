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
}

final class ChattingRoomModel : ChattingRoomModelStateProtocol, ObservableObject {
    @Published var chatRoomRows : [ChatRoomContentRow] = []
}

extension ChattingRoomModel : ChattingRoomModelActionProtocol {
    func updateChatRoomRows(_ contents : [ChatRoomContentRow]) {
        chatRoomRows = contents
    }
}
