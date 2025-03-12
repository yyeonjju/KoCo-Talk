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
    
    @State private var isBottomSheetMaxHeight : Bool = false
    
    
    @State private var currentCameraCenterCoordinate : LocationCoordinate? = nil
    @State private var draw : Bool = false
    @State private var isCameraMoving : Bool = false
    @State private var cameraMoveTo : LocationCoordinate?
    
    
    @State private var isBottomSheetOpen : Bool = false
    @State private var showReloadStoreDataButton : Bool = false
    
    @State var lastTappedStoreID : String = ""
    
    var body : some View {
        ZStack{
//            List(state.storeList, id : \.postId) {store in
//                VStack{
//                    Text(store.title)
//                }
//                .onTapGesture {
//                    withAnimation{
//                        if lastTappedStoreID == nil {
//                            lastTappedStoreID = "11"
//                        } else {
//                            lastTappedStoreID = nil
//                        }
//                    }
//
//
//                }
//            }
            
            kakaoMap
            
            
//            if showReloadStoreDataButton {
//                reloadStoreDataButton
//            }
            
            
            
//            if lastTappedStoreID != nil {
//                storeInfoBottomSheet
//                    .toolbar(lastTappedStoreID != nil ? .hidden : .visible , for: .tabBar)
//            }
            
            
        }
        .onAppear{
//            intent.fetchStoreInfoList()
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


extension MapView {
    var kakaoMap : some View {
        KakaoMapView(
            draw: $draw,
            isBottomSheetOpen : $isBottomSheetOpen,
            showReloadStoreDataButton : $showReloadStoreDataButton,
            isCameraMoving : $isCameraMoving,
            cameraMoveTo : $cameraMoveTo,
//            isPoisAdding : $vm.output.isPoisAdding,
//            LocationsToAddPois : $vm.output.LocationsToAddPois,
            currentCameraCenterCoordinate : $currentCameraCenterCoordinate,
            lastTappedStoreID : $lastTappedStoreID
//            selectedMyStoreAddingOnMap : $vm.output.selectedMyStoreAddingOnMap,
//            lastTappedStoreData : vm.output.lastTappedStoreData,
//            selectedMyStoreID : vm.output.selectedMyStoreID
        )
        .onAppear{
            draw = true
        }
        .onDisappear{
            draw = false
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var reloadStoreDataButton : some View {
        VStack{
            Button {
                guard let currentCameraCenterCoordinate = currentCameraCenterCoordinate else {return }
                
                //TODO: 지도 가운데 기준으로 매장 검색
//                vm.action(.fetchStoreData(location: currentCameraCenterCoordinate))
                
                //BottomSheet 올라와 있으면 내리기
//                vm.isBottomSheetOpen = false
            }label : {
                HStack{
                    Assets.SystemImages.arrowClockwise
                    Text("이 위치에서 검색")
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Assets.Colors.pointGreen2)
                .foregroundStyle(.white)
                .font(.system(size: 13))
                .cornerRadius(20)
                .padding(.top)
                .shadow(color: Assets.Colors.black.opacity(0.4), radius: 3)
                
            }
            
            Spacer()
        }
    }
}
