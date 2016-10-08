//
//  ViewController.swift
//  HotelApp
//
//  Created by Konstantinos Loutas on 10/07/16.
//  Copyright © 2016 Constantine Lutas. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var beaconNameLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set ourselves as the CLLocationManager delegate for our locationManager
        locationManager.delegate = self
        
        // Request permission to use location services
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        // Setup our fake iPad beacon
        setupBeacon(withUuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Managing iBeacons
extension ViewController {
    
    func setupBeacon(withUuidString uuidString: String) {
        
        // Enter Your iBeacon UUID
        let uuid = UUID(uuidString: uuidString)!
        
        // Use identifier like your company name or website
        let identifier = "com.CLutas.fakeBeacon.iPadAir"
        
        let Major:CLBeaconMajorValue = 0
        let Minor:CLBeaconMinorValue = 0
        
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: Major, minor: Minor, identifier: identifier)
        
        // call delegate when Enter iBeacon Range
        beaconRegion.notifyOnEntry = true
        
        // call delegate when Exit iBeacon Range
        beaconRegion.notifyOnExit = true
        
        // Start monitoring the specified iBeacon Region
        locationManager.startRangingBeacons(in: beaconRegion)
//        locationManager.startMonitoring(for: beaconRegion)
        locationManager.pausesLocationUpdatesAutomatically = false
        
    }
    
}

// MARK: - Simple alerting
extension ViewController {
    func simpleAlert(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
            
        case .authorizedAlways, .authorizedWhenInUse:
            // Starts the generation of updates that report the user’s current location.
            locationManager.startUpdatingLocation()
            
        case .restricted:
            // Your app is not authorized to use location services.
            simpleAlert(title: "Permission Error", message: "Need Location Service Permission To Access Beacon")
            
            
        case .denied:
            // The user explicitly denied the use of location services for this app or location services are currently disabled in Settings.
            simpleAlert(title: "Permission Error", message: "Need Location Service Permission To Access Beacon")
            
        default:
            // handle .NotDetermined here            
            // The user has not yet made a choice regarding whether this app can use location services.
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        // Tells the delegate that a iBeacon Area is being monitored
        locationManager.requestState(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        switch  state {
            
        case .inside:
            //The user is inside the iBeacon range.
            locationManager.startRangingBeacons(in: region as! CLBeaconRegion)
            break
            
        case .outside:
            //The user is outside the iBeacon range.
            locationManager.stopRangingBeacons(in: region as! CLBeaconRegion)
            break
            
        default :
            // it is unknown whether the user is inside or outside of the iBeacon range.
            break
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("didEnterRegion with identifier \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("didExitRegion with identifier \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if !beacons.isEmpty {
            let currentDateTime = DateFormatter.localizedString(from: Date(), dateStyle: .medium, timeStyle: .medium)
            lastSeenLabel.text = currentDateTime
            beaconNameLabel.text = region.identifier
        }
    }
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("Ranging failed with error \(error.localizedDescription)")
    }
    
}
