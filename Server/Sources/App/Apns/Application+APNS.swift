////
////  Application+APNS.swift
////
////
////  Created by Phucnh on 12/4/20.
////
//
import Vapor
import APNS

extension Application {
    func configurePush() throws {
      let appleECP8PrivateKey = "Add ecp8 private key contents"
//        """
//        -----BEGIN PRIVATE KEY-----
//
//        -----END PRIVATE KEY-----
//        """

        apns.configuration = try .init(
            authenticationMethod:.jwt(
                key: .private(pem: Data(appleECP8PrivateKey.utf8)),
                keyIdentifier: "Key identifier",
                teamIdentifier: "Team identifier"
            )
            ,
            topic: "com.raywenderlich.airplanespotter",
            environment: .sandbox //Change environment in release
        )
    }
}

