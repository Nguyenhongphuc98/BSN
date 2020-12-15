//
//  Account.swift
//
//
//  Created by Phucnh on 10/15/20.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    // User - account
    try app.register(collection: AccountController())
    try app.register(collection: UserController())
    
    // Notify
    try app.register(collection: NotifyTypeController())
    try app.register(collection: NotifyController())
    
    // Setting
    try app.register(collection: SettingController())
    
    // Chat - Message
    try app.register(collection: MessageTypeController())
    try app.register(collection: ChatController())
    try app.register(collection: MessageController())
    
    // Following
    try app.register(collection: UserFollowController())
    
    // Post
    try app.register(collection: CategoryController())
    try app.register(collection: PostController())
    try app.register(collection: CommentController())
    try app.register(collection: ReactionController())
    
    // User register Category
    try app.register(collection: UserCategoryController())
    
    // Book
    try app.register(collection: BookController())
    try app.register(collection: UserBookController())
    try app.register(collection: BookReviewController())
    try app.register(collection: NoteController())
    try app.register(collection: BorrowBookController())
    try app.register(collection: ExchangeBookController())
    
    //WebSocket
    try app.register(collection: WebSocketConnect())
    
    // Push notifications
    try app.register(collection: DeviceController())
    
    // Social
    try app.register(collection: FacebookController())
}
