//
//  NetworkManager2.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/19/25.
//

import Foundation
import Alamofire


enum NetworkManager2 {
    
    // 공통된 응답 처리 로직을 메서드로 분리
    private static func handleResponse<M: Decodable>(response: AFDataResponse<M>) throws -> M {
        guard response.response != nil else {
            throw FetchError.invalidResponse
        }
        
        guard let statusCode = response.response?.statusCode else {
            throw FetchError.failedRequest
        }
        
        guard let data = response.data else {
            throw FetchError.noData
        }
        
        if statusCode != 200 {
            var errorMessage: String?
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                errorMessage = json["message"] as? String
            }
            
            throw FetchError.failResponse(code: statusCode, message: errorMessage ?? "")
        }
        
        switch response.result {
        case .success(let value):
            return value
            
        case .failure:
            throw FetchError.invalidData
        }
    }
    
    // 공통 에러 처리 로직을 메서드로 분리
    private static func mapToFetchError(_ error: Error) -> FetchError {
        if let error = error as? FetchError {
            return error
        } else {
            return FetchError.unknownError
        }
    }
    
    static private func fetch<M: Decodable>(fetchRouter: Router, model: M.Type) async throws -> M {
        do {
            guard let request = try? fetchRouter.asURLRequest() else {
                throw FetchError.invalidRequest
            }
            
            print("🌸request - ", request.url)
            
            // AF.request를 async/await로 사용하기 위한 패턴
            //⭐️ withCheckedThrowingContinuation : Alamofire는 기본적으로 콜백 기반 API를 제공하기 때문에 비동기 작업의 결과를 async 함수의 반환값으로 전달할 수 있게 해주는 역할
            //⭐️ continuation.resume(returning:)을 통해 값을 반환하고, 실패 시 continuation.resume(throwing:)을 통해 에러를 던짐
            //⭐️ Combine에서 Future사용해서 비동기 결과 처리할 때의 promise(.success(value)) 또는 promise(.failure(error))와 개념적으로 동일
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(request, interceptor: APIRequestInterceptor())
                    .responseDecodable(of: model.self) { response in
                        do {
                            let result = try handleResponse(response: response)
                            continuation.resume(returning: result)
                        } catch {
                            continuation.resume(throwing: mapToFetchError(error))
                        }
                    }
            }
            

            /*
             //⭐️withCheckedThrowingContinuation을 사용하지 않고 Alamofire 5.5 이상 버전에서 제공하는 Swift Concurrency를 지원하는 훨씬 더 간결한 방법
             let dataTask = AF.request(request, interceptor: APIRequestInterceptor())
                 .validate()
                 .serializingDecodable(model.self)
             
             let response = await dataTask.response
             
             do{
                 let result = try handleResponse(response: response)
                 return result
             } catch {
                 throw mapToFetchError(error)
             }
             */

            
            
        } catch {
            throw mapToFetchError(error)
        }
    }
    
    static func uploadFile<M: Decodable>(fetchRouter: Router, fileDatas: [Data], name: String = "files", model: M.Type) async throws -> M {
        do {
            guard let request = try? fetchRouter.asURLRequest() else {
                throw FetchError.invalidRequest
            }
            
            guard let url = request.url else {
                throw FetchError.url
            }
            
            let header: HTTPHeaders? = request.headers
            print("❤️❤️❤️request❤️❤️", request)
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.upload(
                    multipartFormData: { multipartFormData in
                        for (index, data) in fileDatas.enumerated() {
                            multipartFormData.append(
                                data,
                                withName: name,
                                fileName: "image\(index).jpeg",
                                mimeType: "image/jpeg"
                            )
                        }
                    },
                    to: url,
                    headers: header,
                    interceptor: APIRequestInterceptor()
                )
                .responseDecodable(of: model.self) { response in
                    do {
                        let result = try handleResponse(response: response)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: mapToFetchError(error))
                    }
                }
            }
        } catch {
            throw mapToFetchError(error)
        }
    }

    static func fetchData(fetchRouter: Router) async throws -> Data {
        do {
            guard let request = try? fetchRouter.asURLRequest() else {
                throw FetchError.invalidRequest
            }
            
            return try await withCheckedThrowingContinuation { continuation in
                AF.request(request, interceptor: APIRequestInterceptor())
                    .responseData { response in
                        guard response.response != nil else {
                            continuation.resume(throwing: FetchError.invalidResponse)
                            return
                        }
                        
                        guard let statusCode = response.response?.statusCode else {
                            continuation.resume(throwing: FetchError.failedRequest)
                            return
                        }
                        
                        guard let data = response.data else {
                            continuation.resume(throwing: FetchError.noData)
                            return
                        }
                        
                        continuation.resume(returning: data)
                    }
            }
        } catch {
            throw mapToFetchError(error)
        }
    }
}


