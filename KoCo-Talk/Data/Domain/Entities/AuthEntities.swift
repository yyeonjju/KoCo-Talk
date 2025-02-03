//
//  Auth.swift
//  KoCo-Talk
//
//  Created by 하연주 on 2/3/25.
//

import Foundation

//encode&decode : userDegaults에 저장
struct LoginResponse : Codable {
    let id: String
    let email: String
    let nick: String
    let profileImage: String?
    var access: String
    let refresh: String
}
