//
//  Router.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation
import Alamofire

enum Router {
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) static var userInfo : LoginResponse?
    
    case tokenRefresh
    case login(body : LoginBody)
    
    
    case getStores(next : String, limit : String, category : String)
//    case getLocationBasedStores
    case createChatRoom(body : CreateChatRoomBody)
    case getChatRoomList
//
    case postChat(roomId : String, body : PostChatBody)
    case getChatContents(roomId : String, cursorDate : String)
    
    //파일업로드
    case uploadFiles
}

extension Router : TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .tokenRefresh, .getStores, .getChatRoomList, .getChatContents :
                .get
        case .createChatRoom, .postChat, .login, .uploadFiles :
                .post
        }
    }
    
    var baseURL: String {
        return APIURL.baseUrl+APIURL.version
    }
    
    var path: String {
        switch self {
        case .tokenRefresh :
            return APIURL.tokenRefresh
        case .login :
            return APIURL.login
            
            
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
        case .postChat(let roomId, _) :
            return APIURL.postChat + "/\(roomId)"
        case .uploadFiles :
            return APIURL.uploadFiles
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login :
            return [
                APIKEY.sesacKey_key : APIKEY.sesacKey_value,
                APIKEY.productId_key : APIKEY.productId_value,
                APIKEY.contentType_key : APIKEY.contentType_applicationJson
            ]
        case .tokenRefresh :
            return [
                APIKEY.sesacKey_key : APIKEY.sesacKey_value,
                APIKEY.productId_key : APIKEY.productId_value,
                APIKEY.tokenRefresh_key : Router.userInfo?.refresh ?? "-"
            ]
        case .getStores, .getChatRoomList, .getChatContents:
            return [
                APIKEY.sesacKey_key : APIKEY.sesacKey_value,
                APIKEY.productId_key : APIKEY.productId_value,
                APIKEY.accessToken_key : Router.userInfo?.access ?? "-"
            ]
        case .createChatRoom, .postChat, .uploadFiles :
            return [
                APIKEY.sesacKey_key : APIKEY.sesacKey_value,
                APIKEY.productId_key : APIKEY.productId_value,
                APIKEY.accessToken_key : Router.userInfo?.access ?? "-",
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
        case .login(let body ) :
            do{
                let data = try encoder.encode(body)
                return data
            }catch{
                return nil
            }
        case .createChatRoom(let body) :
            do{
                let data = try encoder.encode(body)
                return data
            }catch{
                return nil
            }
        case .postChat(_, let body) :
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

