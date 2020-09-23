//
//  ProfileViewModel.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    var profile: Profile
    
    static let shared: ProfileViewModel = ProfileViewModel()
    
    init() {
        profile = Profile()
    }
}
