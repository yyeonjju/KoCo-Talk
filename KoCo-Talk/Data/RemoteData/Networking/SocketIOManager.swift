//
//  SocketIOManager.swift
//  KoCo-Talk
//
//  Created by 하연주 on 1/31/25.
//

import Foundation
import SocketIO
import Combine


enum SocketRouter {
    case dm(roomId: String)
    
    //매니저에서 소켓 생성할 때 Namespace
    var route: String {
        switch self {
        case .dm(let roomId):
            return "/chats-\(roomId)"
        }
    }
}

// 채팅 수신할 때
enum ChatEventName : String {
    case chat
}


//enum SocketIOError : Error {
//    case receiveFail
//}


//TODO: background, active 시점 고려해서 소켓 연결/해제 처리

final class SocketIOManager {
    static let shared = SocketIOManager()
    
    private let baseUrl = URL(string: APIURL.baseUrl)!
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    
    
    private init() {
        
        //config -> 클라이언트 옵션
        self.manager = SocketManager(socketURL: baseUrl, config: [.compress])
        self.socket = self.manager.defaultSocket
        //        self.socket = manager.socket(forNamespace: SocketRouter.dm(roomId: "6795b0ad90722a3b015362a6").route)
        //        self.addListener()
    }
    
    private func addHandlers() {
        socket.on(clientEvent: .connect) { data, ack in
            print("🍀 SOCKET IS CONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("🍀 SOCKET IS DISCONNECTED", data, ack)
//            print("🍀🍀", self.manager.nsps)
        }
        
        socket.on(clientEvent: .reconnect) { data, ack in
            print("🍀 SOCKET IS RECONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .error) { data, ack in
            print("🍀 SOCKET ERROR", data, ack)
        }
        
        socket.on(clientEvent: .statusChange) { data, ack in
            print("🍀 SOCKET STATUS CHANGED", data, ack)
        }
        
        socket.on(clientEvent: .ping) { data, ack in
            print("🍀 SOCKET PING", data, ack)
        }
        
        socket.on(clientEvent: .pong) { data, ack in
            print("🍀 SOCKET PONG", data, ack)
        }
    }
    
    func receive<M : Decodable>(chatType:ChatEventName, model : M.Type) -> AnyPublisher<M, Never> {
        let socketType = chatType.rawValue
        let message = PassthroughSubject<M,Never>()
        
        //"chat" 이벤트 이름에서 오는 데이터 받기
        self.socket.on(socketType) { dataArray, ack in
            print("SOCKET RECEIVED", dataArray, ack)
            do {
                let data = dataArray[0] as! NSDictionary
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                
                let decodedData = try JSONDecoder().decode(
                    M.self, from: jsonData
                )
                message.send(decodedData)
                
            } catch {
                print("RESPONSE DECODE FAILED")
            }
        }
        
        return message.eraseToAnyPublisher()
    }
    
    func establishConnection(router: SocketRouter) {
        print("🌞forNamespace🌞", router.route)
        
        //기존 소켓 연결 초기화
        closeConnection() //원래 있던 소켓 연결 해제
        socket.removeAllHandlers()
        
        //소켓 다시 설정 & 연결
        socket = manager.socket(forNamespace: router.route)
        addHandlers()
        openConnection()
    }
    
    
    
    func openConnection() {
        print("🌹connect")
        socket.connect()
    }
    
    func closeConnection() {
        print("🌹disconnect")
        socket.disconnect()
    }
    
    deinit{
        print("SocketIOManager deinit")
        closeConnection()
    }
}

