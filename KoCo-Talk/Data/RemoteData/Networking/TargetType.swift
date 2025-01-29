//
//  TargetType.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/29/25.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    
    var header: [String: String] { get }
//    var parameters: String? { get }
    var queryItems: [URLQueryItem] { get }
    var body: Data? { get }
}


extension TargetType {
    
    func asURLRequest() throws -> URLRequest {
        var request : URLRequest
        
        ///queryItems 를 붙이는 append 메서드가 16이상만 가능
        let url = try baseURL.asURL()
        request = try URLRequest(
            url: url.appendingPathComponent(path),
            method: method
        )
        request.url?.append(queryItems: queryItems)
        request.allHTTPHeaderFields = header
        request.httpBody = body
        
        return request
    }
    
}
