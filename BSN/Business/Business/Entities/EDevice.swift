//
//  EDevice.swift
//  Business
//
//  Created by Phucnh on 12/5/20.
//
public enum System: String, Codable {
    case iOS
    case android
}

public struct EDevice: Codable {
    
    var id: String?
    var system: System
    var osVersion: String
    var pushToken: String
    var userID: String
    
    public init() {
        id = "undefine"
        system = .iOS
        osVersion = "unknow"
        pushToken = "undefine"
        userID = "undefine"
    }
    
    public init(id: String? = nil, system: System, osVersion: String, pushToken: String, userID: String ) {
        self.id = id
        self.system = system
        self.osVersion = osVersion
        self.pushToken = pushToken
        self.userID = userID
    }
}
