//
//  Account.swift
//
//
//  Created by Phucnh on 10/15/20.
//

import Fluent
import FluentPostgresDriver
import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

//    app.databases.use(.postgres(
//        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//        username: Environment.get("DATABASE_USERNAME") ?? "vapor",
//        password: Environment.get("DATABASE_PASSWORD") ?? "password",
//        database: Environment.get("DATABASE_NAME") ?? "vapor"
//    ), as: .psql)
//
    if let databaseURL = Environment.get("DATABASE_URL") {
        app.databases.use(try .postgres(
            url: databaseURL
        ), as: .psql)
    } else {
        // ...
    }
    
    app.http.server.configuration.hostname = "0.0.0.0"

    // User - account info
    app.migrations.add(CreateAccount())
    app.migrations.add(CreateUser())
    
    // Notify info
    app.migrations.add(CreateNotifyType())
    app.migrations.add(CreateNotify())
    
    // Setting
    app.migrations.add(CreateSetting())
    
    // Chat - Message
    app.migrations.add(CreateMessageType())
    app.migrations.add(CreateChat())
    app.migrations.add(CreateMessage())
    
    // Following
    app.migrations.add(CreateUserFollow())
    
    // Post
    app.migrations.add(CreateCategory())
    app.migrations.add(CreatePost())
    app.migrations.add(CreateComment())
    app.migrations.add(CreateReaction())
    
    // User register Category
    app.migrations.add(CreateUserCategory())
    
    // Book
    app.migrations.add(CreateBook())
    app.migrations.add(CreateUserBook())
    app.migrations.add(CreateBookReview())
    app.migrations.add(CreateNote())
    app.migrations.add(CreateBorrowBook())
    app.migrations.add(CreateExchangeBook())
    
    // Edit table
    app.migrations.add(AddNumReviewBook())
    
    app.migrations.add(CreateDevice())
    
    //try app.autoMigrate().wait()
    
    // using template for web
    app.views.use(.leaf)

    // register routes
    try routes(app)
    try app.configurePush()
    
}
