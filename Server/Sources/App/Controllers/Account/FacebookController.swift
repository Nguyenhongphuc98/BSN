//
//  FacebookController.swift
//  
//
//  Created by Phucnh on 12/13/20.
//

/// Get App token by this url:
// https://graph.facebook.com/oauth/access_token?
// client_id=795451491037217 //- AppId
// &client_secret=9810e1a65ce7f98cab7763ed5ac727c5 //-AppSecret
// &grant_type=client_credentials

/// Response
//{
//access_token: "795451491037217|sX8JVTKAX4p3LoRbROY_aGPSFqA",
//token_type: "bearer"
//}

/// Check token of user is lavid (should pass 2 condition)
// 1. Belong to our app
// 2. Of user we process
// https://graph.facebook.com/debug_token?
// input_token=INPUT_TOKEN //- User token
// &access_token=ACCESS_TOKEN // - Apptoken

/// Response
// {
//data: {
//error: {
//code: 190,
//message: "Invalid OAuth access token."
//},
//is_valid: false,
//scopes: [ ]
//}
//}

//{
//data: {
//app_id: "795451491037217",
//type: "USER",
//application: "seb",
//data_access_expires_at: 1615628130,
//expires_at: 1613018221,
//is_valid: true,
//issued_at: 1607834221,
//metadata: {
//auth_type: "rerequest",
//sso: "iphone-safari"
//},
//scopes: [
//"email",
//"public_profile"
//],
//user_id: "1819986271482622"
//}
//}


import Vapor
import Fluent
//import SwiftyJSON

struct FacebookController: RouteCollection {
    
    // Our role is:
    // username - facebook userID in our app
    // password - facebook user token
    
    let g_access_token = "795451491037217|sX8JVTKAX4p3LoRbROY_aGPSFqA"
    let g_app_id = "795451491037217"
    
    func boot(routes: RoutesBuilder) throws {
        let facebooks = routes.grouped("api", "v1", "accounts")
        facebooks.post("loginFacebook", use: login)
    }

    // Try to login
    // Incase failure, return account with undefine username
    // Although password will be update any thime we login
    // Because algorithm has Bcrypt can hash to dif value
    // But with authen algotithm, we can mark it as same value
    func login(req: Request) throws -> EventLoopFuture<Account> {
                
        let facebook = try req.content.decode(Account.Update.self)
        
        // First, try to check this account is exist
        return Account.query(on: req.db)
            .filter(\.$username == facebook.username)
            .first()
            .flatMap { (account) -> EventLoopFuture<Account> in
                 if let newAccount = account {
                     // happy path, user login fb before and this token validate in our system
                    let hasedToken = try! Bcrypt.hash(facebook.password!)
                     if newAccount.password == hasedToken {
                        return req.eventLoop.makeSucceededFuture(newAccount.asPublic())
                     } else {
                        // This is new token or invalid token
                        // 1. We should check valid to facebook app
                        // 2. if true, update token (password), return account
                        // 3. else, return failure
                        return VerifyFacebookToken(req: req, facebook: facebook)
                             .flatMap { (valid) -> EventLoopFuture<Account> in
                                if valid {
                                    newAccount.password = try! Bcrypt.hash(facebook.password!)
                                    return newAccount.update(on: req.db).map { newAccount.asPublic() }
                                } else {
                                    let undefine = Account(username: "undefine", password: "undefine")
                                    return req.eventLoop.makeSucceededFuture(undefine)
                                }
                             }
                     }
                 } else {
                      
                     // First time login with facebook
                     // 1. Check valid token
                     // 2. Save account, user info
                     // 3. Return account
                    return VerifyFacebookToken(req: req, facebook: facebook)
                        .flatMap { (valid) -> EventLoopFuture<Account> in
                            if valid {
                                return saveAccount(req: req, facebook: facebook)
                            } else {
                                let undefine = Account(username: "undefine", password: "undefine")
                                return req.eventLoop.makeSucceededFuture(undefine)
                            }
                        }
                 }
            }
    }
    
