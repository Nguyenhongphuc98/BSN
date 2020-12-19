//
//  ResetPassViewModel.swift
//  BSN
//
//  Created by Phucnh on 12/19/20.
//

import SwiftUI
import Business
import Interface

class ResetPassViewModel: NetworkViewModel {
    
    @Published var message: String
    
    private var accountManager: AccountManager
    
    override init() {
        message = ""
        accountManager = .init()
        
        super.init()
        observerReset()
    }
    
    func reset(email: String) {
        message = ""
        
        guard email.isValidEmail() else {
            message = "email không đúng định dạng."
            objectWillChange.send()
            return
        }
        
        isLoading = true
        accountManager.resetPassword(recover: email)
    }
    
    private func observerReset() {
        accountManager
            .accountPublisher
            .sink {[weak self] (ac) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if ac.id == "undefine" {
                        // st occur when reset
                        // invalid email
                        // email not exist in our system or email not exist in email system
                        if ac.username == "Not Found" {
                            self.message = "Email not exist in system"
                        } else {
                            self.message = ac.username
                        }
                        self.objectWillChange.send()
                    } else {
                        
                        self.resourceInfo = .resetpass_success
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellables)
    }
}
