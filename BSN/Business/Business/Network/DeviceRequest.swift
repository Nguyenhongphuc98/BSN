//
//  DeviceRequest.swift
//  Business
//
//  Created by Phucnh on 12/5/20.
//

class DeviceRequest: ResourceRequest<EDevice> {
    
    func saveDevice(device: EDevice) {
        self.resetPath()
        
        self.save(device) { result in
            switch result {
            case .failure:
                let message = "There was an error save device"
                print(message)
                
            case .success(let d):
                print("Save device success: \(d.pushToken)")
            }
        }
    }
}
