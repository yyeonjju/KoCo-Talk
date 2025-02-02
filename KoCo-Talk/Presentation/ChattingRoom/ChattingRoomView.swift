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
    
    @FocusState private var textFieldFocused: Bool
    @State private var inputText = ""
    
    var body: some View {
        VStack{
            
            chatsScrollView
            .onTapGesture {
                textFieldFocused = false
            }
            
            textInputView

        }
        .onAppear{
            intent.fetchChatRoomContents(roomId: roomId, cursorDate: "")
        }
        //채팅방 들어왔을 때는 탭바 보이지 않고, .onDisappear 시점에는 (이전 페이지로 돌아갈 떄) 다시 탭바 뜰 수 있도록
        .toolbar(showTabBar ? .visible : .hidden, for: .tabBar)
        .onDisappear{
            showTabBar = true
            
            intent.stopDMReceive()
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


extension ChattingRoomView {
    var chatsScrollView : some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack{
                    ForEach(state.chatRoomRows, id : \.chats) { row in
                        ChattingRoomRowView(row: row)
                            .id(row.chats.last?.chatId)
                    }
                }
            }
            .onChange(of: state.chatRoomRows) { _ in
                print("🌸 scroll to bottom 🌸")
                if let lastRow = state.chatRoomRows.last, let lastChatId = lastRow.chats.last?.chatId{
                    proxy.scrollTo(lastChatId, anchor: .bottom)
                }
            }
        }
    }
    var textInputView : some View {
        HStack(alignment : .bottom) {
            Assets.SystemImages.plus
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Assets.Colors.gray1)
                .padding(8)
                .background(Assets.Colors.gray5)
                .clipShape(Circle())
            
            TextField(
                "메시지 입력",
                text: $inputText,
                axis: .vertical
            )
            .font(.system(size: 14, weight: .regular))
            .padding(10)
            .frame(maxWidth : .infinity)
            .background(Assets.Colors.gray5)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .focused($textFieldFocused)
            .lineLimit(6)
            
            Button {
                intent.submitMessage(roomId: roomId, text: inputText)
                inputText = ""
            } label: {
                Assets.SystemImages.arrowUp
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Assets.Colors.gray1)
                    .padding(8)
                    .background(Assets.Colors.pointGreen2)
                    .clipShape(Circle())
            }

        }
        .padding(6)
        .background(Assets.Colors.pointGreen3)
    }
}