// 방법 2: value 속성을 사용한 더 간결한 방식
/*
    static func fetchSimple<M: Decodable>(fetchRouter: Router, model: M.Type) async throws -> M {
        do {
            guard let request = try? fetchRouter.asURLRequest() else {
                throw FetchError.invalidRequest
            }
            
            print("🌸request - ", request.url)
            
            // value 속성을 사용하면 자동으로 성공 케이스의 값만 반환
            return try await AF.request(request, interceptor: APIRequestInterceptor())
                .validate() // 상태 코드 검증 (기본은 200...299)
                .serializingDecodable(model.self, automaticallyCancelling: true)
                .value
                
        } catch {
            // 에러를 우리의 도메인 에러로 변환
            if let afError = error as? AFError,
               afError.responseCode != nil,
               let data = afError.responseData {
                
                let statusCode = afError.responseCode!
                
                // 에러 메시지 추출 로직
                var errorMessage: String?
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    errorMessage = json["message"] as? String
                }
                
                throw FetchError.failResponse(code: statusCode, message: errorMessage ?? "")
            }
            
            throw mapToFetchError(error)
        }
    }
*/


extension NetworkManager2 {
    static func getStores(limit: String, nextCursor: String) async throws -> PostContentResponseDTO {
        let router = Router.getStores(next: nextCursor, limit: limit, category: APIKEY.category_value)
        return try await fetch(fetchRouter: router, model: PostContentResponseDTO.self)
    }

    static func getLocationBasedStores(location: LocationCoordinate) async throws -> PostContentResponseDTO {
        let router = Router.getLocationBasedStores(category: APIKEY.category_value, coordinate: location, maxDistance: 1000, orderBy: .distance, sortBy: .asc)
        return try await fetch(fetchRouter: router, model: PostContentResponseDTO.self)
    }

    static func postStoreData(body: StoreInfoPostBody) async throws -> PostContentDTO {
        let router = Router.postStoreData(body: body)
        return try await fetch(fetchRouter: router, model: PostContentDTO.self)
    }
    
    //Chat
    static func createChatRoom(body : CreateChatRoomBody) async throws -> ChatRoomResponseDTO {
        let router = Router.createChatRoom(body: body)
        return try await fetch(fetchRouter: router, model: ChatRoomResponseDTO.self)
    }
    
    static func getChatRoomList() async throws -> ChatRoomListResponseDTO {
        let router = Router.getChatRoomList
        return try await fetch(fetchRouter: router, model: ChatRoomListResponseDTO.self)
    }
    
    static func getChatRoomContents(roomId : String, cursorDate : String) async throws -> ChatRoomContentListResponseDTO {
        let router = Router.getChatContents(roomId: roomId, cursorDate: cursorDate)
        return try await fetch(fetchRouter: router, model: ChatRoomContentListResponseDTO.self)
    }
    
    static func postChat(roomId : String, body : PostChatBody) async throws -> ChatRoomContentDTO {
        let router = Router.postChat(roomId: roomId, body: body)
        return try await fetch(fetchRouter: router, model: ChatRoomContentDTO.self)
    }
    
    //Files
    static func uploadFiles(fileDatas : [Data]) async throws -> FileResponse {
        let router = Router.uploadFiles
        return try await uploadFile(fetchRouter: router, fileDatas: fileDatas, model : FileResponse.self)
    }
    
    static func downloadFiles(url : String) async throws -> Data {
        let router = Router.downloadFile(url: url)
        return try await fetchData(fetchRouter: router)
    }
    
    
    //Auth
    static func tokenRefresh() async throws -> TokenRefreshResponse {
        let router = Router.tokenRefresh
        return try await fetch(fetchRouter: router, model : TokenRefreshResponse.self)
    }
    
    static func login(body : LoginBody) async throws -> LoginResponseDTO {
        let router = Router.login(body: body)
        return try await fetch(fetchRouter: router, model : LoginResponseDTO.self)
    }
    
    //User
    static func updateProfile(body : UpdateProfileRequestBody) async throws -> UpdateProfileResponseDTO {
        let router = Router.updateProfile(body: body)
        return try await fetch(fetchRouter: router, model : UpdateProfileResponseDTO.self)
    }

}



/*
 //아래처럼 Task를 반환하는 래퍼 메서드들로 처리할 수 있지만 어차피 호출할 때 do catch 내에서 처리??
 
 
 // 필요한 경우 Task를 반환하는 래퍼 메서드들 (비동기 컨텍스트 외부에서 호출할 때 유용)
 static func getStoresTask(limit: String, nextCursor: String) -> Task<PostContentResponseDTO, Error> {
     return Task {
         try await getStores(limit: limit, nextCursor: nextCursor)
     }
 }

 static func getLocationBasedStoresTask(location: LocationCoordinate) -> Task<PostContentResponseDTO, Error> {
     return Task {
         try await getLocationBasedStores(location: location)
     }
 }

 static func postStoreDataTask(body: StoreInfoPostBody) -> Task<PostContentDTO, Error> {
     return Task {
         try await postStoreData(body: body)
     }
 }
 
 // Task를 반환하는 메서드 사용
 let task = NetworkManager2.getStoresTask(limit: "10", nextCursor: "")
 
 // 결과 처리 및 에러 핸들링
 Task {
     do {
         // task.value는 async throws이므로 try await로 접근
         let result = try await task.value
         // 성공적으로 결과를 받았을 때 처리
         print("받은 데이터: \(result)")
     } catch {
 
     }

 }
 // 나중에 필요하면 취소 가능
 // task.cancel()
 */
