//
//  MapView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import SwiftUI

struct MapView : View {
    @StateObject var container : Container<MapIntentProtocol, MapModelStateProtocol>
    private var state : MapModelStateProtocol {container.model}
    private var intent : MapIntentProtocol {container.intent}
    
    
    var body : some View {
        List(state.storeList, id : \.postId) {store in
            VStack{
                Text(store.title)
            }
        }
            .onAppear{
                intent.fetchStoreInfoList()
            }
    }
}

extension MapView {
    static func build() -> MapView{
        let model = MapModel()
        let intent = MapIntent(model: model) // model의 action 프로토콜 부분 전달
        let container = Container(
            intent: intent as MapIntentProtocol,
            model: model as MapModelStateProtocol,
            modelChangePublisher: model.objectWillChange
        )
        
        return MapView(container: container)
    }
}
