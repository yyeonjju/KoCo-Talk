//
//  MapIntent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/10/25.
//

import Foundation
import Combine
import SwiftUI

@MainActor
protocol MapIntentProtocol {
//    func fetchStoreInfoList() //전체 게시물 로드
    func updateAddingPoisStatus(to : Bool)
    func fetchLocationBasedStores(location : LocationCoordinate) //위치 기반 게시물 로드
    func createChatRoom(opponentId : String, selectedTab : Binding<TabBarTag>)
    func cancelTasks()
}


final class MapIntent : MapIntentProtocol{
    @Injected private var defaultMapRepository : MapRepository
    
    private weak var model : MapModelActionProtocol?
    private var tasks : [Task<Void, Never>] = []
    
    init(model: MapModelActionProtocol) {
        self.model = model
    }
    
    func updateAddingPoisStatus(to : Bool){
        guard let model else {return }
        model.updateAddingPoisStatus(to: to)
    }
    
    func fetchLocationBasedStores(location : LocationCoordinate) {
        
        let task = Task { [weak self] in
            guard let self, let model else { return }
            
            do {
                let result = try await defaultMapRepository.fetchLocationBasedStores(location: location)
                
                model.updateStoreDataList(storeDataList: result)
                print("🧡🧡🧡 매장 데이터", result)
                
                //매장데이터 검색 끝났으면 맵에 pois 찍어주기위해
                updateAddingPoisStatus(to: true)
            } catch {
                // 에러 처리
                print("🚨error", error)
            }
        }

        tasks.append(task)

    }
    
    func createChatRoom(opponentId : String, selectedTab : Binding<TabBarTag>) {
        
        
        let task = Task {
            do {
                let roomId = try await defaultMapRepository.createChatRoom(opponentId : opponentId)
                print("🧡🧡🧡 채팅방 생성 완료", roomId)
                selectedTab.wrappedValue = TabBarTag.chat
            } catch {
                // 에러 처리
                print("🚨error", error)
            }
        }

        tasks.append(task)
    }
    
    func cancelTasks() {
        tasks.forEach{$0.cancel()}
        tasks.removeAll()
    }
    
}



/*
final class MapIntent : MapIntentProtocol{
    private var cancellables = Set<AnyCancellable>()
    private weak var model : MapModelActionProtocol?
    
    init(model: MapModelActionProtocol) {
        self.model = model
    }
    
    func updateAddingPoisStatus(to : Bool){
        guard let model else {return }
        model.updateAddingPoisStatus(to: to)
    }
    
    /*
    func fetchStoreInfoList() {
        NetworkManager.getStores(limit: "20", nextCursor: "")
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
 
                 
                 let storeDataList = result.data.map{$0.toDomain()}
                 model.updateStoreDataList(storeDataList: storeDataList)
                 
                 print("🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡매장 데이터", storeDataList)
                 
             })
             .store(in: &cancellables)
    }
     */
    
    func fetchLocationBasedStores(location : LocationCoordinate) {
        NetworkManager.getLocationBasedStores(location: location)
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
 
                 
                 let storeDataList = result.data.map{$0.toDomain()}
                 model.updateStoreDataList(storeDataList: storeDataList)
                 print("🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡매장 데이터", storeDataList)
                 
                 //매장데이터 검색 끝났으면 맵에 pois 찍어주기위해
                 updateAddingPoisStatus(to: true)
                 
             })
             .store(in: &cancellables)
    }
    
    func createChatRoom(opponentId : String, selectedTab : Binding<TabBarTag>) {
        let body = CreateChatRoomBody(opponent_id: opponentId)
        NetworkManager.createChatRoom(body: body)
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
                 
                 selectedTab.wrappedValue = TabBarTag.chat
                 
             })
             .store(in: &cancellables)
    }
    
}
*/
