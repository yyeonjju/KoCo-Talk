//
//  MapRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

protocol MapRepository {
    func fetchLocationBasedStores(location : LocationCoordinate) async throws -> [PostContentData]
    func createChatRoom(opponentId : String) async throws -> String
}


