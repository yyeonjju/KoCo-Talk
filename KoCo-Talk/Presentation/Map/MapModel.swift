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
    }
    
    func updateAddingPoisStatus(to : Bool){
        self.startAddPois = to
    }
}
