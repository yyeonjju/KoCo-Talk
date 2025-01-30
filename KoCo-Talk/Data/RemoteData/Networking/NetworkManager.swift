//
//  NetworkManager.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation
import Combine
import Alamofire


enum FetchError : Error {
    case url
    case invalidRequest
    case invalidResponse
    case failedRequest
    case noData
    case invalidData
    case unknownError
    case failResponse(code : Int, message : String)
    
    var errorMessage : String {
        switch self {
        case .url:
            return "잘못된 url입니다"
        case .invalidRequest:
            return "유효하지 않은 요청입니다"
        case .invalidResponse:
            return "유효하지 않은 응답입니다"
        case .failedRequest:
            return "요청에 실패했습니다"
        case .noData:
            return "데이터가 없습니다"
        case .invalidData:
            return "데이터 디코딩에 실패했습니다"
        case .unknownError:
            return "알 수 없는 에러입니다"
        case .failResponse(let errorCode, let message):
            return "\(errorCode)error : \(message)"
        }
    }
}


enum NetworkManager {
    static func fetch<M : Decodable>(fetchRouter : Router, model : M.Type) -> AnyPublisher<M,FetchError> {
        
        let future = Future<M,Error> { promise in
            guard let request = try? fetchRouter.asURLRequest() else {
                return promise(.failure(FetchError.invalidRequest))
            }
            
            print("🌸request - ", request.url)
            
            
            AF.request(request)
                .responseDecodable(of: model.self) { response in
                    
                    guard response.response != nil else {
                        return promise(.failure(FetchError.invalidResponse))
                    }
                    
                    guard let statusCode = response.response?.statusCode else {
                        return promise(.failure(FetchError.failedRequest))
                    }
                    
                    guard let data = response.data else {
                        return promise(.failure(FetchError.noData))
                    }
                    
                    
                    if statusCode != 200 {
                        var errorMessage: String?
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            errorMessage = json["message"] as? String
                        }
                        
                        return promise(.failure(FetchError.failResponse(code: statusCode, message: errorMessage ?? "")))
                    }
                    
                    
                    
                    switch response.result {
                    case .success(let value):
                        return promise(.success(value))
                        
                    case .failure:
                        return promise(.failure(FetchError.invalidData))
                    }
                    
                }
        }

        
        return future
            .mapError { error -> FetchError in
                if let error = error as? FetchError {
                    return error
                } else {
                    return FetchError.unknownError
                }
            }
            .eraseToAnyPublisher()
        
        
    }
}


extension NetworkManager {
    static func getStores (limit : String, nextCursor : String, size : Int) -> AnyPublisher<StoreInfoResponseDTO, FetchError> {
        let router = Router.getStores(next: limit, limit: nextCursor, category: APIKEY.category_value)
        return fetch(fetchRouter: router, model: StoreInfoResponseDTO.self)
    }
    
    static func createChatRoom(body : CreateChatRoomBody) -> AnyPublisher<ChatRoomResponseDTO, FetchError> {
        let router = Router.createChatRoom(body: body)
        return fetch(fetchRouter: router, model: ChatRoomResponseDTO.self)
    }
    
    static func getChatRoomList() -> AnyPublisher<ChatRoomListResponseDTO, FetchError> {
        let router = Router.getChatRoomList
        return fetch(fetchRouter: router, model: ChatRoomListResponseDTO.self)
    }
    
    static func getChatRoomContents(roomId : String, cursorDate : String) -> AnyPublisher<ChatRoomContentsResponseDTO, FetchError> {
        let router = Router.getChatContents(roomId: roomId, cursorDate: cursorDate)
        return fetch(fetchRouter: router, model: ChatRoomContentsResponseDTO.self)
    }
}

