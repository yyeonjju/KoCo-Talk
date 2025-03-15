//
//  StoreInfoEntities.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/10/25.
//

import Foundation


struct PostContentData {
    let postId : String
    let category : String
    let title : String
    let price : Int
    
    let storeData : StoreData?
    
    let createdAt : String
    
    let creatorId : String
    let creatorNickname : String
    let creatorProfileImage : String?
    
    let longitude : Double
    let latitude : Double
}


//Codable
//encoding : post 보낼 때 StoreInfoData자체를 인코딩한 후, string 형태로 post 보내기 위함
//decoding : string 형태의 데이터 -> StoreInfoData 형태로 디코딩하기 위함
struct StoreData : Codable {
    
    let placeName : String // 매장 이름
    let kakaoPlaceID : String // 카카오 매장 id
    let address : String // 주소
    let storeCategory : String // 카테고리
    let phone : String // 매장 번호
    
    let storeImages : [String] // 네이버 이미지 검색을 통한 메장 이미지
    
    let operatingTime : String //영업시간
    let availableLanguages : String // 가능 외국어
    
    let recommendProducts : [StoreProductContent] // 추천 상품
    let bestSellingProducts : [StoreProductContent] // 인기 상품
    let productStock : [StoreProductContent] //상품 재고

}
struct StoreProductContent : Codable{
    let imageUrl : String?
    let title : String?
    let description : String?
}
