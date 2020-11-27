//
//  AppDelegate.swift
//  BSN
//
//  Created by Phucnh on 11/26/20.
//

import Foundation
import UIKit
import AWSS3

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initializeS3()
        return true
    }
    
    func initializeS3() {
        let poolId = "us-east-2:46a7fb7b-1876-45de-9a90-dd022a06e4df"
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .APSoutheast1,
            identityPoolId: poolId
        )
        let configuration = AWSServiceConfiguration(region: .APSoutheast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        print("Did init S3!")
    }
}
