//
//  ChatWebSocket.swift
//  
//
//  Created by Phucnh on 11/30/20.
//

import Vapor

struct WebSocketConnect: RouteCollection {
    
    let sessionManager: SessionManager = .shared
    
    func boot(routes: RoutesBuilder) throws {
        routes.webSocket("inchat", "listen", ":chatID", onUpgrade: self.listenInchat)
        routes.webSocket("chats", "listen", ":receiverID", onUpgrade: self.listenChats)
        routes.webSocket("commentsOfPost", "listen", ":postID", onUpgrade: self.listenCommentsOnPost)
        routes.webSocket("notifiesOfPost", "listen", ":receiverID", onUpgrade: self.listenNotifiesOfPost)
    }

    // MARK: - Chats
    func listenInchat(req: Request, socket: WebSocket) {
        guard let chatID: String = req.parameters.get("chatID") else {
            return
        }
        self.sessionManager.connect(to: chatID, listener: socket)
    }
    
    func listenChats(req: Request, socket: WebSocket) {
        guard let receiverID: String = req.parameters.get("receiverID") else {
            return
        }
        let key = "chats" + receiverID
        self.sessionManager.connect(to: key, listener: socket)
    }
    
    // MARK: - Posts
    func listenCommentsOnPost(req: Request, socket: WebSocket) {
        guard let postID: String = req.parameters.get("postID") else {
            return
        }
        self.sessionManager.connect(to: "commentsOfPost" + postID, listener: socket)
    }
    
    func listenNotifiesOfPost(req: Request, socket: WebSocket) {
        guard let receiverID: String = req.parameters.get("receiverID") else {
            return
        }
        self.sessionManager.connect(to: "notifiesOfPost" + receiverID, listener: socket)
    }
}