    func VerifyFacebookToken(req: Request, facebook: Account.Update) -> EventLoopFuture<Bool> {
        // ex: https://graph.facebook.com/debug_token?input_token=EAALTdXuPMCEBAO9ljnXpK3YL5R357lr3eeCIromZC1CJrFoE0Nl1DUh8i3QrvP0vfCk88IUgfLgM9uAoWrdhAVLIr08C8PEgiRumtQMwKr7ZAr0P3jP481ezl4kVjQm2HitjtrUBfb4UQYJZBys2wefHBOAAyxTe8eRn5Xbo7y80GLRSL2waN3ZCHfg5gyc7j2Ld91ZBrVLCbXsxGdmEeWq6ZClDgXpdkD3TQtcc7N8wZDZ&access_token=795451491037217|sX8JVTKAX4p3LoRbROY_aGPSFqA
        let resourceURL = "https://graph.facebook.com/debug_token?input_token=\(facebook.password!)&access_token=\(g_access_token)"
        let uri = URI(unicodeScalarLiteral: resourceURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
      
        return req.client.get(uri).flatMapThrowing { res -> FbResItem in
            //try JSON(data: res.body!.getData(at: res.body!.readerIndex, length: res.body!.capacity)!)
            //try res.content.decode(FbResItem.self)
            let data = try res.body!.getData(at: res.body!.readerIndex, length: res.body!.capacity)!
            return try JSONDecoder().decode(FbResItem.self, from: data)
        }
        .map({ (fbRes)  in
            
            let app_id = fbRes.data.app_id
            let user_id = fbRes.data.user_id
            let is_valid = fbRes.data.is_valid
            
            // This token is valid of facebook
            guard is_valid else {
                return false
            }
            // It have to belong to our app and of uid loging
            if user_id == facebook.username && app_id == g_app_id {
                return true
            }
            return false
        })
//        .map({ (json)  in
//
//            let app_id = json["data"]["app_id"].string
//            let user_id = json["data"]["user_id"].string
//            let is_valid = json["data"]["is_valid"].bool!
//
//            // This token is valid of facebook
//            guard is_valid else {
//                return false
//            }
//            // It have to belong to our app and of uid loging
//            if user_id == facebook.username && app_id == g_app_id {
//                return true
//            }
//            return false
//        })
    }
    
    func saveAccount(req: Request, facebook: Account.Update) -> EventLoopFuture<Account> {
        let account = Account(
            username: facebook.username,
            password: try! Bcrypt.hash(facebook.password!)
        )
        return account.save(on: req.db)
            .flatMap {
                // Get user info from facebook
                let resourceURL = "https://graph.facebook.com/\(facebook.username)?fields=id,name,picture&access_token=\(facebook.password!)"
                let uri = URI(string: resourceURL)
              
                return req.client.get(uri).flatMapThrowing { res -> UserResponse in
                    //try JSON(data: res.body!.getData(at: res.body!.readerIndex, length: res.body!.capacity)!)
                    //try res.content.decode(UserResponse.self)
                    let data = try res.body!.getData(at: res.body!.readerIndex, length: res.body!.capacity)!
                    return try JSONDecoder().decode(UserResponse.self, from: data)
                }
                .flatMap { userResponse in
                    let user = User(
                        username: facebook.username,
                        displayname: userResponse.name,
                        avatar: userResponse.url,
                        cover: "https://farm4.staticflickr.com/3692/10621312106_02476d5c63_o.jpg", // default cover
                        location: "0-0- ", // default location
                        accountID: account.id!
                    )
                    
                    return user.save(on: req.db)
                        .map { return account.asPublic() }
                }
                //.flatMap({ (json)  in
                    
                    // Ex response data:
                    //                    {
                    //                        id: "1819986271482622",
                    //                        name: "Nguyễn Hồng Phúc",
                    //                        picture: {
                    //                            data: {
                    //                                height: 50,
                    //                                is_silhouette: false,
                    //                                url: "https://platform-lookaside.fbsbx.com/platform/profilepic/?asid=1819986271482622&height=50&width=50&ext=1610635057&hash=AeSvejAas3hOzY8VhJU",
                    //                                width: 50
                    //                            }
                    //                        }
                    //                    }
                    
//                    let name = json["name"].string!
//                    let picture = json["picture"]["data"]["url"].string ?? "undeifine"
//
//
//                    let user = User(
//                        username: facebook.username,
//                        displayname: name,
//                        avatar: picture,
//                        cover: "https://farm4.staticflickr.com/3692/10621312106_02476d5c63_o.jpg", // default cover
//                        location: "0-0- ", // default location
//                        accountID: account.id!
//                    )
//
//                    return user.save(on: req.db)
//                        .map { return account.asPublic() }
//                })
            }
    }
}
    
struct FbResItem: Decodable {
    struct Data: Decodable {
        var app_id: String?
        var user_id: String?
        var is_valid: Bool
    }
    
    var data: Data
}

struct RawUserResponse: Decodable {
    struct Picture: Decodable {
        struct Data: Decodable {
            var url: String
        }
        
        var data: Data
    }
    var id: String
    var name: String
    var picture: Picture
}

struct UserResponse: Decodable {
    var id: String
    var name: String
    var url: String

    init(from decoder: Decoder) throws {
        let rawResponse = try RawUserResponse(from: decoder)
        
        id = rawResponse.id
        name = rawResponse.name
        url = rawResponse.picture.data.url
    }
}

