//
//  MapModel.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/10/25.
//

import Foundation

protocol MapModelStateProtocol{
    var storeList: [PostContentData] {get}
}
protocol MapModelActionProtocol : AnyObject{
    func updateStoreDataList(storeDataList : [PostContentData])
}

final class MapModel : MapModelStateProtocol, ObservableObject {
    @Published var storeList : [PostContentData] = []
}

extension MapModel : MapModelActionProtocol {
    func updateStoreDataList(storeDataList : [PostContentData]) {
        self.storeList = storeDataList
    }
}
