//
//  SessionManager.swift
//  
//
//  Created by Phucnh on 11/30/20.
//

import Vapor
import Fluent

enum WebSocketSendOption {
  case id(String), socket(WebSocket)
}

class SessionManager {
    
    private(set) var sessions: [String : [WebSocket]] // target ID, observer
    private let logger: Logger
    private let lock: Lock
    
    public static var shared: SessionManager = .init()
    
    private init() {
        self.lock = Lock()
        self.sessions = [:]
        self.logger = Logger(label: "SessionManager")
    }
    
    func connect(to targetID: String, listener: WebSocket) {
        
        var listeners = sessions[targetID]
        if  listeners == nil {
            listeners = [listener]
        } else {
            listeners?.append(listener)
        }
        
        sessions[targetID] = listeners
        
        _ = listener.onClose.always { [weak self, weak listener] _ in
            guard let listener = listener else { return }
            self?.remove(listener: listener, from: targetID)
        }
    }
    
    func remove(listener: WebSocket, from session: String) {
        
        guard var listeners = sessions[session] else {
            return
        }
        listeners = listeners.filter { $0 !== listener }
        sessions[session] = listeners
    }
    
    func send<T: Codable>(message: T, to sendOption: WebSocketSendOption) {
        logger.info("Sending \(T.self) to \(sendOption)")
        
        do {
           
            let sockets: [WebSocket] = self.lock.withLock {
                switch sendOption {
                case .id(let id):
                    print("send id: \(id)")
                    return self.sessions[id]?.compactMap { $0 } ?? []
                case .socket(let socket):
                    return [socket]
                }
            }
                        
            let encoder = JSONEncoder()
            let data = try encoder.encode(message)            
            
            sockets.forEach {
                $0.send(raw: data, opcode: .text)               
            }
        } catch {
            logger.report(error: error)
        }
    }
}
