//
//  RootViewModel.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI

public class RootViewModel: ObservableObject {
    
    public static var shared: RootViewModel = RootViewModel()
    
    @Published public var selectedIndex: Int
    
    @Published public var logined: Bool
    
    @Published public var currentAccount: Account
    
    @Published public var currentUser: User
    
    @Published public var navBarTitle: LocalizedStringKey
    
    @Published public var navBarTrailingItems: AnyView
    
    @Published public var navBarLeadingItems: AnyView
        
    @Published public var navBarHidden: Bool
    
    public init() {
        self.selectedIndex = 2
        self.logined = true
        self.currentAccount = Account()
        self.currentUser = User()
        self.navBarTitle = "SEB"
        self.navBarTrailingItems = .init(EmptyView())
        self.navBarLeadingItems = .init(EmptyView())
        self.navBarHidden = true
        print("did init root with user: \(currentUser.displayname)")
    }
}
