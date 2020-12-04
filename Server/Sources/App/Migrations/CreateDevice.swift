//
//  CreateDevice.swift
//  
//
//  Created by Phucnh on 12/4/20.
//
import Fluent

struct CreateDevice: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let device = Device()
        return database.schema(Device.schema)
            .id()
            .field(device.$pushToken.key, .string)
            .field(device.$osVersion.key, .string, .required)
            .field(device.$system.key, .string, .required)
            .field(device.$userID.key, .uuid, .references(User.schema, "id"))
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(Device.schema).delete()
    }
}
