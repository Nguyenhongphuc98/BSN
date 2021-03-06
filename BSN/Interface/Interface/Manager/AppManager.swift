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

public enum AppState {
    case loading
    case login
    case inapp
    case onboard
}

public class AppManager: ObservableObject {
    
    public static var shared: AppManager = AppManager()
    
    @Published public var selectedIndex: Int
    
    @Published public var appState: AppState // to handle view display
    
    @Published public var currentAccount: Account
    
    @Published public var currentUser: User
    
    @Published public var navBarTitle: LocalizedStringKey
    
    @Published public var keyboardHeight: CGFloat
    
    @Published public var numUnReadMessage: Int
    
    @Published public var numUnReadNotify: Int
    
    public var currenUID: String {
        currentUser.id
    }
    
    public init() {
        self.selectedIndex = 0
        self.currentAccount = Account()
        self.currentUser = User()
        self.navBarTitle = "SEB"
        self.keyboardHeight = 0
        self.appState = .loading
        self.numUnReadMessage = 0
        self.numUnReadNotify = 0
    
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

// Update tabbar icon with red point
// mark that unread something
extension AppManager {
    func updateTabbar(chats: [Chat]) {
        let unreads = chats.filter { $0.seen == false }
        self.numUnReadMessage = unreads.count
    }
    
    func updateTabbar(notifies: [Notify]) {
        let unreads = notifies.filter { $0.seen == false }
        self.numUnReadNotify = unreads.count        
    }
}
