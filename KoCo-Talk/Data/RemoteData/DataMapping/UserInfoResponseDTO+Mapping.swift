//
//  UserInfoResponseDTO+Mapping.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/18/25.
//

import Foundation

struct UpdateProfileResponseDTO : Decodable {
    let user_id : String
    let email : String
    let nick : String
    let profileImage : String?
    
    //    let followers
    //    let following
    //    let posts
}
