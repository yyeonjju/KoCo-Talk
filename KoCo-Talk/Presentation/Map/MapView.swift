//
//  MapView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import SwiftUI

//TODO: bottom sheet UI 구성



struct MapView : View {
    @StateObject private var locationManager = LocationManager()
    @StateObject var container : Container<MapIntentProtocol, MapModelStateProtocol>
    private var state : MapModelStateProtocol {container.model}
    private var intent : MapIntentProtocol {container.intent}
    
    @State private var isBottomSheetMaxHeight : Bool = false
    
    @State private var draw : Bool = false
    @State private var isCameraMoving : Bool = false
    @State private var cameraMoveTo : LocationCoordinate?
    @State private var currentCameraCenterCoordinate : LocationCoordinate? = nil
    @State private var bottomSheetShown : Bool = false //poi가 탭되었을 때 true
    @State private var showReloadStoreDataButton : Bool = false
    
    @State private var lastTappedPostID : String = ""
    @State private var tappedPostData : PostContentData?

    
    
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
            
            if showReloadStoreDataButton {
                reloadStoreDataButton
            }
            
            if bottomSheetShown {
                storeInfoBottomSheet
                    .toolbar(bottomSheetShown ? .hidden : .visible , for: .tabBar)
            }
            
            
        }
        .onChange(of: lastTappedPostID) { newValue in
//            print("🌹방금 눌린 post id", newValue)
            let tappedData = state.storeList.first {$0.postId == newValue}
            tappedPostData = tappedData
//            print("🌹tappedPostData", tappedPostData)
        }
        .onChange(of: locationManager.lastKnownLocation) { newValue in
            
            //일시적 fix
            // viewInit 되기 전에 현재 위치로 카메라 이동 함수가 실행되면 작동하지 않으므로 타이밍 미루기
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                guard let newValue else {return }
                //1 : 카카오 맵의 카메라 위치 이동 ( 현재 나의 위치 or 위치 권한 없다면 임의의 위치로)
                isCameraMoving = true
                cameraMoveTo = newValue
                
                
                //2 : 매장 정보 검색 -> poi 꽂기
//                intent.fetchStoreInfoList()
                
                //현재 위치 기준 검색
                intent.fetchLocationBasedStores(
                    location: LocationCoordinate(longitude: newValue.longitude, latitude: newValue.latitude)
//                        LocationCoordinate(longitude: 127.02296, latitude: 37.52082)
                )
            }
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
            if let tappedPostData {
                StoreInfoView(isExpanded: $isBottomSheetMaxHeight, tappedPostData : tappedPostData)
            } else {
                Text("탭한 매장의 데이터가 없습니다.")
                    .customFont(fontName: .NanumSquareR, size: 14)
                    .foregroundStyle(Assets.Colors.gray3)
                    .padding(.top, 30)
            }
            
        }
    }
}


extension MapView {
    var kakaoMap : some View {
        KakaoMapView(
            draw: $draw,
            bottomSheetShown : $bottomSheetShown,
            showReloadStoreDataButton : $showReloadStoreDataButton,
            isCameraMoving : $isCameraMoving,
            cameraMoveTo : $cameraMoveTo,
            
            startAddPois : Binding(
                get: { state.startAddPois },
                set: { intent.updateAddingPoisStatus(to: $0)}
            ),
            locationsToAddPois : state.storeList,
            
            currentCameraCenterCoordinate : $currentCameraCenterCoordinate,
            lastTappedPostID : $lastTappedPostID
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
                //TODO: 지도 가운데 기준으로 매장 검색
                guard let currentCameraCenterCoordinate = currentCameraCenterCoordinate else {return }
                print("💕💕지도 가운데💕💕", currentCameraCenterCoordinate)
                intent.fetchLocationBasedStores(
                    location: LocationCoordinate(longitude: currentCameraCenterCoordinate.longitude, latitude: currentCameraCenterCoordinate.latitude)
                )
                
                //BottomSheet 올라와 있으면 내리기
                bottomSheetShown = false
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
