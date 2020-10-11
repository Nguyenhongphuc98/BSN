//
//  Comment.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import Foundation

class Comment: ObservableObject, Identifiable {
    
    var id: String
    
    // post ID
    var parent: String
    
    var owner: User
    
    var commentDate: Date
    
    var content: String
    
    var level: Int
    
    @Published var subcomments: [Comment]?
    
    init(firstLevel: Bool = true) {
        self.id = UUID().uuidString
        self.parent = UUID().uuidString
        self.owner = User()
        self.commentDate = fakedates.randomElement()!
        self.content = fakeComments.randomElement()!
        self.level = firstLevel ? 0 : 1
        subcomments = firstLevel ? [Comment(firstLevel: false), Comment(firstLevel: false)] : nil
    }
    
    init(parent: String, owner: User, content: String, level: Int) {
        self.id = UUID().uuidString
        self.parent = parent
        self.owner = owner
        self.commentDate = Date()
        self.content = content
        self.level = level
    }
    
    init(dummy: Bool) {
        self.id = ""
        self.parent = ""
        self.owner = User()
        self.commentDate = fakedates.randomElement()!
        self.content = ""
        level = 0
    }
    
    func isDummy() -> Bool {
        return self.id == ""
    }
    
    func clear() {
        self.id = ""
        self.parent = ""
        self.content = ""
    }
}
