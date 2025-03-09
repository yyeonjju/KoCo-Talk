//
//  ChattingListIntent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation
import Combine

protocol ChattingListIntentProtocol {
    func fetchChatRoomList()
    func createChatRoom(opponentID : String)
}

final class ChattingListIntent : ChattingListIntentProtocol {
    private weak var model : ChattingListModelActionProtocol?
    private var cancellables = Set<AnyCancellable>()
    
    init(model: ChattingListModelActionProtocol) {
        self.model = model
    }
    
    func fetchChatRoomList() {
        NetworkManager.getChatRoomList()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️receiveCompletion - failure", error)
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self] result in
                guard let self, let model else { return }
                print("❤️", result.data)
                let chatRoomList = result.data.map{$0.toDomain()}
                model.updateChatRoomList(list: chatRoomList)
                
            })
            .store(in: &cancellables)
    }
    
    func createChatRoom(opponentID : String) {
        NetworkManager.createChatRoom(body : CreateChatRoomBody(opponent_id: opponentID))
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let error):
                    print("⭐️receiveCompletion - failure", error)
                case .finished:
                    break
                }
                
            }, receiveValue: {[weak self] result in
                guard let self else { return }
                
                self.fetchChatRoomList()
                
            })
            .store(in: &cancellables)
    }
    
}
