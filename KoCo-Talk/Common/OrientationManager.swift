//
//  OrientationManager.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/3/25.
//

import SwiftUI
import UIKit
import Combine

final class OrientationManager : ObservableObject {
    var prevType : UIDeviceOrientation = .portrait
    @Published var type : UIDeviceOrientation = .unknown
    
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = OrientationManager()
    
    private init() {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let sceneDelegate = scene as? UIWindowScene else {return }
        
        let orientation  = sceneDelegate.interfaceOrientation
        
        switch orientation {
        case .portrait: type = .portrait
        case .portraitUpsideDown: type = .portraitUpsideDown
        case .landscapeLeft: type = .landscapeLeft
        case .landscapeRight: type = .landscapeRight
            
        default: type = .unknown
        }
        
        NotificationCenter.default
            .publisher(for: UIDevice.orientationDidChangeNotification)
            .sink() { [weak self] _ in
                guard let self else {return }
//                print("🌹orientation🌹", UIDevice.current.orientation.rawValue)
                
                self.prevType = self.type == .unknown ? .portrait : self.type
                
                self.type = UIDevice.current.orientation
            }
            .store(in: &cancellables)
    }
}


@propertyWrapper 
struct Orientation: DynamicProperty {
    @StateObject private var manager = OrientationManager.shared
    //isFlat은 이 프로젝트에서 의미 없으므로 이전에 저장해둔 방향 그대로 리턴
    var wrappedValue: UIDeviceOrientation {
        if manager.type.isFlat {
            return manager.prevType
        }else {
            return manager.type
        }
    }
}
