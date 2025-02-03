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
            
            AF.request(request, interceptor: APIRequestInterceptor())
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
    
    static func getChatRoomContents(roomId : String, cursorDate : String) -> AnyPublisher<ChatRoomContentListResponseDTO, FetchError> {
        let router = Router.getChatContents(roomId: roomId, cursorDate: cursorDate)
        return fetch(fetchRouter: router, model: ChatRoomContentListResponseDTO.self)
    }
    
    static func postChat(roomId : String, body : PostChatBody) -> AnyPublisher<ChatRoomContentDTO, FetchError> {
        let router = Router.postChat(roomId: roomId, body: body)
        return fetch(fetchRouter: router, model: ChatRoomContentDTO.self)
    }
    
    
    //Auth
    static func tokenRefresh() -> AnyPublisher<TokenRefreshResponse, FetchError> {
        let router = Router.tokenRefresh
        return fetch(fetchRouter: router, model : TokenRefreshResponse.self)
    }
    
    static func login(body : LoginBody) -> AnyPublisher<LoginResponseDTO, FetchError> {
        let router = Router.login(body: body)
        return fetch(fetchRouter: router, model : LoginResponseDTO.self)
    }
}




//토큰 리프레시 로직
final class APIRequestInterceptor: RequestInterceptor {
    @UserDefaultsWrapper(key : .userInfo, defaultValue : nil) var userInfo : LoginResponse?
    var cancellables = Set<AnyCancellable>()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        //TODO: 로그인 url 아닐 때만 setValu하기
        
        //🌸🌸🌸🌸🌸🌸
        // 토큰 리프레시 요청을 할 때 엑세스 토큰 넣으면 401에러 나고
        // 토큰 리프레시 요청을 할 때 엑세스 토큰 안넣으면 403에러남..;;
        
//        if urlRequest.url?.path() != APIURL.version + APIURL.tokenRefresh {
//            print("🌸🌸🌸토큰 리프레시가 아닐 때만 엑세스 토큰 넣어줌🌸🌸🌸")
            urlRequest.setValue((userInfo?.access ?? ""), forHTTPHeaderField: APIKEY.accessToken_key)
//        }
        
        print("adapt - headers -> ", urlRequest.headers)
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("💜💜💜retry")

        guard let response = request.task?.response as? HTTPURLResponse, request.retryCount <  4 else{
            completion(.doNotRetryWithError(error))
            return
        }
        
        if response.statusCode == 419 { // 419일 때
            print("💜💜💜retry -> 419이다!!")
            
            NetworkManager.tokenRefresh()
                .sink(receiveCompletion: {[weak self] receiveCompletion in
                    guard let self else { return }
                    switch receiveCompletion {
                    case .failure(let error):
                        print("⭐️⭐️receiveCompletion - failure", error)
                        
                        //엑세스 토큰 갱신 요청에서의 실패 result (418 리프레시 만료 시 에러날 수 있다)
                        completion(.doNotRetryWithError(error))
                        
                    case .finished:
                        break
                    }
                    
                }, receiveValue: {[weak self]  result in
                    guard let self else { return }
                    
                    userInfo?.access = result.accessToken
                    completion(.retry)
                })
                .store(in: &cancellables)

        } else if response.statusCode == 418 ||
                    response.statusCode == 401 {
            //418 - 리프레시 토큰 만료
            // 401 - 인증할 수 없는 리프레시토큰
            print("💜💜💜retry ->", response.statusCode)
            DispatchQueue.main.async{
                AuthManager.shared.status = .notauthorized
            }
            
            completion(.doNotRetryWithError(error))
        
        } else {
            print("💜💜💜 418❌ 419❌")
            completion(.doNotRetryWithError(error))
        }

    }
}




