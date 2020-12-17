//
//  ChangePasswordViewModel.swift
//  Interface
//
//  Created by Phucnh on 12/7/20.
//

import SwiftUI
import Business

class ChangePasswordViewModel: NetworkViewModel {
    
    var accountManager: AccountManager
    
    var message: String
    
    var changeSuccess: Bool
    
    @AppStorage("password") var password: String = ""
    
    @Published var newPass: String = ""
    
    override init() {
        accountManager = AccountManager()
        message = ""
        changeSuccess = false
        super.init()
        observerUpdateAccount()
    }
    
    func resetPassword(oldPass: String, newPass: String, confirm: String) {
        isLoading = true
        message = ""
        
        var invalid: Bool = false
        
        if oldPass == newPass {
            message = "Mật khẩu mới phải khác mật khẩu cũ!"
            invalid = true
        }
        if oldPass != AppManager.shared.currentAccount.password {
            message = "Mật khẩu cũ không chính xác!"
            invalid = true
        }        
        if newPass != confirm {
            message = "Mật khẩu mới không khớp!"
            invalid = true
        }
        if invalid {
            showAlert = true
            return
        }
        self.newPass = newPass
        let ea = AppManager.shared.currentAccount.buildUpdate(password: newPass)
        accountManager.updateAccount(account: ea)
    }
    
    private func observerUpdateAccount() {
        accountManager
            .accountPublisher
            .sink {[weak self] (account) in

                guard let self = self else {
                    return
                }

                DispatchQueue.main.async {
                   
                    if account.id == kUndefine {
                        self.message = "Có lỗi khi cập nhật dữ liệu!"
                        self.changeSuccess = false
                    } else {
                        self.message = "Cập nhật mật khẩu thành công!"
                        self.changeSuccess = true
                        self.password = self.newPass
                        AppManager.shared.currentAccount.password = self.newPass
                        
                        let encodeStr = "\(AppManager.shared.currentAccount.username):\(self.password)".data(using: .utf8)?.base64EncodedString()
                        globalAuthorization = "Basic " + encodeStr!
                    }
                    
                    self.isLoading = false
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
}
