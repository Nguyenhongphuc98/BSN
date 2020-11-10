//
//  MyBookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI
import Business

class MyBookDetailViewModel: NetworkViewModel {
    
    @Published var model: BUserBook
    
    @Published var notes: [Note]
    
    private var userbookManager: UserBookManager
    
    private var noteManager: NoteManager
    
    override init() {
        model = BUserBook()
        notes = []
        userbookManager = UserBookManager()
        noteManager = NoteManager()
        
        super.init()
        
        observerGetUserBook()
        observerGetNotes()
        observerChangeNote()
    }
    
    func prepareData(ubid: String) {
        isLoading = true
        userbookManager.getUserBook(ubid: ubid)
        noteManager.getNotes(ubid: ubid)
    }
    
    func processNote(note: Note) {
        isLoading = true
        // Undefine mean this is new note, we should save it
        if note.isUndefine() {
            noteManager.saveNote(note: ENote(userBookID: model.id, content: note.content))
        } else {
            noteManager.updateNote(note: ENote(id: note.id, content: note.content))
        }
    }
    
    func deleteNote(note: Note) {
        notes.removeAll(where: { $0.id == note.id })
        objectWillChange.send()
        noteManager.deleteNote(noteID: note.id)
    }
    
    
    /// User Book get from server will received at this block
    private func observerGetUserBook() {
        /// Get user book by ID to load on UI
        userbookManager
            .getUserBookPublisher
            .sink {[weak self] (ub) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if ub.id == "undefine" {
                        self.resourceInfo = .notfound
                        self.showAlert.toggle()
                    } else {
                        
                        self.model.id = ub.id
                        self.model.title = ub.title!
                        self.model.author = ub.author!
                        self.model.description = ub.description!
                        self.model.cover = ub.cover
                        self.model.statusDes = ub.statusDes!
                        self.model.state = ub.state.map { BookState(rawValue: $0)! }
                        self.model.status = ub.status.map { BookStatus(rawValue: $0)! }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// Get notes of current user book
    private func observerGetNotes() {
        noteManager
            .getNotesPublisher
            .sink {[weak self] (notes) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if !notes.isEmpty {
                        if notes[0].id == "undefine" {
                            self.resourceInfo = .getfailure
                            self.showAlert.toggle()
                        } else {
                            
                            self.notes.removeAll()
                            self.notes = notes.map({ note in
                                Note(id: note.id!, content: note.content, createAt: note.createdAt!)
                            })
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// Get save note info
    /// Using for Add note View, update a note
    private func observerChangeNote() {
        noteManager
            .changePublisher
            .sink {[weak self] (note) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if note.id == "undefine" {
                        self.resourceInfo = .savefailure
                    } else {
                        
                        self.resourceInfo = .success
                        let newNote = Note(id: note.id!, content: note.content, createAt: note.createdAt!)
                        
                        let index = self.notes.firstIndex { n in
                            n.id == note.id
                        }
                        
                        // To determine action is save or update
                        if let i = index {
                            self.notes.remove(at: i)
                            self.notes.insert(newNote, at: i)
                        } else {
                            self.notes.append(newNote)
                        }
                    }
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
}
