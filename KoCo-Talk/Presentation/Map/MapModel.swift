//
//  MapModel.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/10/25.
//

import Foundation

protocol MapModelStateProtocol{
    var storeList: [PostContentData] {get}
    var startAddPois: Bool {get}
}
protocol MapModelActionProtocol : AnyObject{
    func updateStoreDataList(storeDataList : [PostContentData])
    func updateAddingPoisStatus(to : Bool)
}

final class MapModel : MapModelStateProtocol, ObservableObject {
    @Published var storeList : [PostContentData] = []
    @Published var startAddPois = false
}

extension MapModel : MapModelActionProtocol {
    func updateStoreDataList(storeDataList : [PostContentData]) {
        self.storeList = storeDataList
        
        //매장데이터 검색 끝났으면 맵에 pois 찍어주기위해
        self.updateAddingPoisStatus(to: true)
    }
    
    func updateAddingPoisStatus(to : Bool){
        self.startAddPois = to
    }
}
