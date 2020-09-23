//
//  Profile.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

public class Profile {
    
    public var user: User
    
    public var location: String
    
    public var cover: String
    
    public var description: String
    
    public init() {
        user = User()
        location = "Dĩ An, Bình Dương"
        cover = "cover"
        description = "Luôn chân thành, lắng nghe và học hỏi"
    }
}
