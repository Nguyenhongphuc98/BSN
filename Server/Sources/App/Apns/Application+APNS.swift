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
      let appleECP8PrivateKey =
        """
        -----BEGIN PRIVATE KEY-----
        MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgCs0bSujCTykZXkYq
        VDcq7g6Vn5UbgqcDUchbr0T8ZkugCgYIKoZIzj0DAQehRANCAATLqpZVrcqUkZGU
        nSAvxFmuiVfpi8xUXeoKoFHrNdgG7hNavEVTV8S6eyd8aJajIAkZF5iaZy72YmPv
        HWItdGD8
        -----END PRIVATE KEY-----
        """

        apns.configuration = try .init(
            authenticationMethod:.jwt(
                key: .private(pem: Data(appleECP8PrivateKey.utf8)),
                keyIdentifier: "5Y6PUBWX4F",
                teamIdentifier: "5LPVUWDHDS"
            )
            ,
            topic: "com.app.phucbsn",
            environment: .sandbox //Change environment in release
        )
    }
}

