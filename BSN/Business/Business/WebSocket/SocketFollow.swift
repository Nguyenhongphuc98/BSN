//
//  SocketFollow.swift
//  Business
//
//  Created by Phucnh on 11/30/20.
//

import Foundation

let hostIp = "192.168.1.8:8080"
//let hostIp = "10.45.231.255:8080"
let wsInChatApi = "ws://\(hostIp)/inchat/listen/" // + ChatID
let wsChatsApi = "ws://\(hostIp)/chats/listen/"   // + ReceiverID
let wsCommentsOfPostApi = "ws://\(hostIp)/commentsOfPost/listen/"   // + PostID
let wsNotifiesApi = "ws://\(hostIp)/notifies/listen/" // + ReceiverID

class SocketFollow<ResourceType> where ResourceType: Codable {
    
    private let session: URLSession
    var socket: URLSessionWebSocketTask!
    private let decoder = JSONDecoder()

    var didReceiveData: ((ResourceType) -> Void)?

    init() {
        self.session = URLSession(configuration: .default)
    }

    func connect(url: String) {
        self.socket = session.webSocketTask(with: URL(string: url)!)
        self.listen()
        self.socket.resume()
    }
    
    func listen() {
        self.socket.receive { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                print(error)
                return
            case .success(let message):
                switch message {
                case .data(let data):
                    self.handle(data)
                case .string(let str):
                    guard let data = str.data(using: .utf8) else { return }
                    self.handle(data)
                @unknown default:
                    break
                }
            }
            // URLSessionWebSocketTask.receive registers a one-time callback. So after the callback executes, re-register the callback to keep listening for new messages
            self.listen()
        }
    }
    
    func handle(_ data: Data) {
        do {
          let sinData = try decoder.decode(ResourceType.self, from: data)
          didReceiveData?(sinData)
        } catch {
          print(error)
        }
    }
}
