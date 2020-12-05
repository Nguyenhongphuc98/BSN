//
//  DeviceManager.swift
//  Business
//
//  Created by Phucnh on 12/5/20.
//


public class DeviceManager {
    
    private let networkRequest: DeviceRequest
    
    public static var shared: DeviceManager = .init()
    
    public init() {
        // Init resource URL
        networkRequest = DeviceRequest(componentPath: "devices/")
    }
    
    public func saveDevice(device: EDevice) {
        networkRequest.saveDevice(device: device)
    }
}
