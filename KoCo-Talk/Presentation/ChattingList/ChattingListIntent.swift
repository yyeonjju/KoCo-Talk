//
//  ChattingListIntent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation

@MainActor
protocol ChattingListIntentProtocol {
    func fetchChatRoomList()
//    func createChatRoom(opponentID : String)
    func cancelTasks()
}

final class ChattingListIntent : ChattingListIntentProtocol {
    private weak var model : ChattingListModelActionProtocol?
    private var tasks : [Task<Void, Never>] = []
    
    init(model: ChattingListModelActionProtocol) {
        self.model = model
    }
    
    func fetchChatRoomList() {
        let task = Task {
            do {
                let result = try await  NetworkManager2.getChatRoomList()
                print("❤️", result.data)
                let chatRoomList = result.data.map{$0.toDomain()}
                model?.updateChatRoomList(list: chatRoomList)
            } catch {
                // 에러 처리
                print("🚨error", error)
            }
        }
        
        tasks.append(task)
    }
    
//    func createChatRoom(opponentID : String) {
//        
//        let task = Task {
//            do {
//                let result = try await NetworkManager2.createChatRoom(body : CreateChatRoomBody(opponent_id: opponentID))
//                
//                self.fetchChatRoomList()
//            } catch {
//                // 에러 처리
//                print("🚨error", error)
//            }
//        }
//        
//        tasks.append(task)
//        
//    }
    
    func cancelTasks() {
        tasks.forEach{$0.cancel()}
        tasks.removeAll()
    }
    
}


/*
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
*/
