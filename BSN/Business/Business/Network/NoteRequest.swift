//
//  NoteRequest.swift
//  Business
//
//  Created by Phucnh on 10/31/20.
//

import Combine

class NoteRequest: ResourceRequest<ENote> {
    
    func fetchNotes(ubid: String, publisher: PassthroughSubject<[ENote], Never>) {
        self.setPath(resourcePath: "search", params: ["ubid":ubid])
        
        self.get { result in
            
            switch result {
            case .failure:
                let message = "There was an error searching notes of ubid: \(ubid)"
                print(message)
                publisher.send([ENote()])
                
            case .success(let notes):
                publisher.send(notes)
            }
        }
    }
    
    func saveNote(note: ENote, publisher: PassthroughSubject<ENote, Never>) {
        self.resetPath()
        
        self.save(note) { result in
            self.processChangeNoteResult(result: result, method: "save", publisher: publisher)
        }
    }
    
    func updateNote(note: ENote, publisher: PassthroughSubject<ENote, Never>) {
        self.setPath(resourcePath: note.id!)
        
        self.update(note) { [self] result in
            self.processChangeNoteResult(result: result, method: "update", publisher: publisher)
        }
    }
    
    func deleteNote(noteID: String) {
        self.setPath(resourcePath: noteID)
        self.delete()
    }
    
    func processChangeNoteResult(result: SaveResult<ENote>, method: String, publisher: PassthroughSubject<ENote, Never>) {
        
        switch result {
        case .failure:
            let message = "There was an \(method) update note"
            print(message)
            let note = ENote()
            publisher.send(note)
            
        case .success(let note):
            publisher.send(note)
        }
    }
}
