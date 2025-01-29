//
//  Router.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation
import Alamofire

enum Router {
    case getStores(next : String, limit : String, category : String)
//    case getLocationBasedStores
    case createChatRoom(body : CreateChatRoomBody)
    case getChatRoomList
//
//    case postChat
    case getChatContents(roomId : String, cursorDate : String)
}

extension Router : TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getStores, .getChatRoomList, .getChatContents :
                .get
        case .createChatRoom :
                .post
        }
    }
    
    var baseURL: String {
        return APIURL.baseUrl+APIURL.version
    }
    
    var path: String {
        switch self {
        case .getStores:
            return APIURL.getStores
        case .createChatRoom :
            return APIURL.createChatRoom
        case .getChatRoomList :
            return APIURL.getChatRoomList
//        case .postChat :
//            return APIURL.postChat
        case .getChatContents(let roomId, _) :
            return APIURL.getChatContents + "/\(roomId)"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .getStores, .getChatRoomList, .getChatContents:
            return [
                APIKEY.sesacKey_key : APIKEY.sesacKey_value,
                APIKEY.productId_key : APIKEY.productId_value,
                APIKEY.accessToken_key : APIKEY.accessToken_value
            ]
        case .createChatRoom :
            return [
                APIKEY.sesacKey_key : APIKEY.sesacKey_value,
                APIKEY.productId_key : APIKEY.productId_value,
                APIKEY.accessToken_key : APIKEY.accessToken_value,
                APIKEY.contentType_key : APIKEY.contentType_applicationJson
            ]
        }
    }
    
//    var parameters: String? {
//        return nil
//    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .getStores(let next, let limit, let category):
            return [
                URLQueryItem(name: APIKEY.category_key, value: category),
                URLQueryItem(name: "next", value: next),
                URLQueryItem(name: "limit", value: limit)
            ]
//        case .createChatRoom :
//            return [
//                URLQueryItem(name: APIKEY.category_key, value: APIKEY.category_value)
//            ]
        case .getChatContents(_, let cursorDate) :
            return [
                URLQueryItem(name: "cursor_date", value: cursorDate)
            ]
            
        default :
            return []
            
        }
    }
    
    var body: Data? {
        let encoder = JSONEncoder()
        
        switch self {
        case .createChatRoom(let body) :
            do{
                let data = try encoder.encode(body)
                return data
            }catch{
                return nil
            }
        
        default :
            return nil
            
        }
    }
    
    
}

