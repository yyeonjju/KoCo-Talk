//
//  DefaultStoreInfoRegisterRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

final class DefaultStoreInfoRegisterRepository : StoreInfoRegisterRepository {
    @Injected private var networkManager : NetworkManagerType
    
    func post(postBody : StoreInfoPostBody) async throws -> String {
        let result = try await networkManager.postStoreData(body : postBody)
        return result.postId
    }
    
    func uploadFiles(imageData : Data) async throws -> String {
        let result = try await networkManager.uploadFiles(fileDatas: [imageData])
        return result.files.first ?? "-"
    }
}
