//
//  LocationManager.swift
//  Interface
//
//  Created by Phucnh on 12/9/20.
//

import CoreLocation

public typealias updateLocationHandler = (String, String) -> Void

public class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var manager: CLLocationManager
    var location: CLLocation
    var locationDes: String
    
    public static var shared: LocationManager = .init()
    
    public var didUpdateLocation: updateLocationHandler?
    
    override init() {
        manager = .init()
        location = CLLocation(latitude: 0, longitude: 0)
        locationDes = ""
        
        super.init()
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
    }
    
    public func updateLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let l = locations.first {
            manager.stopUpdatingLocation()
            location = l
            AppManager.shared.currentUser.location = "\(location.coordinate.latitude)-\(location.coordinate.longitude)- "

            print("<><>: \(location.coordinate.latitude)")
            print("<><>: \(location.coordinate.longitude)")


            let geocoder = CLGeocoder()

            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(
                l,
                completionHandler: { (placemarks, error) in
                    if error == nil {
                        let firstLocation = placemarks?[0]
                        print("country\(firstLocation?.country)")
                        print("administrativeArea\(firstLocation?.administrativeArea)")
                        print("subLocality\(firstLocation?.subLocality)")
                        print("locality\(firstLocation?.locality)")
                        print("subLocality\(firstLocation?.subLocality)")
                        print("thoroughfare\(firstLocation?.thoroughfare)")
                        print("subThoroughfare\(firstLocation?.subThoroughfare)")
                        
                        self.didUpdateLocation?("\(l.coordinate.latitude)-\(l.coordinate.longitude)", firstLocation?.description ?? "undefine")
                    }
                    else {
                        // An error occurred during geocoding.
                        print("<><>: An error occurred during geocoding")
                        self.didUpdateLocation?("undefine", "undefine")   
                    }
                })

        } else {
            location = CLLocation(latitude: 0, longitude: 0)
        }
    }
}
