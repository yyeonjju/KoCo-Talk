//
//  APIRequestInterceptor.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation
import Alamofire

//토큰 리프레시 로직
final class APIRequestInterceptor: RequestInterceptor {
//    var cancellables = Set<AnyCancellable>()
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        //TODO: 로그인 url 아닐 때만 setValu하기
        
        //🌸🌸🌸🌸🌸🌸
        // 토큰 리프레시 요청을 할 때 엑세스 토큰 넣으면 401에러 나고
        // 토큰 리프레시 요청을 할 때 엑세스 토큰 안넣으면 403에러남..;;
        
//        if urlRequest.url?.path() != APIURL.version + APIURL.tokenRefresh {
//            print("🌸🌸🌸토큰 리프레시가 아닐 때만 엑세스 토큰 넣어줌🌸🌸🌸")
        urlRequest.setValue((KeyChainValue.accessToken ?? ""), forHTTPHeaderField: APIKEY.accessToken_key)
//        }
        
        print("- adapt - headers -> ", urlRequest.headers)
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
            
//            NetworkManager.tokenRefresh()
//                .sink(receiveCompletion: {[weak self] receiveCompletion in
//                    guard let self else { return }
//                    switch receiveCompletion {
//                    case .failure(let error):
//                        print("⭐️⭐️receiveCompletion - failure", error)
//
//                        //엑세스 토큰 갱신 요청에서의 실패 result (418 리프레시 만료 시 에러날 수 있다)
//                        completion(.doNotRetryWithError(error))
//
//                    case .finished:
//                        break
//                    }
//
//                }, receiveValue: {[weak self]  result in
//                    guard let self else { return }
//
//                    KeyChainValue.accessToken = result.accessToken
//                    completion(.retry)
//                })
//                .store(in: &cancellables)
            
            Task {
                do {
                    let result = try await NetworkManager2.tokenRefresh()
                    print("✅Thread.isMainThread", Thread.isMainThread)
                    KeyChainValue.accessToken = result.accessToken
                    completion(.retry)
                   
                } catch {
                    // 에러 처리
                    print("🚨error", error)
                    //엑세스 토큰 갱신 요청에서의 실패 result (418 리프레시 만료 시 에러날 수 있다)
                    completion(.doNotRetryWithError(error))
                }
            }

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
