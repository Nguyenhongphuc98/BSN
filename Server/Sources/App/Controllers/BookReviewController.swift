//
//  BookReviewController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
import Fluent
import SQLKit

struct BookReviewController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let bookReviews = routes.grouped("api" ,"v1", "bookReviews")
        bookReviews.get(use: index)
        bookReviews.post(use: create)
        bookReviews.group(":ID") { group in
            group.delete(use: delete)
        }
        
        bookReviews.get("search", use: search)
    }

    func index(req: Request) throws -> EventLoopFuture<[BookReview]> {
        return BookReview.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<BookReview> {
        let br = try req.content.decode(BookReview.self)
        return br.save(on: req.db).map { br }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return BookReview.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func search(req: Request) throws -> EventLoopFuture<[GetBookReview]> {
        
        guard let bid: String = req.query["bid"] else {
            throw Abort(.badRequest)
        }
        
        let sqlQuery = SQLQueryString("select br.id, br.user_id as \"userID\", br.book_id as \"bookID\", br.title, br.description, br.character_rating as \"characterRating\", br.info_rating as \"infoRating\", br.target_rating as \"targetRating\", br.write_rating as \"writeRating\", br.created_at as \"createdAt\", u.avatar from book_review as br, public.user as u where br.book_id = '\(raw: bid)' and br.user_id = u.id")
        
        let db = req.db as! SQLDatabase
        return db.raw(sqlQuery)
            .all(decoding: GetBookReview.self)
    }
}
