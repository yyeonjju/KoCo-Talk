//
//  ChattingRoomIntent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/30/25.
//

import Foundation
import Combine
import UIKit

protocol ChattingRoomIntentProtocol {
    func stopDMReceive()
    func submitMessage(roomId : String, text : String, files : [String] )
    func uploadFiles(roomId : String, fileDatas : [Data])
    func getPrevChats(roomId : String)
}

final class ChattingRoomIntent : ChattingRoomIntentProtocol{
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) var userInfo : LoginResponse?
    
    private var cancellables = Set<AnyCancellable>()
    private weak var model : ChattingRoomModelActionProtocol?
    
    private var chatRealmManager = ChatRealmManager()
    
    init(model: ChattingRoomModelActionProtocol) {
        self.model = model
    }
    
    func getPrevChats(roomId : String) {
        var temp : [ChatRoomContentDTO] = []
        
        //✅ Realm에서 이미 본 메시지 데이터 로드
        chatRealmManager.getChatsFor(roomId: roomId)
            .flatMap{ result in
                print("💕💕💕💕💕💕💕result💕💕💕💕💕💕💕", result)
                
                temp.append(contentsOf: result.map{$0.toRemoteDTO()})
                
                print("💕💕💕💕💕💕💕temp💕💕💕💕💕💕💕", temp)
                
                let lastChatCreatedAt = result.last?.createdAt ?? ""
                
                print("💕💕💕💕💕💕💕lastChatCreatedAt💕💕💕💕💕💕💕", lastChatCreatedAt)
                
                //✅ 서버에서 확인하지 않은 최근 메시지 데이터 로드
                return NetworkManager.getChatRoomContents(roomId: roomId, cursorDate: lastChatCreatedAt)
            }
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

                print("🍀🍀🍀🍀🍀🍀🍀result🍀🍀🍀🍀🍀🍀🍀", result)
                
                //realm에 저장되지 않은 데이터는 realm에 저장
                chatRealmManager.add(chats: result.data.map{$0.toRealmType()})
                
                //UI 업데이트를 위해 model업데이트
                temp.append(contentsOf: result.data)
                
                print("🍀🍀🍀🍀🍀🍀🍀temp🍀🍀🍀🍀🍀🍀🍀", temp)
                
                let rows = ConvertChatContentsToChatRows(data: temp, myUserId: userInfo?.id ?? "")
                model.updateChatRoomRows(rows)
                
                //소켓 연결
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
                
                //내가 보낸 메시지, 상대가 보낸 메시지 모두 받은 후 realm 에 저장
                let realmChat = result.toRealmType()
                chatRealmManager.add(chat: realmChat)
                
                //UI 업데이트
                model.appendChat(result, myUserId: userInfo?.id ?? "")
                
//                ChatContentsStorage.shared.chats.append(result)
//                output.chatContents = ChatContentsStorage.shared.chats
                
            })
            .store(in: &cancellables)

    }
    
    func stopDMReceive() {
        SocketIOManager.shared.closeConnection()
    }
    
    func submitMessage(roomId : String, text : String, files : [String]) {
        let body = PostChatBody(content: text, files: files)
       
        NetworkManager.postChat(roomId: roomId, body: body)
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
                print("💕💕💕 메세지 보내기 완료!!", result)
                
            })
            .store(in: &cancellables)
    }
    
    func uploadFiles(roomId : String, fileDatas : [Data]) {
        NetworkManager.uploadFiles(fileDatas: fileDatas)
            .sink(receiveCompletion: {[weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️receiveCompletion - failure", error)
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self]  result in
                guard let self else { return }
                print("⭐️⭐️⭐️⭐️⭐️result", result)
                submitMessage(roomId: roomId, text: "", files: result.files)
            })
            .store(in: &cancellables)
    }
}
