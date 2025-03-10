//
//  PostContent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/10/25.
//

import Foundation

//content1에 인코딩해서 넣을 때
struct StoreInfo : Encodable {
    
    let placeName : String // 매장 이름
    let kakaoPlaceID : String // 카카오 매장 id
    let address : String // 주소
    let category : String // 카테고리
    let phone : String // 매장 번호
    
    let recommendProducts : [String] // 추천 상품
    let bestSellingProducts : [String] // 인기 상품
    let availableLanguages : [String] // 가능 외국어
    let storeImages : [String] // 네이버 이미지 검색을 통한 메장 이미지
    
    let files : [String]
    
    //placeUrl
}
