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
    
    @Published var subcomments: [Comment]?
    
    init(parent: Bool = true) {
        self.id = UUID().uuidString
        self.parent = UUID().uuidString
        self.owner = User()
        self.commentDate = randomDate()
        self.content = randomComment()
        subcomments = parent ? [Comment(parent: false), Comment(parent: false)] : nil
    }
}
