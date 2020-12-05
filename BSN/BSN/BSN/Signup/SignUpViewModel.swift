//
//  SignUpViewModel.swift
//  BSN
//
//  Created by Phucnh on 12/5/20.
//
import SwiftUI
import Business
import Interface

class SignUpViewModel: NetworkViewModel {
    
    @Published var message: String
    
    private var accountManager: AccountManager
    
    override init() {
        message = ""
        accountManager = AccountManager()
        
        super.init()
        observerSignUp()
    }
    
    func signup(displayname: String, username: String, password: String, confirmPass: String) {
        message = ""
        
        guard username.isValidEmail() else {
            message = "Username phải là email."
            objectWillChange.send()
            return
        }
        
        guard !displayname.isEmpty else {
            message = "Tên hiển thị không được để trống."
            objectWillChange.send()
            return
        }
        
        guard password.count >= 8 else {
            message = "Mật khẩu tối thiểu 8 ký tự."
            objectWillChange.send()
            return
        }
        
        guard confirmPass == password else {
            message = "Mật khẩu không khớp."
            objectWillChange.send()
            return
        }
        
        isLoading = true
        let a = EAccount(name: displayname, username: username, password: password, confirmPass: confirmPass)
        accountManager.signup(account: a)
    }
    
    private func observerSignUp() {
        accountManager
            .accountPublisher
            .sink {[weak self] (ac) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if ac.id == "undefine" {
                        // check exist account or something wrong
                        self.message = "Dữ liệu không hợp lệ"
                    } else {
                        
                        self.resourceInfo = .signup_success
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellables)
    }
}
