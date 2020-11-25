//
//  LoginViewModel.swift
//  BSN
//
//  Created by Phucnh on 11/11/20.
//

import SwiftUI
import Business
import Interface

class LoginViewModel: NetworkViewModel {
    
    @Published var message: String
    
    private var accountManager: AccountManager
    
    private var appManager: AppManager
    
    private var userManager: UserManager
    
    @AppStorage("username") var username: String = ""
    
    @AppStorage("password") var password: String = ""
    
    @AppStorage("logined") var logined: Bool = false // it was login before
    
    override init() {
        message = ""
        accountManager = AccountManager()
        userManager = UserManager()
        appManager = AppManager.shared
        
        super.init()
        observerLoggin()
        observerUserInfo()
    }
    
    func login(username: String, password: String) {
        isLoading = true
        message = ""
        self.username = username
        self.password = password
        let a = EAccount(username: username, password: password)
        accountManager.login(account: a)
    }
    
    private func observerLoggin() {
        accountManager
            .getAccountPublisher
            .sink {[weak self] (ac) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if ac.id == "undefine" {
                        self.message = "Tài khoản hoặc mật khẩu không đúng"
                        self.appManager.appState = .login
                    } else {
                        
                        self.appManager.currentAccount = Account(
                            id: ac.id,
                            username: ac.username,
                            password: ac.password
                        )
                        self.userManager.getUser(aid: ac.id!)
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerUserInfo() {
        userManager
            .getUserPublisher
            .sink {[weak self] (u) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if u.id == "undefine" {
                        self.resourceInfo = .notfound
                        self.showAlert.toggle()
                    } else {
                        self.appManager.currentUser = User(
                            id: u.id!,
                            username: self.appManager.currentAccount.username,
                            displayname: u.displayname,
                            avatar: u.avatar,
                            cover: u.cover,
                            location: u.location,
                            about: u.about
                        )
                        
                        self.appManager.appState = .inapp
                        self.logined = true
                        print("did login with user: \(u.displayname)")
                        
                        // Reload data for new user
                        ChatViewModel.shared.prepareData()
                        NotifyViewModel.shared.prepareData()
                        ProfileViewModel.shared.prepareData(uid: self.appManager.currenUID)
                        ExploreBookViewModel.shared.prepareData()
                        NewsFeedViewModel.shared.prepareData()
                    }
                }
            }
            .store(in: &cancellables)
    }
}
