//
//  AppDelegate.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/3/25.
//

import UIKit
import KakaoMapsSDK

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 키보드 알림 관찰 시작
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) {[weak self] notification in
            guard let self else {return }
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
            
            let isPortrait = OrientationManager.shared.type.isPortrait
            
//            print("🌹 isPortrait", isPortrait)
//            print("🌹keyboardFrame.height", keyboardFrame.height)
            if isPortrait {
                UserDefaultsManager.portraitKeyboardHeight = keyboardFrame.height
            }else {
                UserDefaultsManager.landscapeKeyboardHeight = keyboardFrame.height
            }
        }

        //카카오맵을 위한 init
        SDKInitializer.InitSDK(appKey: APIKEY.kakaoNativeAppKey)
        
        return true
    }
}
