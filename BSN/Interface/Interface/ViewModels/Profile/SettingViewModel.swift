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
    
    @AppStorage("username") var username: String = ""
    
    @AppStorage("password") var password: String = ""
    
    @AppStorage("logined") var logined: Bool = false // it was login before
    
    override init() {
        accountManager = AccountManager()
        super.init()
    }
    
    func logout() {
        username = ""
        password = ""
        logined = false
        
        withAnimation {
            AppManager.shared.appState = .login
        }
    }
}
