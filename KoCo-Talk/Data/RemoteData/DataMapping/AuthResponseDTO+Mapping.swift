//
//  AuthResponseDTO+Mapping.swift
//  KoCo-Talk
//
//  Created by 하연주 on 2/3/25.
//

import Foundation

// MARK: - Login
struct LoginResponseDTO : Decodable {
    let id: String
    let email: String
    let nick: String
    let profileImage: String?
    var access: String
    let refresh: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email, nick
        case profileImage = "profileImage"
        case access = "accessToken"
        case refresh = "refreshToken"
    }
}

extension LoginResponseDTO {
    func toDomain() -> LoginResponse {
        return LoginResponse(id: id, email: email, nick: nick, profileImage: profileImage, access: access, refresh: refresh)
    }
}


// MARK: - Token Refresh
struct TokenRefreshResponse : Decodable {
    let accessToken : String
}


