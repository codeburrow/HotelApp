//
//  TrackingManager.swift
//  HotelApp
//
//  Created by Konstantinos Loutas on 10/12/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import Foundation
import CoreLocation

class TrackingManager: NSObject, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    // Request permission to use location services
    func requestAlwaysPermissionForLocationServices() {
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            // Starts the generation of updates that report the user’s current location.
            simpleAlert(title: "Authorised", message: "locationManager(_:didChangeAuthorization:) - \(status) authorisation granted")
            locationManager.startUpdatingLocation()
            
        case .restricted:
            // Your app is not authorized to use location services.
            simpleAlert(title: "Permission Error", message: "locationManager(_:didChangeAuthorization:) - Need Location Service Permission To Access Beacon")
            
            
        case .denied:
            // The user explicitly denied the use of location services for this app or location services are currently disabled in Settings.
            simpleAlert(title: "Permission Error", message: "locationManager(_:didChangeAuthorization:) - Need Location Service Permission To Access Beacon")
            
        default:
            // handle .NotDetermined here
            // The user has not yet made a choice regarding whether this app can use location services.
            break
        }
    }

}

// MARK: - Simple alerting
extension TrackingManager {
    func simpleAlert(title:String, message:String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        print("\(title): \(message)")
//        self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

