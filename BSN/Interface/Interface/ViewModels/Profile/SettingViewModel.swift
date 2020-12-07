//
//  SettingViewModel.swift
//  Interface
//
//  Created by Phucnh on 11/12/20.
//
import Business
import SwiftUI

class SettingViewModel: NetworkViewModel {
    
    var accountManager: AccountManager
    
    var userManager: UserManager
    
    @AppStorage("username") var username: String = ""
    
    @AppStorage("password") var password: String = ""
    
    @AppStorage("logined") var logined: Bool = false // it was login before
    
    override init() {
        accountManager = .init()
        userManager = .init()
        super.init()
        observerUpdateUser()
    }
    
    func updateInfo(displayName: String? = nil, about: String? = nil) {
        let user = EUser(
            id: AppManager.shared.currenUID,
            displayname: displayName,
            about: about
        )
        UIApplication.shared.endEditing(true)
        isLoading = true
        userManager.updateUser(user: user)
    }
    
    func logout() {
        accountManager.logout()
        
        username = ""
        password = ""
        logined = false
        
        withAnimation {
            AppManager.shared.appState = .login
        }
    }
    
    private func observerUpdateUser() {
        userManager
            .changePublisher
            .sink {[weak self] (user) in

                guard let self = self else {
                    return
                }

                DispatchQueue.main.async {
                   
                    if user.id == kUndefine {
                        self.resourceInfo = .update_fail
                    } else {
                        self.resourceInfo = .success
                    }
                    
                    self.isLoading = false
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
}
