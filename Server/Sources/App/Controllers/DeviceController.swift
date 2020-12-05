//
//  DeviceController.swift
//  
//
//  Created by Phucnh on 12/4/20.
//

import Vapor
import APNS

struct DeviceController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let group = routes.grouped("api", "v1", "devices")
        //group.put("update", use: put)
        group.post(use: create)
        group.post(":id", "test-push", use: sendTestPush)
    }
    
    func create(req: Request) throws -> EventLoopFuture<Device> {
        let device = try req.content.decode(Device.self)
        return device.save(on: req.db).map { device }
    }
    
//    func put(_ req: Request) throws -> EventLoopFuture<Response> {
//        let updateDeviceData = try req.content.decode(UpdateDevice.self)
//
//        if let deviceId = updateDeviceData.id {
//            var existingDevice: Device!
//
//            return Device.find(deviceId, on: req.db)
//                .unwrap(or: Abort(.notFound))
//                .flatMap { device in
//                    existingDevice = device
//
//                    existingDevice.osVersion = updateDeviceData.osVersion
//                    existingDevice.pushToken = updateDeviceData.pushToken
//                    existingDevice.channels = updateDeviceData.channels?.toChannelsString() ?? ""
//
//                    return existingDevice.save(on: req.db).flatMap {
//                        do {
//                            return try existingDevice.toPublic().encodeResponse(status: .ok, for: req)
//                        } catch {
//                            return req.eventLoop.makeFailedFuture(error)
//                        }
//                    }
//                }
//        }
//
//        let newDevice = Device(system: updateDeviceData.system,
//                               osVersion: updateDeviceData.osVersion,
//                               pushToken: updateDeviceData.pushToken,
//                               channels: updateDeviceData.channels)
//        return newDevice.save(on: req.db).flatMap {
//            do {
//                return try newDevice.toPublic().encodeResponse(status: .created, for: req)
//            } catch {
//                return req.eventLoop.makeFailedFuture(error)
//            }
//        }
//    }
    
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
}
