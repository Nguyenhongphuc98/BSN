//
//  Account.swift
//
//
//  Created by Phucnh on 10/15/20.
//

import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        username: Environment.get("DATABASE_USERNAME") ?? "vapor",
        password: Environment.get("DATABASE_PASSWORD") ?? "password",
        database: Environment.get("DATABASE_NAME") ?? "vapor"
    ), as: .psql)

    app.migrations.add(CreateAccount())
    app.migrations.add(CreateUser())
    
    app.migrations.add(CreateNotifyType())
    app.migrations.add(CreateNotify())
    
    app.migrations.add(CreateSetting())
    
    app.migrations.add(CreateMessageType())
    app.migrations.add(CreateChat())
    app.migrations.add(CreateMessage())
    
    app.migrations.add(CreateUserFollow())
    
    app.migrations.add(CreateCategory())
    app.migrations.add(CreatePost())
    app.migrations.add(CreateComment())
    app.migrations.add(CreateReaction())
    
    app.migrations.add(CreateUserCategory())

    // register routes
    try routes(app)
}
