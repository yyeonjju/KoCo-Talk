//
//  StoreInfoRegisterRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

protocol StoreInfoRegisterRepository {
    func post(postBody : StoreInfoPostBody) async throws -> String
    func uploadFiles(imageData : Data) async throws -> String 
}
