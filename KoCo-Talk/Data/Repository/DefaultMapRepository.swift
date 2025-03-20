//
//  DefaultMapRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

final class DefaultMapRepository : MapRepository {
    private let networkManager = NetworkManager2.shared
    
    func fetchLocationBasedStores(location : LocationCoordinate) async throws -> [PostContentData] {
        let result = try await networkManager.getLocationBasedStores(location: location)
        return result.data.map{$0.toDomain()}
    }
    
    func createChatRoom(opponentId : String) async throws -> String {
        let body = CreateChatRoomBody(opponent_id: opponentId)
        
        let result = try await networkManager.createChatRoom(body: body)
        return result.roomId
    }
}
