//
//  BookController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
import Fluent

struct BookController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let books = routes.grouped("api" ,"v1", "books")
        
        books.get(use: index)
        books.post(use: create)
        books.group(":bookID") { book in
            book.delete(use: delete)
            book.get(use: getBook)
        }
        
        // Advance
        books.get("search", use: searchAuthorandTitle)
        books.get("isbn", use: searchIsbn)
        
        // Get detail book for view in client (not full info book store in DB)
        books.get("detail",":bookID", use: getBookDetail)
    }
    
    // Base function
    func index(req: Request) throws -> EventLoopFuture<[Book]> {
        return Book.query(on: req.db).all()
    }
    
    func create(req: Request) throws -> EventLoopFuture<Book> {
        let book = try req.content.decode(Book.self)
        return book.save(on: req.db).map { book }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func getBook(req: Request) throws -> EventLoopFuture<Book> {
        return Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .map { $0 }
    }
    
    // Advance function
    func searchAuthorandTitle(req: Request) throws -> EventLoopFuture<[SearchBook]> {
        guard let term: String = req.query["term"] else {
            throw Abort(.badRequest)
        }
        
        
        // Get first 5 book match term
        return Book.query(on: req.db)
            .group(.or) { (group) in
                group.filter(\.$title ~~ term).filter(\.$author ~~ term)
            }
            .range(0..<BusinessConfig.searchBookLimit)
            .all()
            .mapEach { book in
                book.toSearchBook()
            }
    }
    
    func searchIsbn(req: Request) throws -> EventLoopFuture<SearchBook> {
        guard let term: String = req.query["term"] else {
            throw Abort(.badRequest)
        }
        
        return Book.query(on: req.db)
            .filter(\.$isbn ~~ term)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { book in
                book.toSearchBook()
            }
    }
    
    // Add num read and num available
    func getBookDetail(req: Request) throws -> EventLoopFuture<BookDetail> {
        return Book.find(req.parameters.get("bookID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { book in
                
                let reading = UserBook
                    .query(on: req.db)
                    .filter(UserBook.self, \.$state == "reading")
                    .filter(UserBook.self, \.$bookID == book.id!)
                    .count()
                
                
                let available = UserBook
                    .query(on: req.db)
                    .filter(UserBook.self, \.$state == "available")
                    .filter(UserBook.self, \.$bookID == book.id!)
                    .count()
                
                return reading.and(available).map { (r, a) -> (BookDetail) in
                    book.toBookDetail(numRead: r, numAvailable: a)
                }
            }
    }
}
