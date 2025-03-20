//
//  AuthRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

protocol AuthRepository {
    func login(email : String, password : String) async throws -> BaseUserInfo
}
