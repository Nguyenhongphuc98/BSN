//
//  LocationManager.swift
//  Interface
//
//  Created by Phucnh on 12/9/20.
//

import CoreLocation
import Business

public typealias updateLocationHandler = (String, String) -> Void

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var manager: CLLocationManager
    @Published public var location: CLLocation
    @Published public var locationDes: String
    
    @Published public var permissionDenied: Bool
    
    private var userManager: UserManager
    
    public static var shared: LocationManager = .init()
    
    public var didUpdateLocation: updateLocationHandler?
    
    override init() {
        manager = .init()
        userManager = .init()
        location = CLLocation(latitude: 0, longitude: 0)
        locationDes = ""
        permissionDenied = false
        
        super.init()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        permissionDenied = manager.authorizationStatus == .restricted || manager.authorizationStatus == .denied
    }
    
    public func updateLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.first {
            manager.stopUpdatingLocation()
            location = l            

            let geocoder = CLGeocoder()

            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(
                l,
                completionHandler: { (placemarks, error) in
                    if error == nil {
                        let fl = placemarks?[0]
                        self.locationDes = ""
                        if let sublocality = fl?.subLocality {
                            self.locationDes += "\(sublocality), "
                        }
                        if let locality = fl?.locality {
                            self.locationDes += "\(locality), "
                        }
                        if let administrativeArea = fl?.administrativeArea {
                            self.locationDes += "\(administrativeArea)"
                        }
                        
                        self.didUpdateLocation?("\(l.coordinate.latitude)-\(l.coordinate.longitude)", self.locationDes)
                    }
                    else {
                        // An error occurred during geocoding.
                        print("<><>: An error occurred during geocoding")
                        self.didUpdateLocation?("0-0", "undefine")
                    }
                })

        } else {
            location = CLLocation(latitude: 0, longitude: 0)
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        permissionDenied = manager.authorizationStatus == .restricted || manager.authorizationStatus == .denied       
    }
    
    public func updateToSever(location: String? = nil) {
        let user = EUser(
            id: AppManager.shared.currenUID,
            location: location
        )
               
        userManager.updateUser(user: user)
        AppManager.shared.currentUser.location = location ?? "Địa chỉ Không xác định"
        AppManager.shared.objectWillChange.send()
    }
}
