//
//  StaticVariable.swift
//  Interface
//
//  Created by Phucnh on 9/26/20.
//

import Foundation

public let interfaceBundle = Bundle(for: Profile.self)

public let stickers = ["bear", "cat", "chicken", "circleFrog", "elephant", "frog", "monkey", "mouse", "pig", "polarBear", "puppy", "rabbit", "rooster", "sheep", "squirrel", "tiger"]

func getDistanceFromLatLonInKm(lat1: Float, lon1: Float) -> Float {
    
    // get current locaton of this user
    let lat2: Float = 10.878117
    let lon2: Float = 106.806465
    
    let R: Float = 6371; // Radius of the earth in km
    let dLat = deg2rad(deg: lat2 - lat1)  // deg2rad below
    let dLon = deg2rad(deg: lon2 - lon1)
    let a = sin(dLat/2) * sin(dLat/2) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * sin(dLon/2) * sin(dLon/2)
    
    let c = 2 * atan2(sqrt(a), sqrt(1-a));
    let d = R * c; // Distance in km
    
    return d * 1000;
}

func deg2rad(deg: Float) -> Float {
    return deg * (Float.pi/180)
}
