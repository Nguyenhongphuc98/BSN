//
//  NoteManager.swift
//  Business
//
//  Created by Phucnh on 10/31/20.
//

import Combine

public class NoteManager {
    
    private let networkRequest: NoteRequest
    
    // Publisher for save new note action
    public let savePublisher: PassthroughSubject<ENote, Never>
    
    // Publisher for fetch notes by ubid
    public let getNotesPublisher: PassthroughSubject<[ENote], Never>
    
    public init() {
        // Init resource URL
        networkRequest = NoteRequest(componentPath: "notes/")
        
        savePublisher = PassthroughSubject<ENote, Never>()
        getNotesPublisher = PassthroughSubject<[ENote], Never>()
    }
    
    public func saveNote(note: ENote) {
        networkRequest.saveNote(note: note, publisher: savePublisher)
    }
    
    public func getNotes(ubid: String) {
        networkRequest.fetchNotes(ubid: ubid, publisher: getNotesPublisher)
    }
}
