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
    
    @State private var lastTappedStoreID : String? = nil
    @State private var isBottomSheetMaxHeight : Bool = false
    
    
    var body : some View {
        ZStack{
            List(state.storeList, id : \.postId) {store in
                VStack{
                    Text(store.title)
                }
                .onTapGesture {
                    withAnimation{
                        if lastTappedStoreID == nil {
                            lastTappedStoreID = "11"
                        } else {
                            lastTappedStoreID = nil
                        }
                    }


                }
            }
            
            if lastTappedStoreID != nil {
                storeInfoBottomSheet
                    .toolbar(lastTappedStoreID != nil ? .hidden : .visible , for: .tabBar)
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


extension MapView {
    var storeInfoBottomSheet : some View {
        BottomSheetView(
            isOpen: $isBottomSheetMaxHeight,
            maxHeight: (ScreenSize.height-ScreenSize.statusBarHeight),
            backgroundColor: Assets.Colors.pointGreen3,
            showIndicator: true,
            minHeight : 240
//            minHeightRatio : 0.4
        ) {
            
            StoreInfoView(isExpanded: $isBottomSheetMaxHeight)
        }
    }
}
