//
//  ChatWebSocket.swift
//  
//
//  Created by Phucnh on 11/30/20.
//

import Vapor
import Fluent
import SQLKit

struct ChatWebSocket: RouteCollection {
    
    let sessionManager: SessionManager = .shared
    
    func boot(routes: RoutesBuilder) throws {
        routes.webSocket("chats", "listen", ":chatID", onUpgrade: self.webSocket)
    }

    func webSocket(req: Request, socket: WebSocket) {
        guard let chatID: String = req.parameters.get("chatID") else {
            return
        }
        self.sessionManager.connect(to: chatID, listener: socket)
    }
}
