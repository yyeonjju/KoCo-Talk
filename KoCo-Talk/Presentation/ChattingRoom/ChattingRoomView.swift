//
//  ChattingRoomView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/28/25.
//

import SwiftUI

struct ChattingRoomView: View {
    let roomId : String
    @State private var showTabBar : Bool = false
    @StateObject var container : Container<ChattingRoomIntentProtocol, ChattingRoomModelStateProtocol>
    private var state : ChattingRoomModelStateProtocol {container.model}
    private var intent : ChattingRoomIntentProtocol {container.intent}
    
    
    var body: some View {
        ScrollView {
            LazyVStack{
                ForEach(state.chatRoomRows, id : \.chats) { row in
                    ChattingRoomRowView(row: row)
                }
            }
        }
        
        .onAppear{
            intent.fetchChatRoomContents(roomId: roomId, cursorDate: "")
        }
        //채팅방 들어왔을 때는 탭바 보이지 않고, .onDisappear 시점에는 (이전 페이지로 돌아갈 떄) 다시 탭바 뜰 수 있도록
        .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
        .onDisappear{
            showTabBar = true
        }
        
        
    }
}


extension ChattingRoomView {
    static func build(roomId : String) -> ChattingRoomView{
        let model = ChattingRoomModel()
        let intent = ChattingRoomIntent(model: model) // model의 action 프로토콜 부분 전달
        let container = Container(
            intent: intent as ChattingRoomIntentProtocol,
            model: model as ChattingRoomModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return ChattingRoomView(roomId: roomId, container: container)
    }
}
