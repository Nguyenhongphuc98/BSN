//
//  DeviceController.swift
//  
//
//  Created by Phucnh on 12/4/20.
//

import Vapor
import Fluent
import APNS

struct DeviceController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("api", "v1", "devices")
        
        group.post(use: create)
        group.delete(":ID", use: delete)
        
        group.post("test-push-device",":id", use: sendTestPush)
        group.post("test-push-token",":id", use: sendTestPushByDeviceToken)
    }
    
    // This func should call after login success
    // if it aleardy exist (same userid-pushtoken) -> will save failure
    // and we don't need care
    func create(req: Request) throws -> EventLoopFuture<Device> {
        let newDevice = try req.content.decode(Device.self)        
        return newDevice.save(on: req.db).map { newDevice }
    }
    
    // This fun should call when logout device
    // So, no notifications send to old device
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        return Device.find(req.parameters.get("ID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}

// MARK: - Test method
extension DeviceController {
    func sendTestPush(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Device.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { device in
                let payload = APNSwiftPayload(alert: .init(title: "Test notification",
                                                           body: "It works!"),
                                              sound: .normal("default"))
                return req.apns.send(payload, to: device).map { .ok }
            }
    }
    
    func sendTestPushByDeviceToken(_ req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let pushToken = req.parameters.get("id")!
        let payload = APNSwiftPayload(alert: .init(title: "Test notification",
                                                   body: "It works!"),
                                      sound: .normal("default"))
        
        return req.apns.send(payload, to: pushToken).map { .ok }
        //return req.apns.send(payload, to: device)
    }
}
