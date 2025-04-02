//
//  UserInfo.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/18/25.
//

import Foundation

struct UpdateProfileRequestBody : Encodable {
    let boundary = UUID()
    let nick : String?
    let profile : Data?
}
