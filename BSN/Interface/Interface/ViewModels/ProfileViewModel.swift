//
//  ProfileViewModel.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import Foundation

public class ProfileViewModel: ObservableObject {
    
    public var profile: Profile
    
    public static let shared: ProfileViewModel = ProfileViewModel()
    
    public init() {
        profile = Profile()
    }
}
