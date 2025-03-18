//
//  Router.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation
import Alamofire

enum OrderBy : String {
    case distance
    case createdAt
}

enum SortBy : String {
    case asc
    case desc
}

enum Router {
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) static var userInfo : LoginResponse?
    
    //Auth
    case tokenRefresh
    case login(body: LoginBody)
    
    //Store
    case getStores(next: String, limit: String, category: String)
    case getLocationBasedStores(category: String, coordinate : LocationCoordinate, maxDistance : Int, orderBy : OrderBy, sortBy : SortBy)
    case postStoreData(body : StoreInfoPostBody)
    
    //Chat
    case createChatRoom(body: CreateChatRoomBody)
    case getChatRoomList
    case postChat(roomId: String, body: PostChatBody)
    case getChatContents(roomId: String, cursorDate: String)
    
    //file
    case uploadFiles
    case downloadFile(url : String)
    
    //user
    case updateProfile(body : UpdateProfileRequestBody)
}

extension Router : TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .tokenRefresh, .getStores, .getChatRoomList, .getChatContents, .downloadFile, .getLocationBasedStores :
                .get
        case .createChatRoom, .postChat, .login, .uploadFiles, .postStoreData :
                .post
        case .updateProfile :
                .put
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
        case .getLocationBasedStores:
            return APIURL.getLocationBasedStores
        case .postStoreData:
            return APIURL.postStoreData
            
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
        case .downloadFile(let url) :
            return APIURL.downloadFile + url
        case .updateProfile :
            return APIURL.updateProfile
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
        case .getStores, .getLocationBasedStores, .getChatRoomList, .getChatContents, .downloadFile:
            return [
                APIKEY.sesacKey_key : APIKEY.sesacKey_value,
                APIKEY.productId_key : APIKEY.productId_value,
                APIKEY.accessToken_key : Router.userInfo?.access ?? "-"
            ]
        case .createChatRoom, .postChat, .uploadFiles, .postStoreData :
            return [
                APIKEY.sesacKey_key : APIKEY.sesacKey_value,
                APIKEY.productId_key : APIKEY.productId_value,
                APIKEY.accessToken_key : Router.userInfo?.access ?? "-",
                APIKEY.contentType_key : APIKEY.contentType_applicationJson
            ]
        case  .updateProfile(let body):
            return [
                APIKEY.sesacKey_key : APIKEY.sesacKey_value,
                APIKEY.productId_key : APIKEY.productId_value,
                APIKEY.accessToken_key : Router.userInfo?.access ?? "-",
                APIKEY.contentType_key : "\(APIKEY.contentType_multipart); boundary=\(body.boundary)"
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
        case .getLocationBasedStores(let category, let coordinate, let maxDistance, let orderBy, let sortBy):
            return [
                URLQueryItem(name: APIKEY.category_key, value: category),
                URLQueryItem(name: "longitude", value: "\(coordinate.longitude)"),
                URLQueryItem(name: "latitude", value: "\(coordinate.latitude)"),
                URLQueryItem(name: "maxDistance", value: "\(maxDistance)"),
                URLQueryItem(name: "order_by", value: orderBy.rawValue),
                URLQueryItem(name: "sort_by", value: sortBy.rawValue),
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
        case .postStoreData(let body) :
            do{
                let data = try encoder.encode(body)
                return data
            }catch{
                return nil
            }
        case .updateProfile(let body) :
            return userProfileBody(body)
        default :
            return nil
            
        }
    }
    
    private func userProfileBody(_ profile: UpdateProfileRequestBody) -> Data {
        var body = Data()
        
        // nick
        if let nick = profile.nick{
            body.append("--\(profile.boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"nick\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(nick)\r\n".data(using: .utf8)!)
        }
        
        // profile (이미지)
        if let profileData = profile.profile {
            
            body.append("--\(profile.boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"profile\"; filename=\"profile.png\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(profileData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // 종료 boundary
        body.append("--\(profile.boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}

