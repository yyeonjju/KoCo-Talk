//
//  ChattingRoomIntent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/30/25.
//

import Foundation
import Combine

protocol ChattingRoomIntentProtocol {
    func fetchChatRoomContents(roomId : String,cursorDate : String)
}

final class ChattingRoomIntent : ChattingRoomIntentProtocol{
    private var cancellables = Set<AnyCancellable>()
    private weak var model : ChattingRoomModelActionProtocol?
    
    init(model: ChattingRoomModelActionProtocol) {
        self.model = model
    }
    
    func fetchChatRoomContents(roomId : String, cursorDate : String) {
        
        NetworkManager.getChatRoomContents(roomId: roomId, cursorDate: "2025-01-26T07:14:54.357Z")
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️receiveCompletion - failure", error)
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self]  result in
                guard let self, let model else { return }

                //TODO: 로컬에 저장
                
                model.updateChatRoomRows(result.toDomain())
                
                beginDMReceive(roomId: roomId)
                
                
            })
            .store(in: &cancellables)
    }
    
    func beginDMReceive(roomId : String) {
        SocketIOManager.shared.establishConnection(router: .dm(roomId: roomId))
        
        SocketIOManager.shared.receive(chatType: .chat, model: ChatRoomContentDTO.self)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️receiveCompletion - failure", error)
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self]  result in
                guard let self, let model else { return }
                
                print("❤️❤️메세지 받았다???❤️❤️", result)
                
                // 모델에 업데이트 : 원본 저장해놔야하나?
                //
                //
                //
                model.appendChat(result)
                
//                ChatContentsStorage.shared.chats.append(result)
//                output.chatContents = ChatContentsStorage.shared.chats
                
            })
            .store(in: &cancellables)

    }
}
