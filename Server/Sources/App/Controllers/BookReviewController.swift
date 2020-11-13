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

    // when create or delete a review
    // we should update rating info for book
    func create(req: Request) throws -> EventLoopFuture<BookReview> {
        let br = try req.content.decode(BookReview.self)
        
        return Book
            .find(br.bookID, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { (book) -> EventLoopFuture<BookReview> in
                
                let n: Float = Float(book.numReview!)
                
                book.characterRating = (book.characterRating! * n + Float(br.characterRating)) / (n + 1)
                book.writeRating = (book.writeRating! * n + Float(br.writeRating)) / (n + 1)
                book.infoRating = (book.infoRating! * n + Float(br.infoRating)) / (n + 1)
                book.targetRating = (book.targetRating! * n + Float(br.targetRating)) / (n + 1)
                book.numReview! += 1
                
                book.avgRating = (book.characterRating! + book.targetRating! + book.infoRating! + book.writeRating!) / 4.0
                
                _ = book.update(on: req.db)
                
                return br.save(on: req.db).map { br }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        
        return BookReview.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { br in
                Book
                    .find(br.bookID, on: req.db)
                    .unwrap(or: Abort(.notFound))
                    .flatMap { (book) -> EventLoopFuture<BookReview> in
                        
                        let n: Float = Float(book.numReview!)
                        
                        if n == 1 {
                            // We can't div for n-1 (0)
                            book.characterRating = 0.0
                            book.writeRating = 0.0
                            book.infoRating = 0.0
                            book.targetRating = 0.0
                            book.avgRating = 0.0
                        } else {
                            book.characterRating = (book.characterRating! * n - Float(br.characterRating)) / Float(n - 1)
                            book.writeRating = (book.writeRating! * n - Float(br.writeRating)) / Float(n - 1)
                            book.infoRating = (book.infoRating! * n - Float(br.infoRating)) / Float(n - 1)
                            book.targetRating = (book.targetRating! * n - Float(br.targetRating)) / Float(n - 1)
                            book.avgRating = (book.characterRating! + book.targetRating! + book.infoRating! + book.writeRating!) / 4.0
                        }
                        
                        book.numReview! -= 1
        
                        _ = book.update(on: req.db)
                        
                        return br.delete(on: req.db).map { br }
                    }
            }
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
