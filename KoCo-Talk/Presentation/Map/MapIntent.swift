//
//  MapIntent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/10/25.
//

import Foundation
import Combine

protocol MapIntentProtocol {
    func fetchStoreInfoList()
}

final class MapIntent : MapIntentProtocol{
    private var cancellables = Set<AnyCancellable>()
    private weak var model : MapModelActionProtocol?
    
    init(model: MapModelActionProtocol) {
        self.model = model
    }
    
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
                 print("🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡🧡매장 데이터", result.data)
                 
                 let storeDataList = result.data.map{$0.toDomain()}
                 model.updateStoreDataList(storeDataList: storeDataList)
                 
             })
             .store(in: &cancellables)
         
    }
    
}
