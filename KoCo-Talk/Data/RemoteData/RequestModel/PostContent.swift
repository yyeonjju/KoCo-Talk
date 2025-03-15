//
//  PostContent.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/10/25.
//

import Foundation

struct StoreInfoPostBody : Encodable {
    let category : String
    let title : String
    let price : Int
    
    let content : String
    let content1 : String
    let content2 : String
    let content3 : String
    let content4 : String
    let content5 : String
    
    let files : [String]

    let longitude : Double
    let latitude : Double
}

