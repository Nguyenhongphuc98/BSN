//
//  BookReviewController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor

struct BookReviewController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let bookReviews = routes.grouped("api" ,"v1", "bookReviews")
        bookReviews.get(use: index)
        bookReviews.post(use: create)
        bookReviews.group(":ID") { user in
            user.delete(use: delete)
        }
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
}
