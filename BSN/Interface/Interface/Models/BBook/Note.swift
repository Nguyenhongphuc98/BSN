//
//  Note.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

class Note: Undefinable, ObservableObject {
    
    var id: String
    var createDate: Date
    var UBID: String
    
    @Published var content: String
    
    var photoUrl: String?
    var page: String?
    
    init() {
        id = kUndefine
        UBID = kUndefine
        createDate = Date()
        content = ""
    }
    
    // init to save
    init(content: String, UBID: String, photo: String? = nil, page: String? = nil) {
        self.id = kUndefine
        self.UBID = UBID
        self.createDate = Date()
        self.content = content
        self.photoUrl = photo
        self.page = page
    }
    
    // init to display
    init(id: String, content: String, createAt: String,
         UBID: String, photo: String? = nil, page: String? = nil) {
        
        self.id = id
        self.UBID = UBID
        self.createDate = Date.getDate(dateStr: createAt)
        self.content = content
        self.photoUrl = photo
        self.page = page ?? "*"
    }
    
    func clone(note: Note) {
        self.content = note.content
        self.id = note.id
        self.UBID = note.UBID
        
        self.photoUrl = note.photoUrl
        self.page = note.page
    }
    func reset() {
        self.id = kUndefine
        self.content = ""
        self.UBID = kUndefine
        self.createDate = Date()
        self.page = nil
        self.photoUrl = nil
    }
}
