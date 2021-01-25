//
//  CreateExchangeBook.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Fluent

struct CreateExchangeBook: Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        let exchangeBook = ExchangeBook()
        
        return database.schema(ExchangeBook.schema)
            .id()
            .field(exchangeBook.$firstUserBookID.key, .uuid, .references(UserBook.schema, "id"))
            .field(exchangeBook.$secondUserBookID.key, .uuid, .references(UserBook.schema, "id"))
            .field(exchangeBook.$exchangeBookID.key, .uuid)
            .field(exchangeBook.$adress.key, .string)
            .field(exchangeBook.$message.key, .string)
            .field(exchangeBook.$state.key, .string)
            .field(exchangeBook.$firstStatusDes.key, .string)
            .field(exchangeBook.$secondStatusDes.key, .string)
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(ExchangeBook.schema).delete()
    }
}

//struct AddFieldExchangeBook: Migration {
//    
//    func prepare(on database: Database) -> EventLoopFuture<Void> {
//        let exchangeBook = ExchangeBook()
//        
//        return database.schema(ExchangeBook.schema)
//            .field(exchangeBook.$responseMessage.key, .string)
//            .update()
//    }
//    
//    func revert(on database: Database) -> EventLoopFuture<Void> {
//        return database.schema(ExchangeBook.schema).delete()
//    }
//}
