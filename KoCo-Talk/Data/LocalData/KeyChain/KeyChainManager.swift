//
//  KeyChainManager.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

//서비스 식별자 추가하기: kSecAttrService를 추가하여 앱 내에서 키체인 항목을 더 명확하게 구분할 수 있다.
//kSecAttrService as String: "com.yourcompany.yourapp.auth", // 추가

fileprivate enum KeyChainNamespace {
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
}

// MARK: - KeyChain 저장, 삭제, 조회 함수 관리

fileprivate final class KeyChainManager {
    static let shared = KeyChainManager()
    private init() { }
    
    // MARK: - Save
    // accessToken
    func saveAccessToken(_ token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        deleteAccessToken()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeyChainNamespace.accessToken,
            kSecValueData as String: tokenData
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("accessToken 저장 성공")
        } else {
            print(status)
            print("accessToken 저장 실패")
        }
    }
    
    // refreshToken
    func saveRefreshToken(_ token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }
        deleteRefreshToken()

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeyChainNamespace.refreshToken,
            kSecValueData as String: tokenData
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("refreshToken 저장 성공")
        } else {
            print(status)
            print("refreshToken 저장 실패")
        }
    }
    
//    func saveAccessToken(_ token: String) {
//        guard let tokenData = token.data(using: .utf8) else { return }
//        deleteAccessToken()
//
//        let query: NSDictionary = [
//            kSecClass : kSecClassGenericPassword,
//            kSecAttrAccount : KeyChainNamespace.accessToken,
//            kSecAttrApplicationLabel: KeyChainNamespace.appName,
//            kSecValueData : tokenData
//        ]
//        let status = SecItemAdd(query as CFDictionary, nil)
//        
//        if status == errSecSuccess {
//            print("accessToken 저장 성공")
//        } else {
//            print(status)
//            print("accessToken 저장 실패")
//        }
//    }
//
//    func saveRefreshToken(_ token: String) {
//        guard let tokenData = token.data(using: .utf8) else { return }
//        deleteRefreshToken()
//
//        let query: NSDictionary = [
//            kSecClass : kSecClassGenericPassword,
//            kSecAttrAccount: KeyChainNamespace.refreshToken,
//            kSecAttrApplicationLabel: KeyChainNamespace.appName,
//            kSecValueData : tokenData
//        ]
//
//        let status = SecItemAdd(query as CFDictionary, nil)
//        
//        if status == errSecSuccess {
//            print("refreshToken 저장 성공")
//        } else {
//            print(status)
//            print("refreshToken 저장 실패")
//        }
//    }

    
    
    // MARK: - Get
    // accessToken
    func getAccessToken() -> String? {
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : KeyChainNamespace.accessToken,
            kSecReturnData : true,
            kSecMatchLimit : kSecMatchLimitOne
        ]

        //검색 결과를 불러와서 저장할 변수
        var item: CFTypeRef?
        //검색
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data else {
            print("accessToken 불러오기 실패")
            
            return nil
        }
        print("accessToken 불러오기 성공", data)

        return String(
            data: data,
            encoding: .utf8
        )
    }
    
    // refreshToken
    func getRefreshToken() -> String? {
        let query: NSDictionary = [
            kSecClass : kSecClassGenericPassword,
            kSecAttrAccount : KeyChainNamespace.refreshToken,
            kSecReturnData : true,
            kSecMatchLimit : kSecMatchLimitOne
        ]

        //검색 결과를 불러와서 저장할 변수
        var item: CFTypeRef?
        //검색
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
                let data = item as? Data else {
            print("refreshToken 불러오기 실패")
            return nil
        }
        print("refreshToken 불러오기 성공", data)

        return String(
            data: data,
            encoding: .utf8
        )
    }

    // MARK: - Delete
    // accessToken
    func deleteAccessToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeyChainNamespace.accessToken
        ]

        SecItemDelete(query as CFDictionary)
    }
    
    // refreshToken
    func deleteRefreshToken() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: KeyChainNamespace.refreshToken
        ]

        SecItemDelete(query as CFDictionary)
    }
}

// MARK: - KeyChain value 중앙 관리

enum KeyChainValue {
    @KeyChainWrapper(key : .accessToken, defaultValue : nil) static var accessToken : String?
    @KeyChainWrapper(key : .refreshToken, defaultValue : nil) static var refreshToken : String?

}

@propertyWrapper
struct KeyChainWrapper<T : Codable> {
    
    enum KeyChainKey : String {
        case accessToken
        case refreshToken
    }
    
    let key : KeyChainKey
    let defaultValue : T
    
    var wrappedValue: T {
        get {
            switch key{
            case .accessToken:
                guard let accessToken = KeyChainManager.shared.getAccessToken() as? T else {return defaultValue}
                return accessToken
                
            case .refreshToken:
                guard let refreshToken = KeyChainManager.shared.getRefreshToken() as? T else {return defaultValue}
                return refreshToken
                
            }
            
        }
        set {
            switch key{
            case .accessToken:
                if let value = newValue as? String {
                    KeyChainManager.shared.saveAccessToken(value)
                }
            case .refreshToken:
                if let value = newValue as? String {
                    KeyChainManager.shared.saveRefreshToken(value)
                }
            }
            
        }

    }
}
