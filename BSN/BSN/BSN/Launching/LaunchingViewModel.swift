//
//  LaunchingViewModel.swift
//  BSN
//
//  Created by Phucnh on 11/11/20.
//

import SwiftUI
import Interface

class LaunchingViewModel: ObservableObject {
    
    @AppStorage("username") var username: String = ""
    
    @AppStorage("password") var password: String = ""
    
    @AppStorage("logined") var logined: Bool = false // it was login before
    
    @Published var progess: Float = 0
    
    var login: LoginViewModel
    
    init() {
        login = LoginViewModel()
        autoLoginIfNeeded()
    }
    
    func autoLoginIfNeeded() {
        if logined {
            print("Did login before, we should auto process login")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                self.progess = 0.7
            }
            login.login(username: username, password: password)
        } else {
            AppManager.shared.appState = .login
        }
    }
}
