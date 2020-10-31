//
//  Note.swift
//  Interface
//
//  Created by Phucnh on 10/10/20.
//

import SwiftUI

class Note: Identifiable {
    
    var id: String
    
    var createDate: Date
    
    var content: String
    
    init() {
        id = UUID().uuidString
        createDate = fakedates.randomElement()!
        content = fakeComments.randomElement()!
    }
    
    init(content: String) {
        id = UUID().uuidString
        createDate = fakedates.randomElement()!
        self.content = content
    }
    
    init(id: String, content: String, createAt: String) {
        self.id = id
        self.createDate = Date.getDate(dateStr: createAt)
        self.content = content
    }
}
