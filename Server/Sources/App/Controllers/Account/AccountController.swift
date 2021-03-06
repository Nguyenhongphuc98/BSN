//
//  AccountController.swift
//  
//
//  Created by Phucnh on 10/15/20.
//

import Vapor
import Fluent
import Smtp

struct AccountController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let accounts = routes.grouped("api", "v1", "accounts")
        let authen = accounts.grouped(Account.authenticator())
        
        authen.get(use: index)
        authen.group(":accountID") { gr in
            gr.delete(use: delete)
        }
        
        authen.get("login", use: login)
        authen.delete("logout", use: logout)
        authen.post("register", use: create)
        authen.put(use: update)
        authen.get("reset", use: resetPassword)
    }

    func index(req: Request) throws -> EventLoopFuture<[Account]> {
        return Account.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Account> {
        try Account.Create.validate(content: req)
        let create = try req.content.decode(Account.Create.self)
        
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        
        let account = try Account(
            username: create.username,
            password: Bcrypt.hash(create.password)
        )
        return account.save(on: req.db)
            .flatMap {
                let user = User(
                    username: create.username,
                    displayname: create.name,
                    cover: "https://farm4.staticflickr.com/3692/10621312106_02476d5c63_o.jpg", // default cover
                    location: "0-0- ", // default location
                    accountID: account.id!)
                
                return user.save(on: req.db)
                    .map { return account }
            }
    }
    
    // update onboard
    // or change password
    func update(req: Request) throws -> EventLoopFuture<Account> {
        
        let updateAccount = try req.content.decode(Account.Update.self)
        
        // Authen
        let account = try req.auth.require(Account.self)
               
        return Account.find(account.id!, on: req.db)
            .unwrap(or: Abort(.forbidden))
            .flatMap { (account)  in
                // we only can update 2 filed
                if updateAccount.isOnboarded != nil {
                    account.isOnboarded = updateAccount.isOnboarded!
                }
                if updateAccount.password != nil {
                    account.password = try! Bcrypt.hash(updateAccount.password!)
                }
                return account.update(on: req.db).map {
                    account
                }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Account.find(req.parameters.get("accountID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
    func login(req: Request) throws -> Account {
        let ac = try req.auth.require(Account.self)
        return ac.asPublic()
    }
    
    func logout(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        // Authen
        let account = try req.auth.require(Account.self)
        
        // Determine current user
        return User.query(on: req.db)
            .filter(\.$accountID == account.id!)
            .first()
            .unwrap(or: Abort(.forbidden))
            .flatMap { (user)  in
                
                return Device.query(on: req.db)
                    .filter(\.$userID == user.id!)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { $0.delete(on: req.db) }
                    .transform(to: .ok)
            }
    }
    
    func resetPassword(req: Request) throws -> EventLoopFuture<Account> {

        // Validate email
        // check exist in system
        // generate password and update
        // sent new pass to email
        // if send success, return account
        // else return undefine account
        
        //try BSNEmail.validate(content: req)
        try BSNEmail.validate(query: req)
        guard let emailAdress: String = req.query["email"] else {
            throw Abort(.badRequest)
        }
        
        // find owner of this email
        // make sure it exist in our system
        return Account.query(on: req.db)
            .filter(\.$username == emailAdress)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMap { (account) -> EventLoopFuture<Account> in
                
                User.query(on: req.db)
                    .filter(\.$accountID == account.id!)
                    .first()
                    .unwrap(or: Abort(.notFound))
                    .flatMap { (user) -> EventLoopFuture<Account> in
                        
                        let newPassword = generateRandomPassword(length: 8)
                        let email = Email(from: EmailAddress(address: "nguyenhongphuc98@gmail.com"),
                                          to: [EmailAddress(address: emailAdress)],
                                          subject: "QUÊN MẬT KHẨU - SE",
                                          body: " Xin chào \(user.displayname)! \n Mật khẩu mới của bạn là: \(newPassword).\n Bạn có thể đăng nhập và thay đổi mật khẩu trong phần cài đặt.")
                        
                        // update new password for user
                        account.password = try! Bcrypt.hash(newPassword)
                        _ = account.update(on: req.db)
                        
                        return req.smtp.send(email).flatMap({ result -> EventLoopFuture<Account> in
                            switch result {
                            case .success:
                                print("Email has been sent")
                            case .failure(let error):
                                print("Email has not been sent: \(error)")
                                account.username = "undefine"
                            }
                            return req.eventLoop.makeSucceededFuture(account.asPublic())
                        })
                    }
            }
    }
}

func generateRandomPassword(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
