//
//  ChatRoomRepository.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/20/25.
//

import Foundation

@MainActor
protocol ChatRoomRepository {
    func getPrevRealmChats(roomId : String) -> [ChatRoomContentDTO]
    func getUnreadChats(roomId : String, cursorDate : String) async throws -> [ChatRoomContentDTO]
    func submitMessage(roomId : String, text : String, files : [String]) async throws -> String
    func submitFiles(roomId : String, fileDatas : [Data]) async throws -> String 
}


