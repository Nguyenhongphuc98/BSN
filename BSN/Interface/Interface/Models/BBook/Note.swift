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
    
    @Published var content: String
    
    init() {
        id = kUndefine
        createDate = Date()
        content = ""
    }
    
    init(content: String) {
        id = kUndefine
        createDate = Date()
        self.content = content
    }
    
    init(id: String, content: String, createAt: String) {
        self.id = id
        self.createDate = Date.getDate(dateStr: createAt)
        self.content = content
    }
    
    func reset() {
        self.id = kUndefine
        self.content = ""
        self.createDate = Date()
    }
}
