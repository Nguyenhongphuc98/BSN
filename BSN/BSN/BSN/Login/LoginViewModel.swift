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
            .accountPublisher
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
                            password: self.password, // password was save on device
                            isOnboard: ac.isOnboarded!
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
                            displayname: u.displayname!,
                            avatar: u.avatar,
                            cover: u.cover,
                            location: u.location,
                            about: u.about
                        )
                                                
                        self.logined = true
                        print("did login with user: \(u.displayname)")
                        
                        if self.appManager.currentAccount.isOnboard {
                            self.appManager.appState = .inapp
                            setupData()
                        } else {
                            LocationManager.shared.updateLocation()
                            LocationManager.shared.didUpdateLocation = { (location, des) in
                                print(">>> Did get: \(location)-\(des)")
                            }
                            self.appManager.appState = .onboard
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
