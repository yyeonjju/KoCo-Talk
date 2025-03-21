//
//  MockDataLoadManager.swift
//  KoCo-Talk
//
//  Created by 하연주 on 3/21/25.
//

import Foundation
import UIKit

final class MockDataLoadManager : NetworkManagerType {
    static let shared = MockDataLoadManager()
    private init() {}
    
    private func fetchContents<T: Decodable>(_ filename: String) -> T {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    private func fetchJsonFile<T : Decodable>(filename : String, model : T.Type) async throws -> T {
        // 지연 시간 설정 (0-500 밀리초)
        try? await Task.sleep(nanoseconds: UInt64.random(in: 0..<500_000_000))
        
        let result : T = fetchContents(filename)
        return result
     }
    
    private func decodeJson<T : Decodable>(jsonString : String, model : T.Type) async throws -> T {
        // 지연 시간 설정 (0-500 밀리초)
        try? await Task.sleep(nanoseconds: UInt64.random(in: 0..<500_000_000))
        
        let data = Data(jsonString.utf8)
         
         do {
             let decoder = JSONDecoder()
             return try decoder.decode(T.self, from: data)
         } catch {
             fatalError("JSON 문자열을 \(T.self)로 파싱할 수 없습니다:\n\(error)")
         }
    }
    
    
}

extension MockDataLoadManager {
    
    func getLocationBasedStores(location: LocationCoordinate) async throws -> PostContentResponseDTO {
        return try await fetchJsonFile(filename: "StorePostsMockData.json", model: PostContentResponseDTO.self)
    }
    
    func getStores(limit: String, nextCursor: String) async throws -> PostContentResponseDTO {
        return try await fetchJsonFile(filename: "StorePostsMockData.json", model: PostContentResponseDTO.self)
    }
    
    func postStoreData(body: StoreInfoPostBody) async throws -> PostContentDTO {
        let router = Router.postStoreData(body: body)
        return PostContentDTO(postId: "postId", category: "category", title: "title", price: 100000, content: "post content", content1: "content1", content2: "content2", content3: "content3", content4: "content4", content5: "content5", createdAt: "createdAt", creator: PostContentCreatorDTO(userId: "userId", nick: "nick", profileImage: "profileImage"), files: [], likes: [], likes2: [], buyers: [], hashTags: [], geolocation: PostContentGeoLocationDTO(longitude: 11.111, latitude: 11.111), distance: 11.111)
    }
    
    //Chat
    func createChatRoom(body : CreateChatRoomBody) async throws -> ChatRoomResponseDTO {
        let jsonString = """
        {
            "room_id": "6795fbb990722a3b01536472",
            "createdAt": "2025-01-26T09:09:13.861Z",
            "updatedAt": "2025-01-26T09:09:13.861Z",
            "participants": [
                {
                    "user_id": "67861e9bcfd84904bc188709",
                    "nick": "kocoTalk-user1"
                },
                {
                    "user_id": "6795fb3790722a3b0153645c",
                    "nick": "kocoTalk2"
                }
            ]
        }
        """
        return try await decodeJson(jsonString: jsonString, model: ChatRoomResponseDTO.self)
    }
    
    func getChatRoomList() async throws -> ChatRoomListResponseDTO {
        return try await fetchJsonFile(filename: "ChatListMockData.json", model: ChatRoomListResponseDTO.self)
    }
    
    func getChatRoomContents(roomId : String, cursorDate : String) async throws -> ChatRoomContentListResponseDTO {
        return try await fetchJsonFile(filename: "UnreadMessagesMockData.json",model: ChatRoomContentListResponseDTO.self)
    }
    
    func postChat(roomId : String, body : PostChatBody) async throws -> ChatRoomContentDTO {
        let jsonString = """
        {
            "chat_id": "67d7c46a6d8a1073757cb5ac",
            "room_id": "67d6c8236d8a1073757ca70d",
            "content": "금요일에 재입고 예정으로, 매장에서 구매하실 수 있습니다!",
            "createdAt": "2025-03-17T06:42:50.134Z",
            "sender": {
                "user_id": "67d57b5f6d8a1073757c9e48",
                "nick": "탬버린즈_플래그십스토어(신사점)"
            },
            "files": []
        }
        """
        return try await decodeJson(jsonString: jsonString, model: ChatRoomContentDTO.self)
    }
    
    //Files
    func uploadFiles(fileDatas : [Data]) async throws -> FileResponse {
        return FileResponse(files: ["mock mock mock.png"])
    }
    
    func downloadFiles(url : String) async throws -> Data {
        return UIImage(systemName: "plus")?.jpegData(compressionQuality: 1) ?? Data()
    }
    
    
    //Auth
    func tokenRefresh() async throws -> TokenRefreshResponse {
        return TokenRefreshResponse(accessToken: "accessToken")
    }
    
    func login(body : LoginBody) async throws -> LoginResponseDTO {
        return try await fetchJsonFile(filename: "LoginResponseMockData.json", model : LoginResponseDTO.self)
    }
    
    //User
    func updateProfile(body : UpdateProfileRequestBody) async throws -> UpdateProfileResponseDTO {
        return UpdateProfileResponseDTO(user_id: "user_id", email: "email", nick: "nick", profileImage: "profileImage")
    }
}
