//
//  NoteController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor

struct NoteController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let notes = routes.grouped("api", "v1", "notes")
        notes.get(use: index)
        notes.post(use: create)
        notes.group(":noteID") { user in
            user.delete(use: delete)
        }
    }

    func index(req: Request) throws -> EventLoopFuture<[Note]> {
        return Note.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Note> {
        let note = try req.content.decode(Note.self)
        return note.save(on: req.db).map { note }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Note.find(req.parameters.get("noteID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
