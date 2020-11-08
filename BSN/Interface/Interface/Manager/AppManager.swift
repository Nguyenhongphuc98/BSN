//
//  RootViewModel.swift
//  BSN
//
//  Created by Phucnh on 9/23/20.
//

import SwiftUI
import Combine

enum RootIndex: Int {
    case news
    case explore
    case chat
    case notify
    case profile
}

public class AppManager: ObservableObject {
    
    public static var shared: AppManager = AppManager()
    
    @Published public var selectedIndex: Int
    
    @Published public var logined: Bool
    
    @Published public var currentAccount: Account
    
    @Published public var currentUser: User
    
    @Published public var navBarTitle: LocalizedStringKey
    
    @Published public var keyboardHeight: CGFloat
    
    public var currenUID: String {
        currentUser.id
    }
    
    public init() {
        self.selectedIndex = 4
        self.logined = true
        self.currentAccount = Account()
        self.currentUser = User()
        self.navBarTitle = "SEB"
        self.keyboardHeight = 0
        print("did init root with user: \(currentUser.displayname)")
        
        self.currentUser.id = "C4285ABE-F520-46F3-97A3-508D94177D9C"
        registerKeyboardEvent()
    }
    
    func registerKeyboardEvent() {
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
            .compactMap { notification in
                notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect
            }
            .map { rect in
                rect.height
            }
            .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
        
        NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillHideNotification)
            .compactMap { notification in
                CGFloat.zero
            }
            .subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
    }
}
