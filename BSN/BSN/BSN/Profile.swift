//
//  Profile.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

class Profile {
    
    var user: User
    
    var location: String
    
    var cover: String
    
    var description: String
    
    init() {
        user = User()
        location = "Dĩ An, Bình Dương"
        cover = "cover"
        description = "Luôn chân thành, lắng nghe và học hỏi"
    }
}
