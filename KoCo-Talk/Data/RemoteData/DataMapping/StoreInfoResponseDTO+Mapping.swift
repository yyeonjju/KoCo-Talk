//
//  StoreInfoResponseDTO+Mapping.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation

struct PostContentResponseDTO : Decodable {
    let data : [PostContentDTO]
    let next_cursor : String
}

struct PostContentDTO : Decodable {
    
    let postId : String
    let category : String
    let title : String
    let price : Int
    
    let content : String
    let content1 : String
    let content2 : String
    let content3 : String
    let content4 : String
    let content5 : String
    
    let createdAt : String
    let creator : PostContentCreatorDTO
    
    let files : [String]
    let likes : [String]
    let likes2 : [String]
    let buyers : [String]
    let hashTags : [String]
//    let comments : []
    let geolocation : PostContentGeoLocationDTO
    let distance : String?
    
    enum CodingKeys: String,CodingKey {
        case postId = "post_id"
        case category, title, price, content, content1, content2, content3, content4, content5, createdAt, creator, files, likes, likes2, buyers, hashTags, geolocation, distance
    }
}

struct PostContentGeoLocationDTO : Decodable {
    let longitude : Double
    let latitude : Double
}

struct PostContentCreatorDTO : Decodable {
    let userId : String
    let nick : String
    let profileImage : String?
    
    enum CodingKeys: String,CodingKey {
        case userId = "user_id"
        case nick, profileImage
    }
}


extension PostContentDTO {
    func toDomain() -> PostContentData {
        //String -> Data
        let storeInfoData = self.content.data(using: .utf8)!
        //Data -> StoreInfoData
        let decodedStoreInfoData = try? JSONDecoder().decode(StoreInfoData.self, from: storeInfoData)
        
//        print("❤️잘 디코딩된다❤️", decodedStoreInfoData)
        
        
        return PostContentData(
            postId: self.postId,
            category: self.category,
            title: self.title,
            price: self.price,
            storeData: decodedStoreInfoData,
            createdAt: self.createdAt,
            creatorId: self.creator.userId,
            creatorNickname: self.creator.nick,
            creatorProfileImage: self.creator.profileImage,
            longitude: self.geolocation.longitude,
            latitude: self.geolocation.latitude
        )
    }
}

