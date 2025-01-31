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
//        let mock = ["1111"]
//        model?.updateChatRoomContents(mock)
        
        
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
                
                print("❤️", result.data)

                //TODO: 로컬에 저장
                
                model.updateChatRoomRows(result.toDomain())
                
//                print("🍀🍀🍀🍀🍀🍀")
//                dump(result.toDomain())
                
            })
            .store(in: &cancellables)
    }
}
