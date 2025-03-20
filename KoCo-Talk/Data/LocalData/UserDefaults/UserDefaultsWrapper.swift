//
//  UserDefaultsWrapper.swift
//  KoCo-Talk
//
//  Created by 하연주 on 2/2/25.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<T : Codable> {
    
    enum UserDefaultsKey : String {
        case userInfo // LoginResponse
        case portraitKeyboardHeight
        case landscapeKeyboardHeight
    }
    
    let key : UserDefaultsKey
    let defaultValue : T
    
    var wrappedValue: T {
        get {
            guard let data = UserDefaults.standard.object(forKey: key.rawValue) as? Data else {return defaultValue}
            let decoder = JSONDecoder()
            let decodedObject = try? decoder.decode(T.self, from: data)
            guard let decodedObject else {return defaultValue}
            return decodedObject
        }
        set {
            let encoder = JSONEncoder()
            if let encodedStruct = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encodedStruct, forKey: key.rawValue)
            }
        }

    }
}


enum UserDefaultsManager {
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) static var userInfo : LoginResponse?
    
    @UserDefaultsWrapper(key : .portraitKeyboardHeight, defaultValue: 0.0) static var portraitKeyboardHeight : CGFloat
    @UserDefaultsWrapper(key : .landscapeKeyboardHeight, defaultValue: 0.0) static var landscapeKeyboardHeight : CGFloat
}
