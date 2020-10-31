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
        observerSaveNote()
    }
    
    func prepareData(ubid: String) {
        isLoading = true
        userbookManager.getUserBook(ubid: ubid)
        noteManager.getNotes(ubid: ubid)
    }
    
    func addNewNote(content: String) {
        isLoading = true
        noteManager.saveNote(note: ENote(userBookID: model.id, content: content))
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
    /// Using for Add note View
    private func observerSaveNote() {
        noteManager
            .savePublisher
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
                        self.notes.append(Note(id: note.id!, content: note.content, createAt: note.createdAt!))
                    }
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
}
