//
//  ChattingRoomModel.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/30/25.
//

import Foundation


protocol ChattingRoomModelStateProtocol {
    var chatRoomContents : [ChatRoomContentRow] {get}
}
protocol ChattingRoomModelActionProtocol : AnyObject {
    func updateChatRoomContents(_ contents : [ChatRoomContentRow])
}

final class ChattingRoomModel : ChattingRoomModelStateProtocol, ObservableObject {
    @Published var chatRoomContents : [ChatRoomContentRow] = []
}

extension ChattingRoomModel : ChattingRoomModelActionProtocol {
    func updateChatRoomContents(_ contents : [ChatRoomContentRow]) {
        chatRoomContents = contents
    }
}
