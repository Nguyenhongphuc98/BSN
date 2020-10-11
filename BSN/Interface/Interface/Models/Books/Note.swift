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
        createDate = randomDate()
        content = randomComment()
    }
    
    init(content: String) {
        id = UUID().uuidString
        createDate = randomDate()
        self.content = content
    }
}
