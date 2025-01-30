//
//  ChattingListView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/28/25.
//

import SwiftUI

struct ChattingListView: View {
    @StateObject var container : Container<ChattingListIntentProtocol, ChattingListModelStateProtocol>
    
    private var state : ChattingListModelStateProtocol {container.model}
    private var intent : ChattingListIntentProtocol {container.intent}
    
    var body: some View {
        ScrollView{
            LazyVStack {
                ForEach(state.chatRoomList, id : \.roomId) { item in
                    NavigationLink{
                        ChattingRoomView.build(roomId : item.roomId)
                            .navigationTitle(item.opponentNickname)
                            .navigationBarTitleDisplayMode(.inline)
                    } label  : {
                        ChattingListRowView(chatRoom : item)
                    }
                    .padding(.bottom, 4)
                }
            }
            .padding()

        }
        .onAppear{
            intent.fetchChatRoomList()
        }

    }
}

extension ChattingListView {
    static func build() -> ChattingListView {
        let model = ChattingListModel()
        let intent = ChattingListIntent(model: model) // model의 action 프로토콜 부분 전달
        let container = Container(
            intent: intent as ChattingListIntentProtocol,
            model: model as ChattingListModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        return ChattingListView(container: container)
    }
}
