//
//  KakaoMapView.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/12/25.
//

import SwiftUI

import KakaoMapsSDK

struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool
    @Binding var isBottomSheetOpen : Bool
    @Binding var showReloadStoreDataButton : Bool
    
    @Binding var isCameraMoving : Bool
    @Binding var cameraMoveTo : LocationCoordinate?
//
//    @Binding var isPoisAdding : Bool
//    @Binding var LocationsToAddPois : [LocationDocument]
//
    @Binding var currentCameraCenterCoordinate : LocationCoordinate?
//
    @Binding var lastTappedStoreID : String
//
//    @Binding var selectedMyStoreAddingOnMap : Bool
//    var lastTappedStoreData : LocationDocument?
//    var selectedMyStoreID : String?
    
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
//        print("makeUIView")
        let view: KMViewContainer = KMViewContainer()
        view.sizeToFit()
        context.coordinator.createController(view)

        return view
    }
    

    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
//        print("updateUIView")
//        print("updateUIView - isCameraMoving", isCameraMoving)
//        print("updateUIView - isPoisAdding", isPoisAdding)
        
        if draw {
            DispatchQueue.main.async {
                if context.coordinator.controller?.isEnginePrepared == false {
                    context.coordinator.controller?.prepareEngine()
                }
                
                if context.coordinator.controller?.isEngineActive == false {
                    context.coordinator.controller?.activateEngine()
                }
            }
        }
        else {
            context.coordinator.controller?.pauseEngine()
//            context.coordinator.controller?.resetEngine()
        }
        
        
//        if isCameraMoving, let cameraMoveTo {
//            let mapPoint = MapPoint(longitude: cameraMoveTo.longitude, latitude: cameraMoveTo.latitude)
//            context.coordinator.moveCameraTo(mapPoint){
//                self.isCameraMoving = false
//            }
//        }
  
        
//
//        if isPoisAdding{
//            context.coordinator.createPois(currentPoint : cameraMoveTo, locations: LocationsToAddPois)
//        }
//
//        if selectedMyStoreAddingOnMap, let myStore = lastTappedStoreData, let longitude = Double(myStore.x), let latitude = Double(myStore.y) {
//            //선택한 myStore에 대해 poi 추가
//            context.coordinator.createSelectedMyStorePoi(myStore: myStore)
//
//            let myStoreMapPoint = MapPoint(longitude: longitude, latitude: latitude)
//            context.coordinator.moveCameraTo(myStoreMapPoint) {
//                self.selectedMyStoreAddingOnMap = false
//            }
//        }
        

        
       

    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
//        print("makeCoordinator")
        return KakaoMapCoordinator(self)
    }

    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
//        print("dismantleUIView")
        
    }
    
    
    
    
    
}
