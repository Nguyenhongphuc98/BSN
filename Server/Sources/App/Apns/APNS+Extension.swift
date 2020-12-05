//
//  APNS+Extension.swift
//
//
//  Created by Phucnh on 12/4/20.
//
import Vapor
import APNS
import Fluent

extension Request.APNS {
    // Send other objects with `APNSwiftPayload`
    func send<Notification>(_ notification: Notification, to device: Device)
    -> EventLoopFuture<Void> where Notification: APNSwiftNotification {
//        guard let pushToken = device.pushToken else {
//            return self.eventLoop.makeSucceededFuture(())
//        }
        
        return send(notification, to: device.pushToken)
    }
    
    // Send basic 'aps'
    func send(_ payload: APNSwiftPayload, to device: Device) -> EventLoopFuture<Void> {
//        guard let pushToken = device.pushToken else {
//            return self.eventLoop.makeSucceededFuture(())
//        }
        
        return send(payload, to: device.pushToken)
    }
    
    func send(_ payload: APNSwiftPayload, to userID: UUID, db: Database) {

        // Send push notify to all device of this user
        _ = Device.query(on: db)
            .filter(\.$userID == userID)
            .all()
            .map { devices in
                devices.forEach { (d) in
                    _ = send(payload, to: d.pushToken)
                }
            }
    }
}
