//
//  DefaultAuthRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation


final class DefaultAuthRepository : AuthRepository {
    func login(email : String, password : String) async throws -> BaseUserInfo {
        
        let body = LoginBody(email: email, password: password)
        let result = try await NetworkManager2.shared.login(body: body)
        // 값 처리
        print("❤️ 로그인 했다!, -> ", result.toUserInfo())
        UserDefaultsManager.userInfo = result.toUserInfo()
        
        KeyChainValue.accessToken = result.access
        KeyChainValue.refreshToken = result.refresh
        print("❤️accessToken -> ",KeyChainValue.accessToken )
        print("❤️refreshToken -> ",KeyChainValue.refreshToken )
        
        return result.toUserInfo()
    }
}
