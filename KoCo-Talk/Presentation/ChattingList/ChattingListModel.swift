//
//  ChattingListModel.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation

protocol ChattingListModelStateProtocol {
    var chatRoomList: [ChatRoom] {get}
}

protocol ChattingListModelActionProtocol : AnyObject {
    func updateChatRoomList(list : [ChatRoom])
}

final class ChattingListModel : ObservableObject, ChattingListModelStateProtocol{
    @Published var chatRoomList : [ChatRoom] = []
}
extension ChattingListModel : ChattingListModelActionProtocol {
    func updateChatRoomList(list : [ChatRoom]) {
        chatRoomList = list
    }
}
