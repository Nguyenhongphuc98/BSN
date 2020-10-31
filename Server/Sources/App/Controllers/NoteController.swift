//
//  NoteController.swift
//  
//
//  Created by Phucnh on 10/19/20.
//

import Vapor
import Fluent

struct NoteController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let notes = routes.grouped("api", "v1", "notes")
        notes.get(use: index)
        notes.post(use: create)
        notes.group(":noteID") { group in
            group.delete(use: delete)
            group.put(use: update)
        }
        
        notes.get("search", use: search)
    }

    func index(req: Request) throws -> EventLoopFuture<[Note]> {
        return Note.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Note> {
        let note = try req.content.decode(Note.self)
        return note.save(on: req.db).map { note }
    }
    
    func update(req: Request) throws -> EventLoopFuture<Note> {
        Note
            .find(req.parameters.get("noteID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { note in
                let newNote = try! req.content.decode(UpdateNote.self)
                note.content = newNote.content
                return note.update(on: req.db).map { note }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Note.find(req.parameters.get("noteID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func search(req: Request) throws -> EventLoopFuture<[Note]> {
        guard let ubid: String = req.query["ubid"], let id =  UUID(uuidString: ubid) else {
            throw Abort(.badRequest)
        }
        
        return Note.query(on: req.db)
            .filter(\.$userBookID == id)
            .all()
    }
}
