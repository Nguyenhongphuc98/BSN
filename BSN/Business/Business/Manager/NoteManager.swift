//
//  NoteManager.swift
//  Business
//
//  Created by Phucnh on 10/31/20.
//

import Combine

public class NoteManager {
    
    private let networkRequest: NoteRequest
    
    // Publisher for save new note and update note action
    public let changePublisher: PassthroughSubject<ENote, Never>
    
    // Publisher for fetch notes by ubid
    public let getNotesPublisher: PassthroughSubject<[ENote], Never>
    
    public init() {
        // Init resource URL
        networkRequest = NoteRequest(componentPath: "notes/")
        
        changePublisher = PassthroughSubject<ENote, Never>()
        getNotesPublisher = PassthroughSubject<[ENote], Never>()
    }
    
    public func getNotes(ubid: String) {
        networkRequest.fetchNotes(ubid: ubid, publisher: getNotesPublisher)
    }
    
    public func saveNote(note: ENote) {
        networkRequest.saveNote(note: note, publisher: changePublisher)
    }
    
    public func updateNote(note: ENote) {
        networkRequest.updateNote(note: note, publisher: changePublisher)
    }
}
