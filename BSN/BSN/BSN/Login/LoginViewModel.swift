//
//  LoginViewModel.swift
//  BSN
//
//  Created by Phucnh on 11/11/20.
//

import SwiftUI

import Business
import Interface
import FBSDKLoginKit

class LoginViewModel: NetworkViewModel {
    
    @Published var message: String
    
    private var accountManager: AccountManager
    
    private var appManager: AppManager
    
    private var userManager: UserManager
    
    @AppStorage("username") var username: String = ""
    
    @AppStorage("password") var password: String = ""
    
    @AppStorage("logined") var logined: Bool = false // it was login before
    
    // FB lofin
    var manager: LoginManager = .init()
    
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
                    
                    if ac.id == nil || ac.id == "undefine" {
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
                    
                    if u.id == nil || u.id == "undefine" {
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
                            // Incase user login first time,
                            // We should update location to server
                            LocationManager.shared.updateLocation()
                            LocationManager.shared.didUpdateLocation = { (location, des) in
                                let fullLocation = "\(location)-\(des)"
                                LocationManager.shared.updateToSever(location: fullLocation)
                            }
                            self.appManager.appState = .onboard
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// Social login (facebook)
extension LoginViewModel {
    func loginWithFacebook() {
        self.isLoading = true
        
        manager.logIn(permissions: ["public_profile", "email"], from: nil) { (result, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            if !result!.isCancelled {
                // login success
                let request = GraphRequest(graphPath: "me", parameters: ["fields":"email"])
                request.start { (_, res, _) in
                    guard let profileData = res as? [String: Any] else {
                        return
                    }
                    //let email = profileData["email"] as? String
                    let accessToken = AccessToken.current?.tokenString
                    let id: String = profileData["id"] as! String //The app user's App-Scoped User ID. This ID is unique to the app and cannot be used by other apps.
                    //print("did login with email: \(email) token: \(accessToken!.tokenString) id: \(id)")
                    
                    // Authen cation to server
                    let ea = EAccount(username: id, password: accessToken)
                    self.username = ea.username
                    self.password = ea.password!
                    self.accountManager.loginWithFacebook(account: ea)
                }
            }
                                        
        }
    }
}
