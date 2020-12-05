//
//  AppDelegate.swift
//  BSN
//
//  Created by Phucnh on 11/26/20.
//

import Foundation
import UIKit
import AWSS3
import Business
import Interface

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initializeS3()
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        // Send device token to server
        let device = EDevice(
            system: .iOS,
            osVersion: UIDevice.current.systemVersion,
            pushToken: token,
            userID: AppManager.shared.currenUID
        )
        DeviceManager.shared.saveDevice(device: device)
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func initializeS3() {
        let poolId = "us-east-2:0adc1b98-8105-40d4-b27a-3d3d2681be7e"
        let credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: .USEast2, // region of pool
            identityPoolId: poolId
        )
        let configuration = AWSServiceConfiguration(
            region: .APSoutheast1, // region of buck
            credentialsProvider: credentialsProvider
        )
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        print("Did init S3!")
    }
}
